import 'package:flutter/material.dart';

class LocalProvider extends ChangeNotifier {
  // Theme data
  ThemeMode _themeData = ThemeMode.light;

  // Time data
  bool _twenty4Hour = true;
  String _timePeriod = '24 hour time';

  // Theme getters
  ThemeMode get themeData => _themeData;

  // Time gettters
  bool get twenty4Hour => _twenty4Hour;
  String get timePeriod => _timePeriod;

  void toggleTheme(bool darkMode) {
    _themeData = (darkMode) ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setTimeFormat(bool twenty4Hour) {
    _twenty4Hour = twenty4Hour;
    _timePeriod = twenty4Hour ? '24 hour format' : '12 hour format';
    notifyListeners();
  }
}

