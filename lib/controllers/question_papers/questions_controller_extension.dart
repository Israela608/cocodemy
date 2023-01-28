import 'package:cocodemy/controllers/auth_controller.dart';
import 'package:cocodemy/controllers/question_papers/question_paper_controller.dart';
import 'package:cocodemy/controllers/question_papers/questions_controller.dart';
import 'package:cocodemy/firebase_ref/references.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

// An extension can access the properties of a class
// It is just an extension of the class not a separate class on it's own
// All parameters here can be accessed by calling the main class
extension QuestionsControllerExtension on QuestionsController {
  // Method that returns the number of correct answers in a test
  int get correctQuestionCount => allQuestions
      .where((element) => element.selectedAnswer == element.correctAnswer)
      .toList()
      .length;

  String get correctAnsweredQuestions {
    return '$correctQuestionCount out of ${allQuestions.length} are correct';
  }

  String get points {
    var score = correctQuestionCount / allQuestions.length;

    var timeDeduction = remainSeconds / questionPaperModel.timeSeconds;

    var points = score * timeDeduction * 1000;

    //Convert the points to two decimal places and return as String
    return points.toStringAsFixed(2);
  }

  //Method that restart a test
  void tryAgain() {
    Get.find<QuestionPaperController>()
        .navigateToQuestions(paper: questionPaperModel, tryAgain: true);
  }

  Future<void> saveTestResults() async {
    var batch = fireStore.batch();
    User? _user = Get.find<AuthController>().getUser();

    if (_user == null) return;

    batch.set(
        userRF
            .doc(_user.email)
            .collection('myrecent_tests')
            .doc(questionPaperModel.id),
        {
          'points': points,
          'correct_answer': '$correctQuestionCount/${allQuestions.length}',
          'question_id': questionPaperModel.id,
          'time': questionPaperModel.timeSeconds - remainSeconds,
        });

    batch.commit();

    navigateToHome();
  }
}
