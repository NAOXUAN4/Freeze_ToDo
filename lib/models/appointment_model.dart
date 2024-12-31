import 'package:syncfusion_flutter_calendar/calendar.dart';
/// `AppointmentModel` 类继承自 `Appointment`，用于表示一个日程安排。
/// 包含以下属性：
/// - `todo_id`: 日程安排的唯一标识符。
/// - `state`: 日程安排的状态。
/// - `subject`: 日程安排的主题（这里做详情页）。
/// - `startTime`: 日程安排的开始时间。
/// - `endTime`: 日程安排的结束时间。
/// - `notes`: 日程安排的备注
class AppointmentModel extends Appointment{
  int? todo_id;
  String state;
  String subject;
  DateTime startTime;
  DateTime endTime;
  String? notes;

  AppointmentModel({
    this.todo_id,
    required this.state,
    required this.subject,
    required this.startTime,
    required this.endTime,
    this.notes,
  }) : super(
    startTime: startTime,
    endTime: endTime,
    subject: subject,
    notes: notes,
  );

  // 将对象转换为Map，用于数据库存储
  Map<String, dynamic> toMap() {
    return {
      'todo_id': todo_id,
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
      todo_id: map['todo_id'],
      state: map['state'],
      subject: map['subject'],
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      notes: map['notes'],
    );
  }


  static AppointmentModel appointmentsToModel(appointment){
    return appointment.map((e) => AppointmentModel(
      todo_id: e.todo_id,
      state: e.state,
      subject: e.subject,
      startTime: e.startTime,
      endTime: e.endTime,
      notes: e.notes,
    )).toList();;
  }



}