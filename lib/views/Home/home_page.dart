import 'dart:ui';
import 'package:ca_tl/route/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../models/appointment_model.dart';
import '../../theme.dart';
import '../Calendar/calendar_vm.dart';
import 'home_vm.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  late TabController _tabController;  //创建tab控制器
  HomepageViewModel ViewModel = HomepageViewModel();
  late Map<DateTime, List<AppointmentModel>> tasks;   //创建临时Task数据集合
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    ViewModel.initHomeListDateSource(DateTime.now()).then((_) {
      setState(() {
        _tabController = TabController(
            length: ViewModel.LastDate.length,
            vsync: this,
            initialIndex: 1);

        _tabController.animateTo(
          1,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
        );
        ViewModel.getTasksByDateRange(DateTime.now()).then((value){
          setState(() {
            tasks = value;
            _isInitialized = true;
            print(tasks);
          });
        });
      });
    });
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    print('is DId');
    // 在依赖发生变化时刷新数据
    // ViewModel.initHomeListDateSource(DateTime.now()).then((_) {
    //   setState(() {
    //     _tabController = TabController(
    //         length: ViewModel.LastDate.length,
    //         vsync: this,
    //         initialIndex: 1);
    //
    //     _tabController.animateTo(
    //       1,
    //       duration: const Duration(milliseconds: 100),
    //       curve: Curves.easeInOut,
    //     );
    //     ViewModel.getTasksByDateRange(DateTime.now()).then((value){
    //       setState(() {
    //         tasks = value;
    //         _isInitialized = true;
    //         print(tasks);
    //       });
    //     });
    //   });
    // });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider<HomepageViewModel>(
      create: (context) {
        return ViewModel;
      },
      child: Scaffold(
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
                child: _isInitialized == true ? Column(
                  children:[
                    _TabBar(),    //日期切换导航
                    _ToDoDetails()    //待办事项详情，卡片
                  ],): Center(child: CircularProgressIndicator())
            ) ,
          ),
        ),
        floatingActionButton:  //底部快速功能按钮
        _floatButtons(),
      ),
    );
  }
  Widget _floatButtons(){
    return Stack(
      children: <Widget>[  //右边添加按钮
        Positioned(
          bottom: 20.h,
          right: 30.w,
          child: FloatingActionButton(
            heroTag: "add_hm",
            backgroundColor: HexColor("#96e1fb").withOpacity(0.5),
            foregroundColor: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, RouteName.add);
            },
            tooltip: 'First Action',
            child: Icon(Icons.add,size: 25.w,
              color: Colors.white,),
          ),
        ),
        Positioned(    //左边日历按钮
          bottom: 20.h,
          left: 60.w,
          child: FloatingActionButton(
            heroTag: "cal_hm",
            backgroundColor: HexColor("#96e1fb").withOpacity(0.5),
            onPressed: () {
              Navigator.pushNamed(context, RouteName.calendar);
            },
            tooltip: 'Second Action',
            child: Icon(Icons.calendar_month,size: 25.w,
              color: Colors.white,),
          ),
        ),
      ],
    );
  }

  Widget _TabBar(){
    return Consumer<HomepageViewModel>(
      builder: (context,vm,child) {
        return Container(
            height: 60.h,
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: ButtonsTabBar(
                // isScrollable: true,
                // padding: EdgeInsets.symmetric(horizontal: 20.w),
                width: 113.w,
                unselectedDecoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(10.r),
                  color: Colors.white.withOpacity(0.1),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: Colors.white.withOpacity(0.2),
                ),
                tabs: List.generate(10, (index) =>
                    Tab(text: '${vm.LastDate[index].month} - ${vm.LastDate[index].day}')
                ),
                controller: _tabController,
                contentCenter: true,
              ),
            ),
        );
      }
    );
  }

  Widget _ToDoDetails(){
    return  Expanded(
      child: TabBarView(
        controller: _tabController,
        children: List.generate(10, (indexPage) =>
          _ToDoPages(indexPage: indexPage)
        ),),

    );
  }

  Widget _ToDoPages({required int indexPage}){
    List<AppointmentModel>? tasksThisPage = tasks[ViewModel.LastDate[indexPage]];
    return Consumer<HomepageViewModel>(
      builder: (context,vm,child) {
        return Container(
          margin: EdgeInsets.all(8.w),
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: Colors.white.withOpacity(0.1),

          ),
          child: tasksThisPage!.length > 0 ?ListView.builder(
            shrinkWrap: true,
            itemCount: tasksThisPage.length,
            itemBuilder: (context,indexList){
                return _ToDoCardItem(indexList: indexList, onFinish: (){
                  setState(() {
                    showToast('onCheck');
                  }
                  );
                }, tasksThisPage: tasksThisPage);
            })
              : Center(
            child: Text("暂无任务",style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                fontFamily: "Poppins"
            ),),
          ),

        );
      }
    );
  }

  Widget _ToDoCardItem({required int indexList,       //详情卡片ITEM
    required GestureTapCallback onFinish,
    required List<AppointmentModel>? tasksThisPage,}){
    return Consumer<HomepageViewModel>(
      builder: (context,vm,child) {
        return Container(
          margin: EdgeInsets.only(left: 10.w,top: 12.h,right: 10.w),
          height: 100.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: Colors.white.withOpacity(0.1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
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
                    onTap: onFinish,
                    child: Icon(
                      tasksThisPage?[indexList].state == "done" ? Icons.check_circle_rounded
                          : Icons.circle_outlined,
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
                    height: 80.h,
                    width: 220.w,
                    margin: EdgeInsets.only(left: 10.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: Colors.white.withOpacity(0.1),
                    ),
                    child: Center(
                        child: Text("${tasksThisPage?[indexList].subject}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp),)),

                  ),
                ),
              )
            ]
          )
        );
      }
    );
  }
}