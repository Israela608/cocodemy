import 'dart:ui';

import 'package:cocodemy/config/themes/sub_theme_data_mixin.dart';
import 'package:flutter/material.dart';

const Color primaryLightColorLight = Color(0xFF3ac3cb);
const Color primaryColorLight = Color(0xFFf85187);
const Color mainTextColorLight = Color.fromARGB(255, 40, 40, 40);
const Color cardColor = Color.fromARGB(255, 254, 254, 255);

//This is our default Light theme function.
//We can override any property here
class LightTheme with SubThemeData {
  ThemeData buildLightTheme() {
    //We assign the default flutter light theme function to our systemLightTheme variable
    final ThemeData systemLightTheme = ThemeData.light();
    //Then we use the copyWith() method to make our preferred changes
    return systemLightTheme.copyWith(
        primaryColor: primaryColorLight,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        iconTheme: getIconTheme(),
        cardColor: cardColor,
        textTheme: getTextTheme().apply(
          bodyColor: mainTextColorLight,
          displayColor: mainTextColorLight,
        ));
  }
}
