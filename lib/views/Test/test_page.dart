import 'package:flutter/material.dart';

import '../commonUi/ListCard_Detail.dart';

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            OutlinedButton(onPressed: () => BTonPress(context: context), child: Text("data"))
          ]
        ),
      ),
    );
  }

  void BTonPress({required BuildContext context}) {

  }
}