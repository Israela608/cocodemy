import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocodemy/firebase_ref/references.dart';
import 'package:cocodemy/models/question_paper_model.dart';
import 'package:cocodemy/services/firebase_storage_service.dart';
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
        //allPaperImages.add(imgUrl!); //////////////
      }
    } catch (e) {
      print(e);
    }
  }
}
