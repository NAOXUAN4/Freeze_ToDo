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

  CalendarViewModel ViewModel = CalendarViewModel();
  late CalendarController _calendarController;
  bool _isInitialized = false;

  @override
  void initState(){
    super.initState();

    ViewModel.initCalendarDateSource().then((_) {
      setState(() {
        _isInitialized = true;
        _calendarController = CalendarController();
      });
    });

  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CalendarViewModel>(create: (context){
      return ViewModel;
    },
      child: Scaffold(
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
            child: Stack(
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Column(
                    children: [
                      _isInitialized ? _Calendar() : CircularProgressIndicator(),
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
      )
    );
  }

  //添加任务组件 --------------------------------------------------------------->>
  void _showAddAppointmentDialog() {
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
          },
        );
      },
    );
  }
  //<<----------------------------------------------------------------添加任务组件

  //日历组件------------------------------------------------------------------->>
  Widget _Calendar() {
    return Consumer<CalendarViewModel>(builder: (context,vm,child){
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
              showModalBottomSheet(context: context, builder: (BuildContext context){    //下方弹窗
                return _list(details: details);
              }, backgroundColor: Colors.white.withOpacity(0.3),
              );
            }
          },),);
    });
  }

  //<<----------------------------------------------------------------日历组件
  //日历卡片列表----------------------------------------------------------------->>
  Widget _list({required CalendarTapDetails details }){   //每日卡片列表
      return Consumer<CalendarViewModel>(
        builder: (context,vm,child) {
          return Container(
              height: double.infinity,
              child: details.appointments?.length != 0 ? ListView.builder(
                      itemCount: details.appointments?.length,
                      itemBuilder: (context,index){
                        return Container(
                          height: 100.h,
                          width: double.infinity,
                          child: _listItems(index: index,
                              onDelete: (){
                                ViewModel.deleteAppointment(
                                    details.appointments?[index]
                                ).then((onValue){
                                  setState(() {
                                    ViewModel.loadAppointments();
                                  });
                                });
                                ScaffoldMessenger.of(context).showSnackBar(   //下方弹出框
                                  SnackBar(content: Text('${details.appointments![index].subject} 已移除')),
                                );
                              },
                              onFinish: (){
                                details.appointments?[index].state =
                                  details.appointments?[index].state == "done" ? "undone" : "done";
                                // print("${details.appointments?[index].subject} : is ${details.appointments?[index].state}");
                                vm.finishAppointment(
                                    details.appointments?[index],
                                    details.appointments?[index].state == "done" ? true : false   //如果已完成再点一下就是未完成
                                ).then((onValue){
                                  setState(() {
                                    vm.loadAppointments();
                                  });
                                });
                              },
                              details: details),
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
    required CalendarTapDetails details}){
      return Consumer<CalendarViewModel>(
        builder: (context,vm,child) {
          return Dismissible(   //删除滑块
            key:  Key(details.appointments![index].id.toString()),
            direction: DismissDirection.horizontal,
            confirmDismiss: (direction) async {
              return await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('确定删除该任务？'),
                  actions: [
                    TextButton(
                      child: Text('取消'),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    TextButton(
                      child: Text('确定'),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ]
                )
              );
            },
            onDismissed: (direction) {
              onDelete();

            },
            child: Container(
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
                      Consumer<CalendarViewModel>(
                        builder: (context,vm,child) {
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
                                    details.appointments![index].state == "undone"
                                        ? Icons.circle_outlined : Icons.check_circle,
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
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontFamily: 'Poppins',
                                  decoration: details.appointments?[index].state == "done" ? TextDecoration.lineThrough : null),),

                          ),
                        ),
                      ),
                    ]
                )
            ),
          );
        }
      );
  }

  //<<----------------------------------------------------------------日历卡片列表


}



