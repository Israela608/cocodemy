import 'package:cocodemy/config/themes/app_colors.dart';
import 'package:cocodemy/config/themes/ui_parameters.dart';
import 'package:cocodemy/controllers/theme_controller.dart';
import 'package:cocodemy/controllers/zoom_drawer_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuScreen extends GetView<MyZoomDrawerController> {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: UIParameters.mobileScreenPadding,
      width: double.maxFinite,
      decoration: BoxDecoration(gradient: mainGradient()),
      child: Theme(
        data: ThemeData(
            textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: onSurfaceTextColor),
        )),
        child: SafeArea(
          child: Stack(
            children: [
              //Back Button
              Positioned(
                top: 0,
                right: 0,
                child: CupertinoNavigationBarBackButton(
                  color: Colors.white,
                  onPressed: () {
                    controller.toggleDrawer();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.3,
                ),
                child: Column(
                  children: [
                    //Name
                    Obx(
                      () => controller.user.value == null
                          ? SizedBox()
                          : Text(
                              controller.user.value!.displayName ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                                color: onSurfaceTextColor,
                              ),
                            ),
                    ),
                    const Spacer(flex: 1),
                    ///////////////////////////////////////
                    // Dark mode - Light mode switch
                    GetBuilder<ThemeController>(
                      builder: (themeController) {
                        return Column(
                          children: [
                            FloatingActionButton(
                              onPressed: () {
                                themeController.switchTheme();

                                //final themeController = Get.find<ThemeController>();
                                //Get.find<ThemeController>().switchTheme();

                                // themeController.theme =
                                //     themeController.theme == themeController.lightTheme
                                //         ? themeController.darkTheme
                                //         : themeController.lightTheme;

                                //darkMode.value = value;

                                /* Get.changeTheme(themeController.theme ==
                                        themeController.lightTheme
                                    ? themeController.darkTheme
                                    : themeController.lightTheme);*/
                                // Get.changeThemeMode(
                                //     !value ? ThemeMode.light : ThemeMode.dark);
                                /* Get.changeTheme(
                                  Get.isDarkMode
                                      ? themeController.lightTheme
                                      : themeController.darkTheme,
                                );*/
                                //themeController.update();
                                //Get.find<MyZoomDrawerController>().update();
                                //Get.forceAppUpdate();
                                //Get.reloadAll();
                              },
                              child: Get.isDarkMode
                                  ? const Icon(Icons.brightness_3)
                                  : const Icon(Icons.wb_sunny),
                            ),
                          ],
                        );
                      },
                    ),
                    _DrawerButton(
                      icon: Icons.web,
                      label: 'website',
                      onPressed: () => controller.website(),
                    ),
                    _DrawerButton(
                      icon: Icons.facebook,
                      label: 'facebook',
                      onPressed: () => controller.facebook(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: _DrawerButton(
                        icon: Icons.email,
                        label: 'email',
                        onPressed: () => controller.email(),
                      ),
                    ),
                    const Spacer(flex: 4),
                    _DrawerButton(
                      icon: Icons.logout,
                      label: 'logout',
                      onPressed: () => controller.signOut(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerButton extends StatelessWidget {
  const _DrawerButton({
    Key? key,
    required this.icon,
    required this.label,
    this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 15,
      ),
      label: Text(label),
    );
  }
}
