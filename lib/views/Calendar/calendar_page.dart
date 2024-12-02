import 'package:ca_tl/views/Calendar/calendar_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:oktoast/oktoast.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../models/appointment_model.dart';
import '../../repo/db/db_helper.dart';
import '../../theme.dart';
import '../commonUi/addTodo_widget.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  List<AppointmentModel> _appointments = [];
  late CalendarViewModel ViewModel;
  late CalendarController _calendarController;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;   //创建数据操作对象

  @override
  void initState() {
    super.initState();
    ViewModel = CalendarViewModel();
    _loadAppointments();
    _calendarController = CalendarController();
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    final appointments = await _dbHelper.queryAllAppointments();
    setState(() {
      _appointments = appointments;
    });
  }

  Future<void> _addAppointment(AppointmentModel appointment) async {
    final id = await _dbHelper.insertAppointment(appointment);
    appointment.id = id;
    setState(() {
      _appointments.add(appointment);
    });
  }

  Future<void> _deleteAppointment(appointment) async {
    if (appointment.id != null) {
      print(appointment.id);
      await _dbHelper.deleteAppointment(appointment.id!).then((value){
        _printDatabaseContent();
      });
      setState(() {
        _appointments.remove(appointment);
      });
    } else {
      // 如果 id 为 null,可以考虑打印错误日志或者给出提示
      print('无法删除 appointment,因为 id 为 null');
    }
  }

  void _printDatabaseContent() async {
    await DatabaseHelper.instance.printAllTables();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,   //防止键盘影响布局
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: theme.Default_gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: [
                _Calendar()
              ],
            ),
          ),
        ),
      ),
      floatingActionButton:
      FloatingActionButton(
        heroTag: "add_cal",
        onPressed: () {
          _showAddAppointmentDialog();
        },
        tooltip: 'First Action',
        backgroundColor: HexColor("#96e1fb").withOpacity(0.5),
        child: Icon(Icons.add, size: 25.w,
          color: Colors.white,),
      ),
    );
  }

  void _showAddAppointmentDialog() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return AddAppointmentDialog(
          onSaveAppointment: (appointment) {
            // 保存新建的日程
            _addAppointment(appointment).then((value){
              showToast('添加成功');
            });
          },
        );
      },
    );
  }


  Widget _Calendar() {
    return Expanded(
      child: SfCalendar(
        todayHighlightColor: Colors.white.withOpacity(0.5),
        todayTextStyle: TextStyle(color: Colors.white),
        selectionDecoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5.r),
        ),
        cellBorderColor: Colors.white.withOpacity(0.5),
        view: CalendarView.month,
        controller: _calendarController,
        dataSource: _AppointmentDataSource(_appointments),   //数据源
        initialDisplayDate: DateTime.now(),
        onTap: (details) {
          if (details.appointments != null && details.appointments!.isNotEmpty) {
            final appointment = details.appointments![0];
            showModalBottomSheet(context: context, builder: (BuildContext context){    //下方弹窗
              return Container(
                margin: EdgeInsets.symmetric(horizontal:10.w),
                height: 400.h,
                width: 320.w,
                child: _list(details: details),
              );
            }, backgroundColor: Colors.white.withOpacity(0.3),
            );
          }
        },),);
  }

  Widget _list({required CalendarTapDetails details }){   //每日卡片列表
    return Container(
        height: double.infinity,
        child: ListView.builder(
            itemCount: details.appointments?.length,
            itemBuilder: (context,index){
              return Container(
                height: 100.h,
                width: double.infinity,
                child: _listItems(index: index,
                    onTrick: (){
                      _deleteAppointment(
                        details.appointments?[index]
                      );
                      showToast('删除成功');

                    },
                    details: details),
              );
            }
        )
    );
  }

  Widget _listItems({required int index,
    required GestureTapCallback onTrick,
    required CalendarTapDetails details}){
    return Container(
        margin: EdgeInsets.only(left: 10.w,top: 12.h,right: 10.w),
        height: 100.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.white.withOpacity(0.2),
          boxShadow: theme.Default_boxShadow,
        ),
        child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color: Colors.white.withOpacity(0.1),
                ),
                margin: EdgeInsets.only(left: 20.w),
                width: 40.w,
                height: 40.h,
                child: Center(
                    child: GestureDetector(
                      onTap: onTrick,
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                        size: 30.w,
                      ),
                    )
                ),
              ),
              Container(
                child: GestureDetector(
                  onTap: () {setState(() {
                    showToast('onTapCArd');
                  });},
                  child: Container(
                    padding: EdgeInsets.all(20.w),
                    height: 80.h,
                    width: 215.w,
                    margin: EdgeInsets.only(left: 10.w,top: 10.h,bottom: 10.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: Colors.white.withOpacity(0.1),
                    ),
                    child: Text(
                      "${details.appointments![index].subject}",
                      style: TextStyle(color: Colors.white,fontSize: 15.sp,fontFamily: 'Poppins'),),

                  ),
                ),
              ),
            ]
        )
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: SfCalendar(
  //       view: CalendarView.month,
  //       dataSource: _AppointmentDataSource(_appointments),
  //       onTap: (CalendarTapDetails details) {
  //         // 处理日历点击事件
  //       },
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: () {
  //         // 添加新的约会
  //         final newAppointment = AppointmentModel(
  //           subject: '新约会',
  //           startTime: DateTime.now(),
  //           endTime: DateTime.now().add(Duration(hours: 1)),
  //         );
  //         _addAppointment(newAppointment);
  //       },
  //       child: Icon(Icons.add),
  //     ),
  //   );
  // }

}

// 自定义数据源，用于将AppointmentModel转换为Syncfusion可识别的Appointment
class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<AppointmentModel> source) {
    appointments = source.map((model) {
      return Appointment(
        startTime: model.startTime,
        subject: model.subject,
        endTime: model.endTime,
        notes: model.notes,
        color: model.color != null ? Color(int.parse(model.color!)) : Colors.blue,
      );
    }).toList();
  }
}