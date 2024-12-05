import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/appointment_model.dart';

class AddAppointmentDialog extends StatefulWidget {
  final void Function(AppointmentModel) onSaveAppointment;
  final DateTime thisBarDate;

  AddAppointmentDialog({required this.onSaveAppointment, required this.thisBarDate});

  @override
  _AddAppointmentDialogState createState() => _AddAppointmentDialogState();
}

class _AddAppointmentDialogState extends State<AddAppointmentDialog> {
  final _formKey = GlobalKey<FormState>();
  late FocusNode _focusNode;   //创建键盘焦点，使其默认激活
  late AppointmentModel _newAppointment;
  late TextEditingController _subjectController;

  late bool _isChosenStart = false;
  late bool _isChosenEnd = false;


  @override
  void initState() {
    super.initState();
    _newAppointment = AppointmentModel(
      subject: '',
      startTime: widget.thisBarDate,
      endTime: widget.thisBarDate.add(Duration(hours: 1)),
      state: "undone",
    );
    _subjectController = TextEditingController(text: _newAppointment.subject);
    _focusNode = FocusNode();  // 初始化 FocusNode
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();  // 请求焦点
    });
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _saveAppointment() {
    final formState = _formKey.currentState;
    if (formState != null) {
      final isValid = formState.validate();
      if (isValid) {
        formState.save();
        widget.onSaveAppointment(_newAppointment);
        Navigator.of(context).pop();
      }
    } else {
      print('Form state is null');
    }
  }


  void _handelSubmit() {   //提交
    final _subjectText = _subjectController.text;
    _newAppointment.subject = _subjectText;
    _saveAppointment();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      height: 400.h,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16.h),
            Container(
                width: double.infinity,
                height: 60.h,
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                      ),
                      width: 250.w,
                      height: 45.h,
                      child: TextFormField(
                        controller: _subjectController,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          labelText: '任务',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '任务内容不能为空';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _newAppointment.subject = value!; // 保存验证通过的值
                        },
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Container(
                        width: 60.w,
                        height: 45.h,
                        child: OutlinedButton(
                          style: ButtonStyle(
                            // backgroundColor: WidgetStateProperty.all(Colors.blue),
                              side: WidgetStateProperty.all(BorderSide(color: Colors.blue,width: 2)),
                              minimumSize: WidgetStateProperty.all(Size(double.infinity, 40)),
                              maximumSize: WidgetStateProperty.all(Size(double.infinity, 40)),
                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  )
                              )
                          ), onPressed: () { _handelSubmit(); }, child: Center(child: Icon(Icons.add,size: 20.r,)),
                        )
                    )

                  ],
                )
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _startTimePicker(),
                  SizedBox(width: 16.w),
                  _endTimePicker(),
                  SizedBox(width: 16.w),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _startTimePicker() {
    return Container(
      width: 150.w,
      height: 40.h,
      child: OutlinedButton(
        style: ButtonStyle(
          // backgroundColor: _isChosenEnd == true ? WidgetStateProperty.all(Colors.blue)
          //     : WidgetStateProperty.all(Colors.red),
          minimumSize: WidgetStateProperty.all(Size(double.infinity, 40)),
          maximumSize: WidgetStateProperty.all(Size(double.infinity, 40)),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        onPressed: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: _newAppointment.startTime,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (picked != null) {
            setState(() {
              _isChosenStart = true;
              _newAppointment.startTime = picked;
              _newAppointment.endTime = _newAppointment.endTime.isAfter(picked) ?
              _newAppointment.endTime : picked;
            });
          }
        },
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.calendar_month),
              SizedBox.fromSize(size: Size(8.w, 0)),
              if (_isChosenStart)
                Text('${_newAppointment.startTime.toString().split(' ')[0]}',
                  textAlign: TextAlign.center,),
              if (!_isChosenStart)
                Text('设置起始日期',style: TextStyle(fontSize: 12.sp),),
            ],
          ),
        ),
      ),
    );
  }

  Widget _endTimePicker() {
    return Container(   // 结束日期
      width: 150.w,
      height: 40.h,
      child: OutlinedButton(
        style: ButtonStyle(
          // backgroundColor: _isChosenEnd == true ? WidgetStateProperty.all(Colors.blue)
          //     : WidgetStateProperty.all(Colors.red),
          minimumSize: WidgetStateProperty.all(Size(double.infinity, 40)),
          maximumSize: WidgetStateProperty.all(Size(double.infinity, 40)),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        onPressed: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: _newAppointment.startTime,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (picked != null) {
            setState(() {
              _isChosenEnd = true;
              _newAppointment.endTime = picked;
              _newAppointment.endTime = _newAppointment.endTime.isAfter(_newAppointment.startTime) ?
              _newAppointment.endTime : _newAppointment.startTime;
            });
          }
        },
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.event),
              SizedBox.fromSize(size: Size(8.w, 0)),
              if (_isChosenEnd)
                Text('${_newAppointment.endTime.toString().split(' ')[0]}',
                  textAlign: TextAlign.center,),
              if (!_isChosenEnd)
                Text('设置截止日期',style: TextStyle(fontSize: 12.sp)),
            ],
          ),
        ),
      ),
    );
  }
}