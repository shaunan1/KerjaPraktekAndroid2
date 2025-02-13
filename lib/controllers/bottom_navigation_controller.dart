import 'package:flutter/material.dart';

class BottomNavigationController extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void handleItemTapped(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
