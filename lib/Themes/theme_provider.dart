import 'package:flutter/material.dart';
import 'package:vinvi/Themes/dart_mode.dart';
import 'package:vinvi/Themes/light_mode.dart';

/*

THEME PROVIDER

This helps us to change the app from dart mode to light mode
or light mode to dart mode.

 */
class ThemeProvider with ChangeNotifier {
  //initially, set it as light mode
  ThemeData _themeData = lightMode;

  //get current theme
  ThemeData get themeData => _themeData;

// is it dark mode currently
  bool get isDartMood => _themeData == darkmode;

// set the theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;

    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkmode;
    } else {
      themeData = lightMode;
    }
  }

  /*
  NOW WE CONDUCT flutter pub add provider IN THE TERMINAL
   */
}
