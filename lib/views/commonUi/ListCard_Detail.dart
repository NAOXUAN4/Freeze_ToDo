import 'package:ca_tl/models/appointment_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';

class ListCard_Detail extends StatelessWidget {

  final AppointmentModel appointment;
  const ListCard_Detail({super.key, required this.appointment});  //传入待办

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shadowColor: theme.theme_color_Darkest,
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        height: 260.h,
        child: _Dialog_Content(appointment),
      ),
    );
  }

  Widget _Dialog_Content(AppointmentModel appointment){
    return Container(
      padding: EdgeInsets.only(top: 20.h,bottom: 10.h,left:10.w,right:10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.sp),
        color: theme.theme_color_Lightest.withOpacity(0.95),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.sp),
            color: theme.theme_color_Lightest.withOpacity(0.95),
            ),
            height: 200.sp,
            child: SingleChildScrollView(
              child: Container(   //日程详情承载
                padding: EdgeInsets.all(15.w),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.sp),
                  color: Colors.transparent,
                ),
                child: Text("${appointment.subject}",style: TextStyle(fontSize: 30.sp,
                    decoration: appointment.state ==
                    "done"
                    ? TextDecoration.lineThrough
                    : null),)),
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            height: 40.h,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.sp),
              color: theme.theme_color_Lightest.withOpacity(0.95),
            ),
            child: Container(
              padding: EdgeInsets.all(5.w),
              child: Row(
                children: [
                  Icon(Icons.calendar_month_sharp,color: theme.theme_color_Darkest,),
                  SizedBox(width: 10.w,),
                  Text("DeadLine : ",style: TextStyle(fontSize: 14.sp),),
                  SizedBox(width: 20.w,),
                  Text("${appointment.endTime.year}/${appointment.endTime.month}/${appointment.endTime.day}",
                    style: TextStyle(fontSize: 18.sp,),)
                ]
              ),
            ),
            
          ),
        ],
      ),
    );
    
  }
  
  
}