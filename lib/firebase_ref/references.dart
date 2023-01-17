import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final fireStore = FirebaseFirestore.instance;

//If this variable is invoked, 'questionPaper' collection will be created in our firestore backend
final questionPaperRF = fireStore.collection('questionPapers');

DocumentReference questionRF({
  required String paperId,
  required String questionId,
})
//Locate the document with name the same as this paperId,
//Create a collection under this document with the name 'questions'
//Create a document under this collection with name the same as the questionId
    =>
    questionPaperRF.doc(paperId).collection('questions').doc(questionId);

// Firebase storage reference
Reference get firebaseStorage => FirebaseStorage.instance.ref();

final userRF = fireStore.collection('users');
