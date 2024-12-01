import 'package:syncfusion_flutter_calendar/calendar.dart';

class DataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }

  void addAppointment(Appointment appointment) {
    appointments!.add(appointment);
    notifyListeners(CalendarDataSourceAction.add, <Appointment>[appointment]);
  }

  void removeAppointment(Appointment appointment) {
    appointments!.remove(appointment);
    notifyListeners(CalendarDataSourceAction.remove, <Appointment>[appointment]);
  }

}
