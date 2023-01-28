import 'package:cocodemy/config/themes/ui_parameters.dart';
import 'package:cocodemy/controllers/question_papers/questions_controller.dart';
import 'package:cocodemy/widgets/common/background_decoration.dart';
import 'package:cocodemy/widgets/common/custom_app_bar.dart';
import 'package:cocodemy/widgets/common/main_button.dart';
import 'package:cocodemy/widgets/content_area.dart';
import 'package:cocodemy/widgets/questions/answer_card.dart';
import 'package:cocodemy/widgets/questions/countdown_timer.dart';
import 'package:cocodemy/widgets/questions/question_number_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TestOverviewScreen extends GetView<QuestionsController> {
  const TestOverviewScreen({Key? key}) : super(key: key);

  static const String routeName = '/testoverview';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: controller.completedQuestions,
      ),
      body: BackgroundDecoration(
        child: Column(
          children: [
            Expanded(
                child: ContentArea(
                    child: Column(
              children: [
                Obx(() => CountdownTimer(time: '${controller.time} Remaining')),
                const SizedBox(height: 20),
                Expanded(
                    child: GridView.builder(
                  itemCount: controller.allQuestions.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: Get.width ~/ 75,
                      childAspectRatio: 1,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8),
                  itemBuilder: (_, index) {
                    return QuestionNumberCard(
                      index: index + 1,
                      status:
                          //If a question has been answered
                          controller.allQuestions[index].selectedAnswer != null
                              ? AnswerStatus.answered
                              : AnswerStatus.notanswered,
                      onTap: () => controller.jumpToQuestion(index),
                    );
                  },
                ))
              ],
            ))),
            ColoredBox(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: UIParameters.mobileScreenPadding,
                child: MainButton(
                  onTap: () {
                    controller.complete();
                  },
                  title: 'Complete',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
