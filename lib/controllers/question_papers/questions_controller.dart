import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocodemy/firebase_ref/loading_status.dart';
import 'package:cocodemy/firebase_ref/references.dart';
import 'package:cocodemy/models/question_paper_model.dart';
import 'package:cocodemy/screens/home/home_screen.dart';
import 'package:cocodemy/screens/question/result_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class QuestionsController extends GetxController {
  final loadingStatus = LoadingStatus.loading.obs;

  late QuestionPaperModel questionPaperModel;
  //All the questions in one paper
  final allQuestions = <Questions>[];
  //The current question we are in
  Rxn<Questions> currentQuestion = Rxn<Questions>();
  //The index of the question
  final questionIndex = 0.obs;
  //Return true if we are not in the first question
  bool get isNotFirstQuestion => questionIndex.value > 0;
  bool get isLastQuestion => questionIndex.value >= allQuestions.length - 1;

  //Timer
  Timer? _timer;
  int remainSeconds = 1;
  final time = '00.00'.obs;

  @override
  void onReady() {
    super.onReady();

    //We get the saved paper from Getx arguments through the type 'QuestionPaperModel'
    final _questionPaper = Get.arguments as QuestionPaperModel;
    print(_questionPaper.title);
    print('...onReady...');

    loadData(_questionPaper);
  }

  //Load the questions of a paper from firebase
  void loadData(QuestionPaperModel questionPaper) async {
    questionPaperModel = questionPaper;
    loadingStatus.value = LoadingStatus.loading;

    try {
      //We use the id of the question paper to get the questions of the particular paper
      final QuerySnapshot<Map<String, dynamic>> questionQuery =
          await questionPaperRF
              .doc(questionPaper.id)
              .collection('questions')
              .get();

      //Convert the map to list
      final questions = questionQuery.docs
          .map((snapshot) => Questions.fromSnapshot(snapshot))
          .toList();

      //Save it to the 'questions' parameter of the model
      questionPaper.questions = questions;

      //Loop through the questions in the model
      for (Questions _question in questionPaper.questions!) {
        //For each of the question, we get the answers from firebase by using the question id
        final QuerySnapshot<Map<String, dynamic>> answersQuery =
            await questionPaperRF
                .doc(questionPaper.id)
                .collection('questions')
                .doc(_question.id)
                .collection('answers')
                .get();

        //We convert the answers from map to list
        final answers = answersQuery.docs
            .map((answer) => Answers.fromSnapshot(answer))
            .toList();

        //We assign the answers to the 'answers' list parameter of the particular question in the Questions model
        _question.answers = answers;
      }

      //If there are questions in the Questions model of this paper
      if (questionPaper.questions != null &&
          questionPaper.questions!.isNotEmpty) {
        //We assign all the questions to the allQuestions list
        allQuestions.assignAll(questionPaper.questions!);

        currentQuestion.value = questionPaper.questions![0];

        _startTimer(questionPaperModel.timeSeconds);
        print('...startTimer...');

        if (kDebugMode) {
          print(questionPaper.questions![0].question);
        }
        loadingStatus.value = LoadingStatus.completed;
      } else {
        loadingStatus.value = LoadingStatus.error;
      }
    } catch (e) {
      // Only run the print statement when the app is in debug mode
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  //Method that set the selected answer parameter in the Questions model to the selected answer from the list of answers
  void selectedAnswer(String? answer) {
    currentQuestion.value!.selectedAnswer = answer;
    //Update only the Widget with this id, not all the Widgets where QuestionController is implemented
    update(['answer_list', 'answer_review_list']);
  }

  void nextQuestion() {
    //If last question
    if (questionIndex.value >= allQuestions.length - 1) {
      //break the method
      return;
    }

    questionIndex.value++;
    currentQuestion.value = allQuestions[questionIndex.value];
  }

  void previousQuestion() {
    //If first question
    if (questionIndex.value <= 0) {
      //break the method
      return;
    }

    questionIndex.value--;
    currentQuestion.value = allQuestions[questionIndex.value];
  }

  _startTimer(int seconds) {
    const duration = Duration(seconds: 1);
    remainSeconds = seconds;
    _timer = Timer.periodic(duration, (Timer timer) {
      if (remainSeconds == 0) {
        timer.cancel();
      } else {
        int minutes = remainSeconds ~/ 60;
        int seconds = remainSeconds % 60;
        time.value =
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
        remainSeconds--;
      }
    });
  }

  //Get the number of questions that was answered
  String get completedQuestions {
    final answered = allQuestions
        .where((element) => element.selectedAnswer != null)
        .toList()
        .length;
    return '$answered out of ${allQuestions.length} answered';
  }

  //Method that takes the user to the exact question that was clicked
  void jumpToQuestion(int index, {bool isGoBack = true}) {
    questionIndex.value = index;
    currentQuestion.value = allQuestions[index];
    if (isGoBack) {
      Get.back();
    }
  }

  //What happens when you press the 'complete' button
  void complete() {
    _timer!.cancel();
    Get.offAndToNamed(ResultScreen.routeName);
  }

  //Method that takes the user back to the homepage
  void navigateToHome() {
    _timer!.cancel();
    //Go to the Home screen and Pop all the routes behind
    Get.offNamedUntil(HomeScreen.routeName, (route) => false);
  }
}
