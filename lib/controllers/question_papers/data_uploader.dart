import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocodemy/firebase_ref/loading_status.dart';
import 'package:cocodemy/firebase_ref/references.dart';
import 'package:cocodemy/models/question_paper_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class DataUploader extends GetxController {
  //Firebase method for uploading data to firebase. It is called only once when the app starts
  @override
  void onReady() {
    uploadData();
    super.onReady();
  }

  //This variable 'loadingStatus' is an observable, meaning it's reactive
  // .obs is a GetX property that made it reactive
  final loadingStatus = LoadingStatus.loading.obs;

  Future<void> uploadData() async {
    // .value holds the value of 'loadingStatus'. It is also a reactive property
    loadingStatus.value = LoadingStatus
        .loading; // 0  -> LoadingStatus.loading is 0, since it is the first of the enum

    //Get a firebase firestore instance
    final fireStore = FirebaseFirestore.instance;

    final manifestContent = await DefaultAssetBundle.of(Get.context!)
        .loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    //Load json files path
    final papersInAssets = manifestMap.keys
        .where((path) =>
            path.startsWith('assets/DB/paper') && path.contains('.json'))
        .toList();
    //print(papersInAssets);

    //We have to convert the json contents into a model.
    //Each json subject file becomes an object of QuestionPaperModel
    //So all 4 subjects become a list of QuestionPaperModels
    List<QuestionPaperModel> questionPapers = [];
    //Read the contents from the path
    for (var paper in papersInAssets) {
      String stringPaperContent = await rootBundle.loadString(paper);
      //print(stringPaperContent);

      //json.decode converts the String into a map
      //Note that jsonDecode() calls json.decode(), so they do the same thing
      questionPapers
          .add(QuestionPaperModel.fromJson(json.decode(stringPaperContent)));
    }

    //print('Items number   ${questionPapers[0].title}');

    /*
    Uploading all the data to firestore in a batch
    */
    // Number of documents to write per batch
    const batchSize = 200;
    // This is the batch
    var batch = fireStore.batch();
    // This is the counter that checks the number of batches currently uploaded
    var counter = 0;

    //This is the parent loop, that adds all the papers to the 'questionPapers' collection in firebase
    for (var paper in questionPapers) {
      //The id of the paper is the document name in the collection
      batch.set(questionPaperRF.doc(paper.id), {
        //These are the fields under the documents
        'title': paper.title,
        'image_url': paper.imageUrl,
        'description': paper.description,
        'time_seconds': paper.timeSeconds,
        'questions_count': paper.questions == null ? 0 : paper.questions!.length
      });

      //This loop adds all the questions to the 'questions' sub-collection under the parent collection
      for (var questions in paper.questions!) {
        final questionPath =
            questionRF(paperId: paper.id, questionId: questions.id);

        batch.set(questionPath, {
          'question': questions.question,
          'correct_answer': questions.correctAnswer
        });

        //This loop add all the answers to a question to the 'answers' sub-collection of that question
        for (var answer in questions.answers) {
          batch.set(questionPath.collection('answers').doc(answer.identifier), {
            'identifier': answer.identifier,
            'answer': answer.answer,
          });

          // If the batch has reached the maximum size, submit it to Firestore
          if (++counter == batchSize) {
            await batch.commit();

            // Start a new batch
            batch = fireStore.batch();
            counter = 0;
          }
        }
      }
    }

    // Submit the last batch, if it's not empty
    if (counter > 0) {
      await batch.commit();
    }

    loadingStatus.value = LoadingStatus.completed;
  }
}

/*
class DataUploader extends GetxController {
  //Firebase method for uploading data to firebase. It is called only once when the app starts
  @override
  void onReady() {
    uploadData();
    super.onReady();
  }

  //This variable 'loadingStatus' is an observable, meaning it's reactive
  // .obs is a GetX property that made it reactive
  final loadingStatus = LoadingStatus.loading.obs;

  Future<void> uploadData() async {
    // .value holds the value of 'loadingStatus'. It is also a reactive property
    loadingStatus.value = LoadingStatus
        .loading; // 0  -> LoadingStatus.loading is 0, since it is the first of the enum

    //Get a firebase firestore instance
    final fireStore = FirebaseFirestore.instance;

    final manifestContent = await DefaultAssetBundle.of(Get.context!)
        .loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    //Load json files path
    final papersInAssets = manifestMap.keys
        .where((path) =>
            path.startsWith('assets/DB/paper') && path.contains('.json'))
        .toList();
    //print(papersInAssets);

    //We have to convert the json contents into a model.
    //Each json subject file becomes an object of QuestionPaperModel
    //So all 4 subjects become a list of QuestionPaperModels
    List<QuestionPaperModel> questionPapers = [];
    //Read the contents from the path
    for (var paper in papersInAssets) {
      String stringPaperContent = await rootBundle.loadString(paper);
      //print(stringPaperContent);

      //json.decode converts the String into a map
      //Note that jsonDecode() calls json.decode(), so they do the same thing
      questionPapers
          .add(QuestionPaperModel.fromJson(json.decode(stringPaperContent)));
    }

    //print('Items number   ${questionPapers[0].title}');

    //Uploading all the data to firestore in a batch
    var batch = fireStore.batch();

    //This is the parent loop, that adds all the papers to the 'questionPapers' collection in firebase
    for (var paper in questionPapers) {
      //The id of the paper is the document name in the collection
      batch.set(questionPaperRF.doc(paper.id), {
        //These are the fields under the documents
        'title': paper.title,
        'image_url': paper.imageUrl,
        'description': paper.description,
        'time_seconds': paper.timeSeconds,
        'questions_count': paper.questions == null ? 0 : paper.questions!.length
      });

      //This loop adds all the questions to the 'questions' sub-collection under the parent collection
      for (var questions in paper.questions!) {
        final questionPath =
            questionRF(paperId: paper.id, questionId: questions.id);

        batch.set(questionPath, {
          'question': questions.question,
          'correct_answer': questions.correctAnswer
        });

        //This loop add all the answers to a question to the 'answers' sub-collection of that question
        for (var answer in questions.answers) {
          batch.set(questionPath.collection('answers').doc(answer.identifier), {
            'identifier': answer.identifier,
            'answer': answer.answer,
          });
        }
      }
    }

    //Submit the batch to firebase
    await batch.commit();

    loadingStatus.value = LoadingStatus.completed;
  }
}
*/
