import 'package:flutter/material.dart';

class TableState with ChangeNotifier {
  bool _isInTable = false;

  bool get isInTable => _isInTable;

  void joinTable() {
    _isInTable = true;
    notifyListeners();
  }

  void leaveTable() {
    _isInTable = false;
    notifyListeners();
  }
}