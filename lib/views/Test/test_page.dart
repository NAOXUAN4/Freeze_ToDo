import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MYSTATE.dart';

class test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Provider with showModalBottomSheet'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return BottomSheetContent(appState: Provider.of<MyAppState>(context),);
              },
            );
          },
          child: Text('Show Modal Bottom Sheet'),
        ),
      ),
    );
  }
}

class BottomSheetContent extends StatelessWidget {
  final MyAppState appState;

  const BottomSheetContent({Key? key, required this.appState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Current State: ${appState.isDone ? 'Done' : 'Undone'}'),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              appState.toggleDone();
            },
            child: Text('Toggle State'),
          ),
        ],
      ),
    );
  }
}
