import 'package:cocodemy/config/themes/app_dark_theme.dart';
import 'package:cocodemy/config/themes/app_light_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  late ThemeData _lightTheme;
  late ThemeData _darkTheme;

  @override
  void onInit() {
    super.onInit();
    initializeThemeData();
  }

  initializeThemeData() {
    _lightTheme = LightTheme().buildLightTheme();
    _darkTheme = DarkTheme().buildDarkTheme();
  }

  ThemeData get lightTheme => _lightTheme;
  ThemeData get darkTheme => _darkTheme;
}
