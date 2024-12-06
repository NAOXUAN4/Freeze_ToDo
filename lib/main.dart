import 'package:ca_tl/route/router.dart';
import 'package:ca_tl/views/Calendar/calendar_vm.dart';
import 'package:ca_tl/views/Test/MYSTATE.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import 'models/general_vm.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(  //设置状态栏透明
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(const MyApp(title: 'Demo',));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.title});
  final String title;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GeneralViewModel()..initCalendarDateSource().then((onValue){
          print("GVM初始化完成");
        })),
      ],
      child: OKToast(
        child: ScreenUtilInit(
          builder: (context, child) {
            return MaterialApp(
              title: widget.title,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              onGenerateRoute: Routes.generateRoute,   //导入配置好的路由
              initialRoute: RouteName.home,   //设置初始路由路径(String)
            );
          },
        ),
      ),
    );
  }
}
