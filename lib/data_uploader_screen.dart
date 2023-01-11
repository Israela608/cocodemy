import 'package:cocodemy/controllers/question_papers/data_uploader.dart';
import 'package:cocodemy/firebase_ref/loading_status.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataUploaderScreen extends StatelessWidget {
  DataUploaderScreen({Key? key}) : super(key: key);

  DataUploader controller = Get.put(DataUploader());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Obx() is a GetX function used for Observable/Reactive variables
        child: Obx(() => Text(
            controller.loadingStatus.value == LoadingStatus.completed
                ? 'Uploading completed'
                : 'Uploading...')),
      ),
    );
  }
}
