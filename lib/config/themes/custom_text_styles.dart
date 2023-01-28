import 'package:cocodemy/config/themes/app_colors.dart';
import 'package:cocodemy/config/themes/ui_parameters.dart';
import 'package:flutter/material.dart';

TextStyle cartTitles(context) => TextStyle(
      color: UIParameters.isDarkMode()
          ? Theme.of(context).textTheme.bodyText1!.color
          : Theme.of(context).primaryColor,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );

const detailText = TextStyle(fontSize: 12);

const headerText = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.w700,
  color: onSurfaceTextColor,
);

const questionText = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w800,
);

const appBarText = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: onSurfaceTextColor,
);

TextStyle countDownTimerText(context) => TextStyle(
      letterSpacing: 2,
      color: UIParameters.isDarkMode()
          ? Theme.of(context).textTheme.bodyText1!.color
          : Theme.of(context).primaryColor,
    );
