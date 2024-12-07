import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../models/appointment_model.dart';
import '../../repo/db/db_helper.dart';

class GeneralViewModel extends ChangeNotifier {

  late List<AppointmentModel> GeneralAppointments = [];
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  // 在 _CalendarPageState 类中添加 _appointmentDataSource 变量
  late _AppointmentDataSource appointmentDataSource;// 临时储存日程

  //临时储存日程（calenderList部分）
  late List<AppointmentModel> appointments = [];
  bool isInitialized = false;

  // 临时储存日程（HomeList部分）
  late List<DateTime> LastDate = [];  //近n天日期索引List
  late Map<DateTime, List<AppointmentModel>> tasksByDate = {};   //创建临时Task数据集合

  bool _isLoading = false;  //锁定
  bool get isLoading => _isLoading;


  // 私有构造函数
  GeneralViewModel._internal();
  static final GeneralViewModel _instance = GeneralViewModel._internal();
  factory GeneralViewModel() => _instance;

  //初始化viewmodel
  Future<void> initCalendarDateSource() async{
    appointmentDataSource = await _AppointmentDataSource(GeneralAppointments);
    await generateLastDates(DateTime.now());
      await loadAppointmentsALL().then((onValue) async {
        await getTasksByDate().then((onValue){
          isInitialized = true;
          notifyListeners();
        });
      });

  }

  //根据date筛选（在Load之后才能使用）  ==>> List<AppointmentModel>
  Future<void> getAppointmentsByDate(DateTime date) async {

    _isLoading = true;
    notifyListeners();

    appointments.clear();
    appointments = await GeneralAppointments.where((appointment) {
      return appointment.startTime.isBefore(date.add(Duration(days: 1))) &&
          appointment.endTime.isAfter(date.subtract(Duration(seconds: 1)));
    }).toList();

    _isLoading = false;
    notifyListeners();   //解锁

  }

  //获取LateDate的每日内容，并且修改taskByDate
  Future<void> getTasksByDate() async {
    tasksByDate.clear();
    for (var date in LastDate) {
      List<AppointmentModel> tasks = await GeneralAppointments.where((appointment) {
        return appointment.startTime.isBefore(date.add(Duration(days: 1))) &&
            appointment.endTime.isAfter(date.subtract(Duration(seconds: 1)));
      }).toList();
      tasksByDate[date] = tasks;
    }
    notifyListeners();
  }

  //获取所有日程
  Future<void> loadAppointmentsALL() async {
    await _dbHelper.queryAllAppointments().then((appointments) async {
      await getTasksByDate().then((onValue){
        GeneralAppointments = appointments;
        appointmentDataSource = _AppointmentDataSource(GeneralAppointments);
        notifyListeners();
      });
    });
  }

  // 获取指定日期范围的日程
  Future<void> loadAppointmentsINRANGE({DateTime? startDate, DateTime? endDate}) async {
    await _dbHelper.queryAppointmentsByDateRange(startDate!, endDate!).then((appointments) {
      GeneralAppointments = appointments;
      appointmentDataSource = _AppointmentDataSource(GeneralAppointments);
      notifyListeners();
    });
  }

  // 添加日程
  Future<void> addAppointment(AppointmentModel appointment) async {
    await _dbHelper.insertAppointment(appointment).then((todo_id) async {
      appointment.todo_id = todo_id;
      GeneralAppointments.add(appointment);
      appointmentDataSource = _AppointmentDataSource(GeneralAppointments);
      notifyListeners();
      // _printDatabaseContent();
    });
  }

  // 删除日程
  Future<void> deleteAppointment(AppointmentModel appointment) async {
    if (appointment.todo_id != null) {
      // print("Delete ID: ${appointment.id}");
      await _dbHelper.deleteAppointment(appointment.todo_id!).then((value){
        // _printDatabaseContent();
        GeneralAppointments.remove(appointment);
        appointmentDataSource = _AppointmentDataSource(GeneralAppointments);
        notifyListeners();
      });
    } else {
      // 如果 id 为 null,可以考虑打印错误日志或者给出提示
      print('无法删除 appointment,因为 id 为 null');
    }

  }

  // 修改（完成/取消完成）日程
  Future<void>finishAppointment(AppointmentModel appointment, bool Cancel) async {
    await _dbHelper.updateAppointment(appointment).then((value) async {
      await getTasksByDate().then((onValue){
        // appointment.state = Cancel == true ? "undone" : "done";
        appointmentDataSource = _AppointmentDataSource(GeneralAppointments);
        _printDatabaseContent();
        notifyListeners();
      });
    });

  }

  //生成近n天日期索引
  Future<void> generateLastDates(DateTime baseDate) async {
    LastDate.clear();
    baseDate = DateTime(baseDate.year, baseDate.month, baseDate.day);
    baseDate = baseDate.subtract(Duration(days: 1));
    for (int i = 0; i < 10; i++) {
      LastDate.add(baseDate.add(Duration(days: i)));
    }
  }



  //输出数据库内容
  void _printDatabaseContent() async {
    await DatabaseHelper.instance.printAllTables();
  }
}



// 自定义数据源，用于将AppointmentModel转换为Syncfusion可识别的Appointment
class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<AppointmentModel> source) {
    appointments = source.map((model) {
      return AppointmentModel(
        todo_id: model.todo_id,
        state: model.state,
        startTime: model.startTime,
        subject: model.subject,
        endTime: model.endTime,
        notes: model.notes,
      );
    }).toList();
  }
}