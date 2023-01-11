import 'package:cocodemy/config/themes/app_colors.dart';
import 'package:cocodemy/config/themes/app_icons.dart';
import 'package:cocodemy/config/themes/custom_text_styles.dart';
import 'package:cocodemy/config/themes/ui_parameters.dart';
import 'package:cocodemy/controllers/question_papers/question_paper_controller.dart';
import 'package:cocodemy/controllers/zoom_drawer_controller.dart';
import 'package:cocodemy/screens/home/menu_screen.dart';
import 'package:cocodemy/screens/home/question_card.dart';
import 'package:cocodemy/widgets/app_cirlce_button.dart';
import 'package:cocodemy/widgets/content_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
//import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

// We use GetView here instead of StatelessWidget, so we can access the properties of ZoomDrawerController without directly creating an instance of the controller
class HomeScreen extends GetView<MyZoomDrawerController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    QuestionPaperController questionPaperController = Get.find();

    return Scaffold(
        body: ZoomDrawer(
      controller: controller.zoomDrawerController,
      borderRadius: 50,
      menuScreenWidth: double.maxFinite,
      angle: 0.0,
      style: DrawerStyle.defaultStyle,
      moveMenuScreen: false,
      menuBackgroundColor: Colors.white.withOpacity(0.5),
      slideWidth: MediaQuery.of(context).size.width * 0.4,
      menuScreen: MenuScreen(),
      mainScreen: Container(
        decoration: BoxDecoration(gradient: mainGradient()),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(mobileScreenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppCircleButton(
                      onTap: controller.toggleDrawer,
                      child: const Icon(AppIcons.menuLeft),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          const Icon(AppIcons.peace),
                          Text(
                            'Hello friend',
                            style:
                                detailText.copyWith(color: onSurfaceTextColor),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'What do you want to learn today?',
                      style: headerText,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ContentArea(
                    addPadding: false,
                    // Obx() is a reactive widget that makes the widget in it react to changes
                    child: Obx(() => ListView.separated(
                          padding: UIParameters.mobileScreenPadding,
                          itemCount: questionPaperController.allPapers.length,
                          itemBuilder: (BuildContext context, int index) {
                            return QuestionCard(
                              model: questionPaperController.allPapers[index],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(height: 20);
                          },
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
