// appointment_model.dart
import 'dart:convert';
import 'dart:ui';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentModel {
  final DateTime startTime;
  final DateTime endTime;
  final String subject;
  final Color color;

  AppointmentModel({
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'subject': subject,
      'color': color.value,
    };
  }

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      subject: json['subject'],
      color: Color(json['color']),
    );
  }

  Appointment toAppointment() {
    return Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: subject,
      color: color,
    );
  }
}
