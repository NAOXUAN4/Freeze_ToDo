import 'package:flutter/material.dart';

class MyRouteObserver<R extends Route<dynamic>> extends RouteObserver<R> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    print('Route pushed: ${route.settings.name}');
    if (route.settings.name == '/your_route_name') {
      // 页面被推入栈时执行的操作
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    print('Route popped: ${route.settings.name}');
    if (previousRoute?.settings.name == '/') {
      // 页面从栈中弹出时执行的操作
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    print('Route replaced: ${newRoute?.settings.name}');
    if (newRoute?.settings.name == '/your_route_name') {
      // 页面被替换时执行的操作
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    print('Route removed: ${route.settings.name}');
    if (previousRoute?.settings.name == '/your_route_name') {
      // 页面被移除时执行的操作
    }
  }
}

final RouteObserver<PageRoute> routeObserver = MyRouteObserver<PageRoute>();
