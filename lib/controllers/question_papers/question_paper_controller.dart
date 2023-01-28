import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocodemy/controllers/auth_controller.dart';
import 'package:cocodemy/firebase_ref/references.dart';
import 'package:cocodemy/models/question_paper_model.dart';
import 'package:cocodemy/screens/home/home_screen.dart';
import 'package:cocodemy/screens/question/questions_screen.dart';
import 'package:cocodemy/services/firebase_storage_service.dart';
import 'package:cocodemy/utils/app_logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class QuestionPaperController extends GetxController {
  // Our list of image paths
  //final allPaperImages = <String>[].obs;
  final allPapers = <QuestionPaperModel>[].obs;

  @override
  void onReady() {
    super.onReady();
    getAllPapers();
  }

  Future<void> getAllPapers() async {
    // List of all the papers names
    //List<String> imgName = ['biology', 'chemistry', 'maths', 'physics'];

    try {
      //Get all the data or documents from the questionPapers collection
      QuerySnapshot<Map<String, dynamic>> data =
          await questionPaperRF.get(); /////////

      //We convert the snapshot map to a list of QuestionPaperModel by looping through it
      final paperList = data.docs
          .map((paper) => QuestionPaperModel.fromSnapshot(paper))
          .toList();

      //Assign it to our allPaper list
      allPapers.assignAll(paperList);

      for (var paper in paperList) {
        // We use the name or title of the paper to get the image path from firebase storage
        final imgUrl =
            await Get.find<FirebaseStorageService>().getImage(paper.title);

        // We assign the image Url from firebase to our imageUrl model field for that particular paper
        paper.imageUrl = imgUrl;

        //Re-assign it to our allPaper list in case of any changes
        allPapers.assignAll(paperList);

        //We add the path to our list of image paths
        //allPaperImages.add(imgUrl!); /////////////
      }
    } catch (e) {
      AppLogger.e(e);
    }
  }

  //Method that opens the Questions page for a particular paper that is clicked
  void navigateToQuestions({
    required QuestionPaperModel paper,
    bool tryAgain = false,
  }) {
    AuthController _authController = Get.find();

    if (_authController.isLoggedIn()) {
      if (tryAgain) {
        //Go to Questions screen and Remove all the routes (including the QuestionsScreen route, so as to restart the test) opened until the Home screen.
        //So if we decide to go back, we go directly to the Home screen
        Get.offNamedUntil(
          QuestionsScreen.routeName,
          arguments: paper,
          ModalRoute.withName(HomeScreen.routeName),
        );
      } else {
        print('logged in');
        //This will also save the particular paper to Getx arguments
        Get.toNamed(QuestionsScreen.routeName, arguments: paper);
      }
    } else {
      print('The title is ${paper.title}');
      _authController.showLoginAlertDialog();
    }
  }
}
