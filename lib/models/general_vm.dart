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

  //临时储存日程
  late List<AppointmentModel> appointments = [];

  bool isInitialized = false;


  // 私有构造函数
  GeneralViewModel._internal();
  static final GeneralViewModel _instance = GeneralViewModel._internal();
  factory GeneralViewModel() => _instance;

  //初始化viewmodel
  Future<void> initCalendarDateSource() async{
    appointmentDataSource = await _AppointmentDataSource(GeneralAppointments);
    await loadAppointmentsALL().then((onValue){
      isInitialized = true;
      appointments.clear();
    });
    notifyListeners();
  }

  //根据date筛选（在Load之后才能使用）  ==>> List<AppointmentModel>
  Future<void> getAppointmentsByDate(DateTime date) async {
     appointments = await GeneralAppointments.where((appointment) {
      return appointment.startTime.isBefore(date.add(Duration(days: 1))) &&
          appointment.endTime.isAfter(date.subtract(Duration(days: 1)));
    }).toList();
     notifyListeners();
  }

  //根据date范围筛选（在Load之后才能使用） ==> Map<DateTime, List<AppointmentModel>> tasksByDate
  Future<Map<DateTime, List<AppointmentModel>>> getTasksByDateRange(DateTime baseDate, List<DateTime> LastDate) async {
    Map<DateTime, List<AppointmentModel>> tasksByDate = {};
    // 遍历日期列表
    for (DateTime date in LastDate) {
      // 过滤出该天的任务
      List<AppointmentModel> appointmentsForDate = GeneralAppointments.where((appointment) {
        return appointment.startTime.year == date.year &&
            appointment.startTime.month == date.month &&
            appointment.startTime.day == date.day;
      }).toList();

      DateTime dateTime = DateTime(date.year, date.month, date.day);
      // 将过滤后的任务列表存储到 Map 中
      tasksByDate[dateTime] = appointmentsForDate;
    }
    notifyListeners();
    return tasksByDate;
  }

  //获取所有日程
  Future<void> loadAppointmentsALL() async {
    await _dbHelper.queryAllAppointments().then((appointments){
      GeneralAppointments = appointments;
      appointmentDataSource = _AppointmentDataSource(GeneralAppointments);
      notifyListeners();
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
    await _dbHelper.insertAppointment(appointment).then((todo_id){
      appointment.todo_id = todo_id;
      GeneralAppointments.add(appointment);
      appointmentDataSource = _AppointmentDataSource(GeneralAppointments);
      notifyListeners();
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
    await _dbHelper.updateAppointment(appointment).then((value){
      // appointment.state = Cancel == true ? "undone" : "done";
      appointmentDataSource = _AppointmentDataSource(GeneralAppointments);
    });
    notifyListeners();
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