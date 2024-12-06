import 'package:ca_tl/models/appointment_model.dart';
import 'package:ca_tl/models/general_vm.dart';
import 'package:ca_tl/views/Calendar/calendar_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../theme.dart';
import '../commonUi/addTodo_widget.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late CalendarController _calendarController;
  @override
  void initState(){
    super.initState();
    _calendarController = CalendarController();
  }


  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GeneralViewModel>(
      builder: (context,vm,child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,   //防止键盘影响布局
          body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              // gradient: LinearGradient(
              //   colors: theme.Default_gradient,
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              // ),
              image: DecorationImage(
                image: theme.Default_BackGround,
                fit: BoxFit.cover,
              )
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: Column(
                      children: [
                        vm.isInitialized ? _Calendar() : CircularProgressIndicator(),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 50.h,
                    right: 30.w,
                    child: FloatingActionButton(
                      heroTag: "add_cal",
                      onPressed: () {
                        _showAddAppointmentDialog();
                      },
                      tooltip: 'add ACTION',
                      backgroundColor: HexColor("#96e1fb").withOpacity(0.5),
                      child: Icon(Icons.add, size: 25.w,
                        color: Colors.white,),
                    ),
                  ),
                ]
              ),
            ),
          ),
        );
      }
    );
  }

  //添加任务组件 --------------------------------------------------------------->>
  void _showAddAppointmentDialog() {
    final ViewModel = Provider.of<GeneralViewModel>(context,listen: false);
    showModalBottomSheet(
      backgroundColor: Colors.white.withOpacity(0.8),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return AddAppointmentDialog(
          onSaveAppointment: (appointment) {
            // 保存新建的日程
            ViewModel.addAppointment(appointment).then((value){
              ScaffoldMessenger.of(context).showSnackBar(   //下方弹出框
                SnackBar(content: Text('已添加')),
              );
            });
          }, initialDate: DateTime.now(),
        );
      },
    );
  }
  //<<----------------------------------------------------------------添加任务组件

  //日历组件------------------------------------------------------------------->>
  Widget _Calendar() {
    return Consumer<GeneralViewModel>(builder: (context,vm,child){
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
          dataSource: vm.appointmentDataSource,   //数据源
          initialDisplayDate: DateTime.now(),
          onTap: (details) {
            if (1 == 1) {
              showModalBottomSheet(context: context, builder: (BuildContext context){  //详情弹窗
                return _list(date: details.date);
              }, backgroundColor: Colors.white.withOpacity(0.3),
              );
            }
          },),);
    });
  }

  //<<----------------------------------------------------------------日历组件
  //日历卡片列表----------------------------------------------------------------->>
  Widget _list({required DateTime? date}){   //每日卡片列表
    final ViewModel = Provider.of<GeneralViewModel>(context,listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ViewModel.getAppointmentsByDate(date!).then((value) {
        // 处理获取到的数据
      });
    });
    return Consumer<GeneralViewModel>(
            builder: (context,vm,child) {
              return Container(
                  height: double.infinity,
                  child: vm.appointments.length != 0 ? ListView.builder(
                          itemCount: vm.appointments.length,
                          itemBuilder: (context,index){
                            return Container(
                              height: 100.h,
                              width: double.infinity,
                              child: _listItems(index: index,
                                  onDelete: (){
                                    vm.deleteAppointment(
                                        vm.appointments[index]
                                    ).then((onValue){
                                      vm.loadAppointmentsALL();
                                      vm.getAppointmentsByDate(date!);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(   //下方弹出框
                                      SnackBar(content: Text('${vm.appointments[index].subject} 已移除')),
                                    );
                                  },
                                  onFinish: (){
                                    vm.appointments[index].state =
                                      vm.appointments[index].state == "done" ? "undone" : "done";
                                      vm.tasksByDate[date]?[index].state == "done" ? "undone" : "done";
                                    // print("${details.appointments?[index].subject} : is ${details.appointments?[index].state}");
                                    vm.finishAppointment(
                                        vm.appointments[index],
                                        vm.appointments[index].state == "done" ? true : false   //如果已完成再点一下就是未完成
                                    ).then((onValue){
                                      setState(() {
                                        vm.loadAppointmentsALL();
                                      });
                                    });
                                  }, appointments: vm.appointments,
                              ),
                            );
                          }
                      ) : Container(child: Center(child: Text('当日无任务',style: TextStyle(color: Colors.white,fontSize: 20.sp),)),)
              );
            }
          );
  }

  Widget _listItems({required int index,
    required GestureTapCallback onDelete,
    required GestureTapCallback onFinish,
    required List<AppointmentModel> appointments,}) {
    return Consumer<GeneralViewModel>(
        builder: (context, vm, child) {
          return Dismissible( //删除滑块
            key: Key(appointments[index].id.toString()),
            direction: DismissDirection.horizontal,
            confirmDismiss: (direction) async {
              return await showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                          title: Text('确定删除该任务？'),
                          actions: [
                            TextButton(
                              child: Text('取消'),
                              onPressed: () => Navigator.of(context).pop(false),
                            ),
                            TextButton(
                              child: Text('确定'),
                              onPressed: () => {Navigator.of(context).pop(true),onDelete()},
                            ),
                          ]
                      )
              );
            },
            child: Container(
                margin: EdgeInsets.only(left: 10.w, top: 12.h, right: 10.w),
                height: 100.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: Colors.white.withOpacity(0.2),
                  boxShadow: theme.Default_boxShadow,
                ),
                child: Row(
                    children: [
                      Consumer<GeneralViewModel>(
                          builder: (context, vm, child) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.r),
                                color: Colors.white.withOpacity(0.0),
                              ),
                              margin: EdgeInsets.only(left: 20.w),
                              width: 40.w,
                              height: 40.h,
                              child: Center(
                                  child: GestureDetector(
                                    onTap: onFinish,
                                    child: Icon(
                                      appointments[index].state == "undone"
                                          ? Icons.circle_outlined : Icons
                                          .check_circle,
                                      color: Colors.white,
                                      size: 30.w,
                                    ),
                                  )
                              ),
                            );
                          }
                      ),
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            print("Card OnTap");
                          },
                          child: Container(
                            padding: EdgeInsets.all(20.w),
                            height: 80.h,
                            width: 215.w,
                            margin: EdgeInsets.only(
                                left: 10.w, top: 10.h, bottom: 10.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              color: Colors.white.withOpacity(0.1),
                            ),
                            child: Text(
                              "${appointments[index].subject}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontFamily: 'Poppins',
                                  decoration: appointments[index].state ==
                                      "done"
                                      ? TextDecoration.lineThrough
                                      : null),),

                          ),
                        ),
                      ),
                    ]
                )
            ),
          );
        }
    );


    //<<----------------------------------------------------------------日历卡片列表

  }


}



