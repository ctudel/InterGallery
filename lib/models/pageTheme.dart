import 'package:flutter/material.dart';

class PageTheme extends ChangeNotifier {
  ThemeMode _themeData = ThemeMode.light;

  ThemeMode get themeData => _themeData;

  void toggleTheme(bool darkMode) {
    _themeData = (darkMode) ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}