import 'package:ca_tl/views/commonUi/addTodo_Page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../views/Calendar/calendar_page.dart';
import '../views/Home/home_page.dart';
import '../views/Test/test_page.dart';

class Routes{
  static MaterialPageRoute<dynamic>? generateRoute(RouteSettings settings){
    // TODO: 路由switcher
    switch (settings.name){
      case RouteName.home:
        return pageRoute(
          HomePage(),
          settings: settings,
        );
      case RouteName.calendar:
        return pageRoute(
          CalendarPage(),
          settings: settings,
        );
      case RouteName.add:
        return pageRoute(
          AddToDoPage(),
          settings: settings,
        );
      case RouteName.test:
        return pageRoute(
          Example(),
          settings: settings,
        );
    }
    return null;
  }

  static MaterialPageRoute<dynamic> pageRoute(Widget page, {
    RouteSettings ?settings,
    bool? fullscreenDialog = false,
    bool? maintainState = true,
    bool? allowSnapshotting
  }){
    return MaterialPageRoute(builder: (context){
      return page;
    },
      settings: settings,
      fullscreenDialog: fullscreenDialog ?? false,
      maintainState: maintainState ?? true,
      allowSnapshotting: allowSnapshotting ?? true);
  }
}

class RouteName{
  static const String home = '/';
  static const String test = '/test';
  static const String add = '/add';
  static const String calendar = '/calendar';
}

