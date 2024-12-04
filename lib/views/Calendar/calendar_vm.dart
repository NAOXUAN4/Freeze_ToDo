import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../models/appointment_model.dart';
import '../../repo/db/db_helper.dart';

class CalendarViewModel with ChangeNotifier {

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
    });
    notifyListeners();
  }

  Future<void> deleteAppointment(appointment) async {
    if (appointment.id != null) {
      print("Delete ID: ${appointment.id}");
      await _dbHelper.deleteAppointment(appointment.id!).then((value){
        _printDatabaseContent();
        CalendarAppointments.remove(appointment);
        appointmentDataSource = _AppointmentDataSource(CalendarAppointments);
      });
    } else {
      // 如果 id 为 null,可以考虑打印错误日志或者给出提示
      print('无法删除 appointment,因为 id 为 null');
    }
    notifyListeners();
  }

  void _printDatabaseContent() async {
    await DatabaseHelper.instance.printAllTables();
  }


}

class ToDoAppointment extends Appointment {
  final int? id;
  final String state;

  ToDoAppointment({
    this.id,
    required this.state,
    required DateTime startTime,
    required DateTime endTime,
    required String subject,
    String? notes,
    Color ?color,
  }) : super(
    startTime: startTime,
    endTime: endTime,
    subject: subject,
    notes: notes,
  );
}


// 自定义数据源，用于将AppointmentModel转换为Syncfusion可识别的Appointment
class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<AppointmentModel> source) {
    appointments = source.map((model) {
      return ToDoAppointment(
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