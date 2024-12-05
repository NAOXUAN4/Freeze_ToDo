import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../models/appointment_model.dart';
import '../../repo/db/db_helper.dart';

class HomepageViewModel extends ChangeNotifier{
  // TODO: HomepageViewModel

  late List<AppointmentModel> HomeAppointments = [];
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  // 在 _CalendarPageState 类中添加 _appointmentDataSource 变量
  late _AppointmentDataSource appointmentDataSource;// 临时储存日程
  late List<DateTime> LastDate = [];  //近期日期List

  Future<void> initHomeListDateSource(DateTime dateTime) async{
    appointmentDataSource = await _AppointmentDataSource(HomeAppointments);
    await generateLastTenDays(DateTime.now());
    // await loadAppointments();
    notifyListeners();
  }

  List<DateTime> generateLastTenDays(DateTime baseDate) {
    for (int i = 0; i < 10; i++) {
      LastDate.add(baseDate.subtract(Duration(days: i)));
    }
    return LastDate;
  }


  // Future<void> loadAppointments({DateTime? startDate, DateTime? endDate}) async {
  //   startDate ??= DateTime.now().subtract(Duration(days: 10));
  //   endDate ??= DateTime.now().add(Duration(days: 1));
  //
  //   await _dbHelper.queryAppointmentsInRange(startDate, endDate).then((appointments) {
  //     HomeAppointments = appointments;
  //     appointmentDataSource = _AppointmentDataSource(HomeAppointments);
  //     notifyListeners();
  //   });
  // }

  Future<void> addAppointment(AppointmentModel appointment) async {
    await _dbHelper.insertAppointment(appointment).then((todo_id){
      appointment.todo_id = todo_id;
      HomeAppointments.add(appointment);
      appointmentDataSource = _AppointmentDataSource(HomeAppointments);
      notifyListeners();
    });
  }

  Future<void> deleteAppointment(AppointmentModel appointment) async {
    if (appointment.todo_id != null) {
      // print("Delete ID: ${appointment.id}");
      await _dbHelper.deleteAppointment(appointment.todo_id!).then((value){
        _printDatabaseContent();
        HomeAppointments.remove(appointment);
        appointmentDataSource = _AppointmentDataSource(HomeAppointments);
        notifyListeners();
      });
    } else {
      // 如果 id 为 null,可以考虑打印错误日志或者给出提示
      print('无法删除 appointment,因为 todo_id 为 null');
    }

  }

  Future<void>finishAppointment(AppointmentModel appointment, bool Cancel) async {
    await _dbHelper.updateAppointment(appointment).then((value){
      // appointment.state = Cancel == true ? "undone" : "done";
      appointmentDataSource = _AppointmentDataSource(HomeAppointments);
    });
    notifyListeners();
  }

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