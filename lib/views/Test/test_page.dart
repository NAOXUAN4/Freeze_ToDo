import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:oktoast/oktoast.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../theme.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}


class _TestPageState extends State<TestPage> with SingleTickerProviderStateMixin {
  late CalendarController _calendarController;

  @override
  void initState() {
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
    return Scaffold(
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
            onPressed: (){
              showToast("add");
            },
            tooltip: 'First Action',
            backgroundColor: HexColor("#96e1fb").withOpacity(0.5),
            child: Icon(Icons.add,size: 25.w,
              color: Colors.white,),
        ),
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
        dataSource: _getCalendarDataSource(),
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
            child: _listItems(index: index, onTrick: (){}, details: details),
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
              )

            ]
        )
    );
  }



  CalendarDataSource? _getCalendarDataSource() {
    List<Appointment> appointments = <Appointment>[];
    appointments.add(Appointment(
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(hours: 1)),
      subject: 'Meeting',
      color: Colors.blue,
    ));
    appointments.add(Appointment(
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(hours: 1)),
      subject: 'Meeting2',
      color: Colors.blue,
    ));
    // return DataSource(appointments);
    return null;
  }
}

// class DataSource extends CalendarDataSource {
//   DataSource(List<Appointment> source) {
//     appointments = source;
//   }
// }
