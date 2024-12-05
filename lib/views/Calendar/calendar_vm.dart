import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../models/appointment_model.dart';
import '../../repo/db/db_helper.dart';

class CalendarViewModel extends ChangeNotifier {

  late List<AppointmentModel> CalendarAppointments = [];
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  // 在 _CalendarPageState 类中添加 _appointmentDataSource 变量
  late _AppointmentDataSource appointmentDataSource;// 临时储存日程

  Future<void> initCalendarDateSource() async{
    appointmentDataSource = await _AppointmentDataSource(CalendarAppointments);
    await loadAppointments();
    notifyListeners();
  }


  Future<void> loadAppointments() async {
    await _dbHelper.queryAllAppointments().then((appointments){
      CalendarAppointments = appointments;
      appointmentDataSource = _AppointmentDataSource(CalendarAppointments);
    });
    notifyListeners();
  }

  Future<void> addAppointment(AppointmentModel appointment) async {
    await _dbHelper.insertAppointment(appointment).then((id){
      appointment.id = id;
      CalendarAppointments.add(appointment);
      appointmentDataSource = _AppointmentDataSource(CalendarAppointments);
      notifyListeners();
    });
  }

  Future<void> deleteAppointment(AppointmentModel appointment) async {
    if (appointment.id != null) {
      // print("Delete ID: ${appointment.id}");
      await _dbHelper.deleteAppointment(appointment.id!).then((value){
        _printDatabaseContent();
        CalendarAppointments.remove(appointment);
        appointmentDataSource = _AppointmentDataSource(CalendarAppointments);
        notifyListeners();
      });
    } else {
      // 如果 id 为 null,可以考虑打印错误日志或者给出提示
      print('无法删除 appointment,因为 id 为 null');
    }

  }

  Future<void>finishAppointment(AppointmentModel appointment, bool Cancel) async {
    await _dbHelper.updateAppointment(appointment).then((value){
      // appointment.state = Cancel == true ? "undone" : "done";
      appointmentDataSource = _AppointmentDataSource(CalendarAppointments);
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
        id: model.id,
        state: model.state,
        startTime: model.startTime,
        subject: model.subject,
        endTime: model.endTime,
        notes: model.notes,
      );
    }).toList();
  }
}