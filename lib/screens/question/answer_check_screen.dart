import 'package:cocodemy/config/themes/app_colors.dart';
import 'package:cocodemy/config/themes/custom_text_styles.dart';
import 'package:cocodemy/config/themes/ui_parameters.dart';
import 'package:cocodemy/controllers/question_papers/questions_controller.dart';
import 'package:cocodemy/screens/question/result_screen.dart';
import 'package:cocodemy/widgets/common/background_decoration.dart';
import 'package:cocodemy/widgets/common/custom_app_bar.dart';
import 'package:cocodemy/widgets/common/main_button.dart';
import 'package:cocodemy/widgets/content_area.dart';
import 'package:cocodemy/widgets/questions/answer_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnswerCheckScreen extends GetView<QuestionsController> {
  const AnswerCheckScreen({Key? key}) : super(key: key);

  static const String routeName = '/answerCheck';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        titleWidget: Obx(() => Text(
              'Q. ${(controller.questionIndex.value + 1).toString().padLeft(2, '0')}',
              style: appBarText,
            )),
        showActionIcon: true,
        onMenuActionTap: () {
          Get.toNamed(ResultScreen.routeName);
        },
      ),
      body: BackgroundDecoration(
        child: Obx(
          () => Column(
            children: [
              Expanded(
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
                            id: 'answer_review_list',
                            builder: (context) {
                              return ListView.separated(
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(top: 25),
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (_, int index) {
                                  final answer = controller
                                      .currentQuestion.value!.answers[index];
                                  final selectedAnswer = controller
                                      .currentQuestion.value!.selectedAnswer;
                                  final correctAnswer = controller
                                      .currentQuestion.value!.correctAnswer;
                                  final String answerText =
                                      '${answer.identifier}. ${answer.answer}';

                                  //If this answer is the correct answer and also the one you chose
                                  if (correctAnswer == selectedAnswer &&
                                      answer.identifier == selectedAnswer) {
                                    return CorrectAnswerCard(
                                        answer: answerText);
                                  }
                                  //If this is the wrong answer, but the one you chose
                                  else if (correctAnswer != selectedAnswer &&
                                      answer.identifier == selectedAnswer) {
                                    return WrongAnswerCard(answer: answerText);
                                  }
                                  //If this is the correct answer, whether you chose it or not
                                  else if (correctAnswer == answer.identifier) {
                                    return CorrectAnswerCard(
                                        answer: answerText);
                                  }
                                  //If you didn't answer the question at all
                                  else if (selectedAnswer == null) {
                                    return NotAnsweredCard(answer: answerText);
                                  }

                                  //Default
                                  return AnswerCard(
                                    answer:
                                        '${answer.identifier}. ${answer.answer}',
                                    onTap: () {},
                                    isSelected: false,
                                  );
                                },
                                separatorBuilder: (_, int index) =>
                                    const SizedBox(height: 10),
                                itemCount: controller
                                    .currentQuestion.value!.answers.length,
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
                          child: MainButton(
                        onTap: () {
                          controller.isLastQuestion
                              ? Get.toNamed(ResultScreen.routeName)
                              : controller.nextQuestion();
                        },
                        title:
                            controller.isLastQuestion ? 'Go to Result' : 'Next',
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
