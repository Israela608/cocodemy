import 'package:cocodemy/controllers/auth_controller.dart';
import 'package:cocodemy/controllers/question_papers/question_paper_controller.dart';
import 'package:cocodemy/controllers/theme_controller.dart';
import 'package:cocodemy/services/firebase_storage_service.dart';
import 'package:get/get.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(ThemeController());
    // permanent = true means this controller should stay in memory
    Get.put(AuthController(), permanent: true);
    Get.put(FirebaseStorageService());
    Get.put(QuestionPaperController());
  }
}
