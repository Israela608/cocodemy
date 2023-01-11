import 'dart:ui';

import 'package:cocodemy/config/themes/sub_theme_data_mixin.dart';
import 'package:flutter/material.dart';

const Color primaryDarkColorDark = Color(0xFF2e3c62);
const Color primaryColorDark = Color(0xFF99ace1);
const Color mainTextColorDark = Colors.white;

//This is our default Dark theme function.
//We can override any property here
class DarkTheme with SubThemeData {
  ThemeData buildDarkTheme() {
    //We assign the default flutter light theme function to our systemLightTheme variable
    final ThemeData systemDarkTheme = ThemeData.dark();
    //Then we use the copyWith() method to make our preferred changes
    return systemDarkTheme.copyWith(
        iconTheme: getIconTheme(),
        textTheme: getTextTheme().apply(
          bodyColor: mainTextColorDark,
          displayColor: mainTextColorDark,
        ));
  }
}
