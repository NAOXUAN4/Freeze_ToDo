// BoxShadow
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class theme{
  static List <BoxShadow> Default_boxShadow = [
    BoxShadow(
      color: HexColor("#15191d").withOpacity(0.1),
      spreadRadius: 2,
      blurRadius: 3,
      offset: const Offset(0, 3), // changes position of shadow
    ),
  ];

  static List <Color> Default_gradient =  [HexColor("#D7b3bb4"), HexColor("#19c9c1")];

  static AssetImage Default_BackGround = AssetImage("assets/images/ocean1.jpg");

  static const Color theme_color_Lightest = Color(0xffe4ebf7);
  static const Color theme_color_LighterP = Color(0xffbdd3eb);
  static const Color theme_color_Lighter = Color(0xffd1dcdc);
  static const Color theme_color_Light = Color(0xffccdfdf);
  static const Color theme_color_Aveage = Color(0xff469acb);
  static const Color theme_color_Dark = Color(0xff1a3d71);
  static const Color theme_color_Darker = Color(0xff1d396d);
  static const Color theme_color_Darkest = Color(0xff07133c);

  static const Color theme_color_pink = Color(0xfff7effa);
  static const Color theme_color_lightBlue = Color(0xff7ca4ff);

  static const ColorScheme myColorScheme =  ColorScheme(
    primary: theme_color_Dark,
    secondary: Colors.purple,
    surface: Colors.white,
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: theme_color_Darkest,
    onError: Colors.white,
    brightness: Brightness.light,
  );

  ///  CalendarDec ----------------------------------------------------------->>
  static TextStyle calendarCell_TextStyle = TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15.sp);
  static TextStyle calendarCell_TextStyle_selected = TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16.sp);
  /// <<------------------------------------------------------------------------

  //  Tab---------------------------------------------------------------------->>
  static BoxDecoration TabBoxDecoration_selected  = BoxDecoration(
    borderRadius: BorderRadius.circular(5.r),
    color: Colors.white.withOpacity(0.6),
    boxShadow: theme.Default_boxShadow,
  );
  // <<------------------------------------------------------------------------

  /// ListCard --------------------------------------------------------------->>
  static BoxDecoration CardBoxDecoration  = BoxDecoration(
    borderRadius: BorderRadius.circular(10.r),
    color: Colors.white.withOpacity(0.6),
    border: Border.all(color: theme.theme_color_Aveage.withOpacity(0.5),width: 2),
    boxShadow: theme.Default_boxShadow,
  );
  // <<-------------------------------------------------------------------------

}


