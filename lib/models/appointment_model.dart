import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentModel {
  int? id;
  String subject;
  DateTime startTime;
  DateTime endTime;
  String? notes;
  String? color;

  AppointmentModel({
    this.id,
    required this.subject,
    required this.startTime,
    required this.endTime,
    this.notes,
    this.color,
  });

  // 将对象转换为Map，用于数据库存储
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'notes': notes,
      'color': color,
    };
  }

  // 从Map创建对象，用于数据库读取
  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'],
      subject: map['subject'],
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      notes: map['notes'],
      color: map['color'],
    );
  }

  static AppointmentModel appointmentsToModel(appointment){
    return appointment.map((e) => AppointmentModel(
      subject: e.subject,
      startTime: e.startTime,
      endTime: e.endTime,
      notes: e.notes,
      color: e.color?.value.toString(),
    )).toList();;
  }



}