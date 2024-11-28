import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:oktoast/oktoast.dart';

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


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children:[
                _TabBar(),
               _ToDoDetails()
              ],)
          ),
        ),
      ));
  }

  Widget _TabBar(){
    return Container(
        height: 60.h,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: ButtonsTabBar(
            // isScrollable: true,
            // padding: EdgeInsets.symmetric(horizontal: 20.w),
            width: 120.w,
            unselectedDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: Colors.white.withOpacity(0.1),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: Colors.white.withOpacity(0.2),
            ),
            tabs: List.generate(10, (index) =>
                Tab(text: 'Tab: ${index + 1}')
            ),
            controller: _tabController,
            contentCenter: true,
          ),
        ),
    );
  }

  Widget _ToDoDetails(){
    return  Expanded(
      child: TabBarView(
        controller: _tabController,
        children: List.generate(10, (index) =>
          _ToDoPages(index: index)
        ),),

    );
  }

  Widget _ToDoPages({required int index}){
    return Container(
      margin: EdgeInsets.all(20.w),
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: Colors.white.withOpacity(0.1),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 3,
        itemBuilder: (context,index){
            return _ToDoCardItem(index: index, onTrick: (){
              setState(() {
                showToast('onCheck');
              });
            });
        }),

    );
  }

  Widget _ToDoCardItem({required int index, required GestureTapCallback onTrick}){
    return Container(
      margin: EdgeInsets.only(left: 10.w,top: 12.h,right: 10.w),
      height: 100.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: Colors.white.withOpacity(0.1),
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
                height: 80.h,
                width: 220.w,
                margin: EdgeInsets.only(left: 10.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color: Colors.white.withOpacity(0.1),
                ),

              ),
            ),
          )

        ]
      )
    );
  }

}