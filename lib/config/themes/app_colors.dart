import 'package:cocodemy/config/themes/app_dark_theme.dart';
import 'package:cocodemy/config/themes/app_light_theme.dart';
import 'package:cocodemy/config/themes/ui_parameters.dart';
import 'package:flutter/material.dart';

const Color onSurfaceTextColor = Colors.white;

const Color correctAnswerColor = Color(0xFF3ac3cb);
const Color wrongAnswerColor = Color(0xFFf85187);
const Color notAnsweredColor = Color(0xFF2a3c65);

//For light mode
const mainGradientLight = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomLeft,
  colors: [
    primaryLightColorLight,
    primaryColorLight,
  ],
);

//For dark mode
const mainGradientDark = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomLeft,
  colors: [
    primaryDarkColorDark,
    primaryColorDark,
  ],
);

//If dark mode is enabled in phone, return the dark gradient, else return the light gradient
LinearGradient mainGradient() =>
    UIParameters.isDarkMode() ? mainGradientDark : mainGradientLight;

/*
LinearGradient mainGradient(BuildContext context) =>
    UIParameters.isDarkMode(context) ? mainGradientDark : mainGradientLight;
*/

Color customScaffoldColor(BuildContext context) => UIParameters.isDarkMode()
    ? const Color(0xFF2e3c62)
    : const Color.fromARGB(225, 240, 237, 255);

Color answerSelectedColor(BuildContext context) => UIParameters.isDarkMode()
    ? Theme.of(context).cardColor
    : Theme.of(context).primaryColor;

Color answerBorderColor(BuildContext context) => UIParameters.isDarkMode()
    ? const Color.fromARGB(225, 20, 46, 158)
    : const Color.fromARGB(225, 221, 221, 221);
