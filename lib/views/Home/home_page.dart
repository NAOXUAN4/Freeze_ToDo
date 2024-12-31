import 'dart:ui';
import 'package:ca_tl/models/general_vm.dart';
import 'package:ca_tl/repo/routeObserver/routeObserver.dart';
import 'package:ca_tl/route/router.dart';
import 'package:ca_tl/views/commonUi/ListCard_Detail.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import '../../models/appointment_model.dart';
import '../../theme.dart';
import '../commonUi/addTodo_widget.dart';
import 'home_vm.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin, RouteAware {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
        length: 10,
        vsync: this,
        initialIndex: 1);

    _tabController.animateTo(
      1,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );

  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);

  }

  @override
  void didPopNext() {
    // 页面从其他页面返回时执行的操作
    // Provider.of<GeneralViewModel>(context,listen: false).loadAppointmentsALL();
  }


  @override
  void dispose() {
    _tabController.dispose();
    routeObserver.unsubscribe(this as RouteAware);
    super.dispose();
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
              ViewModel.loadAppointmentsALL();
            });
          }, initialDate: DateTime.now(),
        );
      },
    );
  }
  //<<----------------------------------------------------------------添加任务组件


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<GeneralViewModel>(
      builder: (context,vm,child) {
        return Scaffold(
            resizeToAvoidBottomInset: false,   //防止键盘影响布局
            body: Container(   //背景图
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: theme.Default_BackGround,
                  fit: BoxFit.cover,
                )
                // gradient: LinearGradient(
                //   colors: theme.Default_gradient,
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                // ),
              ),
              child: SafeArea(
                child: Stack(
                  children: [
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      child: vm.isInitialized == true ? Column(
                        children:[
                          _TabBar(),    //日期切换导航
                          _ToDoDetails()    //待办事项详情，卡片
                        ],): Center(child: CircularProgressIndicator())
                  ),
                    Positioned(
                      bottom: 50.h,
                      right: 30.w,
                      child: FloatingActionButton(
                        heroTag: "add_hm",
                        backgroundColor: HexColor("#96e1fb").withOpacity(0.5),
                        foregroundColor: Colors.white,
                        onPressed: () {
                          _showAddAppointmentDialog();
                        },
                        tooltip: 'First Action',
                        child: Icon(Icons.add,size: 25.w,
                          color: Colors.white,),
                      ),
                    ),
                    Positioned(    //左边日历按钮
                      bottom: 50.h,
                      left: 30.w,
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
                    )
                  ]
                ) ,
              ),
            ),
          );
      }
    );
  }
  Widget _TabBar(){
    return Consumer<GeneralViewModel>(
      builder: (context,vm,child) {
        return Container(
            height: 30.h,
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: ButtonsTabBar(
                // isScrollable: true,
                // padding: EdgeInsets.symmetric(horizontal: 20.w),
                width: 113.w,
                unselectedDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  color: theme.theme_color_Aveage.withOpacity(0.1),
                  shape: BoxShape.rectangle,

                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  color: Colors.white.withOpacity(0.6),
                  boxShadow: theme.Default_boxShadow,
                ),
                tabs: List.generate(10, (index) =>
                    Tab(
                      child: Container(
                        child: Text(
                          '${vm.LastDate[index].month} 月 ${vm.LastDate[index].day} 日 ',
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontFamily: 'Noto_Serif_SC',
                              color: Colors.black
                          ),
                        ),
                      ),
                    )
                    // Tab(text: '${vm.LastDate[index].month} - ${vm.LastDate[index].day}',)

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
    return  Consumer<GeneralViewModel>(
      builder: (context,vm,child) {
        return Container(
          height: 500.h,
          child: TabBarView(
            controller: _tabController,
            children: List.generate(10, (indexPage){
              return _list(pageKey: vm.LastDate[indexPage]);
              // return Text("data");
            }
            ),),
        );
      }
    );
  }

  //日历卡片列表----------------------------------------------------------------->>
  Widget _list({required DateTime? pageKey}){   //每日卡片列表
    return Consumer<GeneralViewModel>(
        builder: (context,vm,child) {
          return Container(
              height: double.infinity,
              child: vm.tasksByDate[pageKey]?.length != 0 ? SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: vm.tasksByDate[pageKey]?.length,
                    itemBuilder: (context,indexinList){
                      return Container(
                        height: 80.h,
                        width: double.infinity,
                        child: _listItems(
                          pageKey: pageKey,
                          indexinList: indexinList,
                          onDelete: (){
                            vm.deleteAppointment(   //调用数据模型删除函数
                                vm.tasksByDate[pageKey]![indexinList]
                            ).then((onValue){
                              vm.loadAppointmentsALL();
                            });
                            ScaffoldMessenger.of(context).showSnackBar(   //下方弹出框
                              SnackBar(content: Text('${vm.tasksByDate[pageKey]?[indexinList].subject} 已移除')),
                            );
                          },
                          onFinish: (){
                            vm.tasksByDate[pageKey]?[indexinList].state =
                            vm.tasksByDate[pageKey]?[indexinList].state == "done" ? "undone" : "done";
                            print("${vm.tasksByDate[pageKey]?[indexinList].subject} : is ${vm.tasksByDate[pageKey]?[indexinList].state}");
                            vm.finishAppointment(
                                vm.tasksByDate[pageKey]![indexinList],
                                vm.tasksByDate[pageKey]?[indexinList].state == "done" ? true : false   //如果已完成再点一下就是未完成
                            );
                          },
                        ),
                      );
                    }
                ),
              ) : Container(child: Center(child: Text('当日无任务',style: TextStyle(color: Colors.white,fontSize: 20.sp,fontWeight: FontWeight.w600),)),)
          );
        }
    );
  }

  void _onPress_CardDetail({required AppointmentModel appointment,}){
    showDialog(context: context, builder: (context){
      return ListCard_Detail(appointment: appointment);
    });
  }

  Widget _listItems({required int indexinList,
    required DateTime? pageKey,
    required GestureTapCallback onDelete,
    required GestureTapCallback onFinish}) {
    return Consumer<GeneralViewModel>(
        builder: (context, vm, child) {
          return Dismissible( //删除滑块
            key: Key(vm.tasksByDate[pageKey]![indexinList].todo_id.toString()),
            direction: DismissDirection.horizontal,
            confirmDismiss: (direction) async {
              return await showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                          backgroundColor: theme.theme_color_Lightest,
                          title: Text('确定删除该任务？',style: TextStyle(fontWeight: FontWeight.w600),),
                          actions: [
                            TextButton(
                              child: Text('取消',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18.sp),),
                              onPressed: () => Navigator.of(context).pop(false),
                            ),
                            TextButton(
                              child: Text('确定',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18.sp),),
                              onPressed: () => {Navigator.of(context).pop(true),onDelete()},
                            ),
                          ]
                      )
              );
            },
            child: Container(
                margin: EdgeInsets.only(left: 10.w, top: 12.h, right: 10.w),
                height: 80.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: Colors.white.withOpacity(0.6),
                  border: Border.all(color: theme.theme_color_Aveage.withOpacity(0.5),width: 2),
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
                                      vm.tasksByDate[pageKey]![indexinList].state == "undone"
                                          ? Icons.circle_outlined : Icons
                                          .check_circle_outline,
                                      color: theme.theme_color_Darker.withOpacity(0.8),
                                      weight: 10.0,
                                      size: 35.w,
                                    ),
                                  )
                              ),
                            );
                          }
                      ),
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            _onPress_CardDetail(appointment: vm.tasksByDate[pageKey]![indexinList]);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.w),
                            height: 80.h,
                            width: 215.w,
                            margin: EdgeInsets.only(left: 10.w,top: 10.h,bottom: 10.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              color: Colors.white.withOpacity(0.1),
                            ),
                            child: Text(
                              "${vm.tasksByDate[pageKey]![indexinList].subject}",
                              style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: theme.theme_color_Darkest,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w500,
                                  decoration: vm.tasksByDate[pageKey]![indexinList].state ==
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