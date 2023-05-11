import 'dart:math';

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
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

// We use GetView here instead of StatelessWidget, so we can access the properties of ZoomDrawerController without directly creating an instance of the controller
class HomeScreen extends GetView<MyZoomDrawerController> {
  const HomeScreen({Key? key}) : super(key: key);

  static const String routeName = '/';

  static const List quizPrompts = <String>[
    'What do you want to learn today?',
    "Ready to expand your horizons? Let's dive into some fun learning!",
    "Time to test your knowledge and discover something new today!",
    "Let's make learning fun! What topic piques your interest?",
    "Welcome to your daily dose of curiosity! What would you like to explore?",
    "Join the adventure of learning something new every day! What's on your mind?",
    "Get ready to have some fun while you learn! What's your topic of choice today?",
    "Let's challenge your brain and discover something exciting together! What do you want to learn?",
    "Curiosity never ends! Let's quench your thirst for knowledge with some exciting questions today!",
    "Feeling curious? Let's explore some fascinating topics together and learn something new!",
    "Join the journey of discovering something new every day! What's on your learning agenda?",
    "Welcome to the world of learning! What interests you today?",
    "Expand your knowledge, have some fun, and let's learn together! What's your pick for today?",
    "Let's put your brain to the test! What do you want to learn and challenge yourself with today?",
    "Unlock your potential and learn something new every day! What's your next topic of interest?",
  ];

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
      slideWidth: MediaQuery.of(context).size.width * 0.75,
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
                    //const SizedBox(height: 10),
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
                      quizPrompts[Random().nextInt(quizPrompts.length)],
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
