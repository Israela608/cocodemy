import 'package:get/get.dart';

class AuthController extends GetxController {
  //onReady is a GetxController method that is called initially when the app is run
  @override
  void onReady() {
    initAuth();
    super.onReady();
  }

  void initAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    navigateToIntroduction();
  }

  //Move to introduction screen
  void navigateToIntroduction() {
    Get.offAllNamed('/introduction');
  }
}
