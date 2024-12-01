// add_event_page.dart
import 'package:ca_tl/repo/data/CalendarDataSource.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart'; // 用于日期格式化

class AddToDoPage extends StatefulWidget {
  // final Function(Appointment) onToDoAdded;

  // AddToDoPage({required this.onToDoAdded});

  @override
  _AddToDoPageState createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  final TextEditingController _subjectController = TextEditingController();
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now().add(Duration(hours: 1));

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startTime)
      setState(() {
        _startTime = DateTime(picked.year, picked.month, picked.day, _startTime.hour, _startTime.minute);
      });
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _endTime)
      setState(() {
        _endTime = DateTime(picked.year, picked.month, picked.day, _endTime.hour, _endTime.minute);
      });
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_startTime),
    );
    if (picked != null && picked != TimeOfDay.fromDateTime(_startTime))
      setState(() {
        _startTime = DateTime(_startTime.year, _startTime.month, _startTime.day, picked.hour, picked.minute);
      });
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_endTime),
    );
    if (picked != null && picked != TimeOfDay.fromDateTime(_endTime))
      setState(() {
        _endTime = DateTime(_endTime.year, _endTime.month, _endTime.day, picked.hour, picked.minute);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Event'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(labelText: 'Event Title'),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Start Date: ${DateFormat.yMd().format(_startTime)}'),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _selectStartDate(context),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Start Time: ${DateFormat.Hm().format(_startTime)}'),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _selectStartTime(context),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('End Date: ${DateFormat.yMd().format(_endTime)}'),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _selectEndDate(context),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('End Time: ${DateFormat.Hm().format(_endTime)}'),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _selectEndTime(context),
                ),
              ],
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                if (_subjectController.text.isNotEmpty && _startTime.isBefore(_endTime)) {
                  final newEvent = Appointment(
                    startTime: _startTime,
                    endTime: _endTime,
                    subject: _subjectController.text,
                    color: Colors.blue,
                  );
                  // widget.onToDoAdded(newEvent);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter valid event details')),
                  );
                }
              },
              child: Text('Add Event'),
            ),
          ],
        ),
      ),
    );
  }
}
