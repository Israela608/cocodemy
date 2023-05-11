import 'package:cocodemy/config/themes/app_colors.dart';
import 'package:cocodemy/config/themes/custom_text_styles.dart';
import 'package:cocodemy/config/themes/ui_parameters.dart';
import 'package:cocodemy/controllers/question_papers/questions_controller.dart';
import 'package:cocodemy/firebase_ref/loading_status.dart';
import 'package:cocodemy/screens/question/test_overview_screen.dart';
import 'package:cocodemy/widgets/common/background_decoration.dart';
import 'package:cocodemy/widgets/common/custom_app_bar.dart';
import 'package:cocodemy/widgets/common/main_button.dart';
import 'package:cocodemy/widgets/common/question_place_holder.dart';
import 'package:cocodemy/widgets/content_area.dart';
import 'package:cocodemy/widgets/questions/answer_card.dart';
import 'package:cocodemy/widgets/questions/countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionsScreen extends GetView<QuestionsController> {
  const QuestionsScreen({Key? key}) : super(key: key);

  static const String routeName = '/questions';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        leading: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: const ShapeDecoration(
            shape: StadiumBorder(
              side: BorderSide(color: onSurfaceTextColor, width: 2),
            ),
          ),
          child: Obx(() => CountdownTimer(
                time: controller.time.value,
                color: Colors.white,
              )),
        ),
        showActionIcon: true,
        titleWidget: Obx(() => Text(
              'Q. ${(controller.questionIndex.value + 1).toString().padLeft(2, '0')}',
              style: appBarText,
            )),
      ),
      body: BackgroundDecoration(
        child: Obx(
          () => Column(
            children: [
              controller.loadingStatus.value == LoadingStatus.loading
                  ? const Expanded(
                      child: ContentArea(child: QuestionScreenHolder()))
                  : Expanded(
                      child: ContentArea(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(top: 25),
                          child: Column(
                            children: [
                              Text(
                                controller.currentQuestion.value!.question,
                                style: questionText,
                              ),
                              GetBuilder<QuestionsController>(
                                  //We use the id to update this GetBuilder ui only, when we call the update() method in the controller
                                  id: 'answer_list',
                                  builder: (context) {
                                    return ListView.separated(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.only(top: 25),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final answer = controller
                                            .currentQuestion
                                            .value!
                                            .answers[index];

                                        return AnswerCard(
                                          answer:
                                              '${answer.identifier}. ${answer.answer}',
                                          onTap: () {
                                            //When an answer is tapped, it is set as the selectedAnswer
                                            controller.selectedAnswer(
                                                answer.identifier);
                                          },
                                          //If the answer is the one that is the selectedAnswer
                                          isSelected: answer.identifier ==
                                              controller.currentQuestion.value!
                                                  .selectedAnswer,
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              const SizedBox(
                                        height: 10,
                                      ),
                                      itemCount: controller.currentQuestion
                                          .value!.answers.length,
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ),
              ColoredBox(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Padding(
                  padding: UIParameters.mobileScreenPadding,
                  child: Row(
                    children: [
                      Visibility(
                        visible: controller.isNotFirstQuestion,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: SizedBox(
                            width: 55,
                            height: 55,
                            child: MainButton(
                              onTap: () {
                                controller.previousQuestion();
                              },
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                color: Get.isDarkMode
                                    ? onSurfaceTextColor
                                    : Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Visibility(
                        visible: controller.loadingStatus.value ==
                            LoadingStatus.completed,
                        child: MainButton(
                          onTap: () {
                            controller.isLastQuestion
                                ? Get.toNamed(TestOverviewScreen.routeName)
                                : controller.nextQuestion();
                          },
                          title:
                              controller.isLastQuestion ? 'Completed' : 'Next',
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
