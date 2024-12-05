import 'package:flutter/material.dart';

class MyAppState with ChangeNotifier {
  bool _isDone = false;

  bool get isDone => _isDone;

  void toggleDone() {
    _isDone = !_isDone;
    notifyListeners();
  }
}
