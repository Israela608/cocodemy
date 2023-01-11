import 'package:cocodemy/config/themes/app_colors.dart';
import 'package:cocodemy/config/themes/ui_parameters.dart';
import 'package:flutter/material.dart';

class ContentArea extends StatelessWidget {
  const ContentArea({
    Key? key,
    required this.child,
    this.addPadding = true,
  }) : super(key: key);

  final Widget child;
  final bool addPadding;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      clipBehavior: Clip.hardEdge,
      type: MaterialType.transparency,
      child: Ink(
        decoration: BoxDecoration(color: customScaffoldColor(context)),
        padding: addPadding
            ? EdgeInsets.only(
                top: mobileScreenPadding,
                left: mobileScreenPadding,
                right: mobileScreenPadding,
              )
            : EdgeInsets.zero,
        child: child,
      ),
    );
  }
}
