import 'dart:ui';

import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentModel {
  int? id;
  String state;
  String subject;
  DateTime startTime;
  DateTime endTime;
  String? notes;

  AppointmentModel({
    this.id,
    required this.state,
    required this.subject,
    required this.startTime,
    required this.endTime,
    this.notes,
  });

  // 将对象转换为Map，用于数据库存储
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'state': state,
      'subject': subject,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'notes': notes,
    };
  }

  // 从Map创建对象，用于数据库读取
  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'],
      state: map['state'],
      subject: map['subject'],
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      notes: map['notes'],
    );
  }


  static AppointmentModel appointmentsToModel(appointment){
    return appointment.map((e) => AppointmentModel(
      id: e.id,
      state: e.state,
      subject: e.subject,
      startTime: e.startTime,
      endTime: e.endTime,
      notes: e.notes,
    )).toList();;
  }



}