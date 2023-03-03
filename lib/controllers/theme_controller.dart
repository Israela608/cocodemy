import 'package:cocodemy/config/themes/app_dark_theme.dart';
import 'package:cocodemy/config/themes/app_light_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  late ThemeData _lightTheme;
  late ThemeData _darkTheme;

  ////////////////////////////////
  //late Rx<ThemeData> _theme;

  @override
  void onInit() {
    super.onInit();
    initializeThemeData();
  }

  initializeThemeData() {
    _lightTheme = LightTheme().buildLightTheme();
    _darkTheme = DarkTheme().buildDarkTheme();

    /////////////////////////////
    //_theme = _lightTheme.obs;
  }

  ThemeData get lightTheme => _lightTheme;
  ThemeData get darkTheme => _darkTheme;

  //////////////////////
  //ThemeData get theme => _theme.value;

  //////////////////////////
  //set theme(ThemeData value) => _theme.value = value;

  //////////////////////
  void switchTheme() {
    //_theme.value = _theme.value == lightTheme ? darkTheme : lightTheme;
    Get.changeTheme(
      Get.isDarkMode ? _lightTheme : _darkTheme,
    );
    /*  Get.changeTheme(
      !value ? _lightTheme : _darkTheme,
    );*/
    update();
  }
}
