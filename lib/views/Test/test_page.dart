import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 6,
      vsync: this,
      initialIndex: 4,
    );
    _tabController.animateTo(4);
  }

  @override
  Widget build(BuildContext context) {
    const typeList = ["foo", "bar", "baz", "qux", "quux", "quuz"];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
          //   TabBar(isScrollable: true,
          //     tabs: [
          //     Container(
          //     width: 100, // 设置每个标签的宽度
          //     child: Tab(icon: Icon(Icons.home), text: "Home"),
          //   ),
          //   Container(
          //     width: 100,
          //     child: Tab(icon: Icon(Icons.business), text: "Business"),
          //   ),
          //   Container(
          //     width: 100,
          //     child: Tab( text: "baz"),
          //   ),
          //   Container(
          //     width: 100,
          //     child: Tab(text: "qux"),
          //   ),
          //   Container(
          //     width: 100,
          //     child: Tab(text: "quux"),
          //   ),
          //   Container(
          //     width: 100,
          //     child: Tab( text: "quuz"),
          //   ),
          // ],controller: _tabController,),
            ButtonsTabBar(
              width: 120,
              controller: _tabController,
              backgroundColor: Colors.red,
              buttonMargin: const EdgeInsets.only(right: 16),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              tabs: typeList.map((e) {
                return Tab(
                  child: Text(
                    e,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: typeList.map((e) {
                  return Center(
                    child: Text(e,style: TextStyle(fontSize: 40),),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}