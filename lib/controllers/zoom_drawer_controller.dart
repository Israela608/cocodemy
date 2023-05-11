import 'package:cocodemy/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MyZoomDrawerController extends GetxController {
  final zoomDrawerController = ZoomDrawerController();
  Rxn<User?> user = Rxn();

  @override
  void onReady() {
    super.onReady();

    user.value = Get.find<AuthController>().getUser();
  }

  void toggleDrawer() {
    zoomDrawerController.toggle?.call();
    update();
  }

  void signOut() {
    Get.find<AuthController>().signOut();
  }

  void signIn() {}

  void website() {
    _launch('https://www.google.com');
  }

  void facebook() {
    _launch('https://www.facebook.com');
  }

  void email() {
    final Uri emailLaunchUri =
        Uri(scheme: 'mailto', path: 'israela608@gmail.com');
    _launch(emailLaunchUri.toString());
  }

  Future<void> _launch(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'could not launch $url';
    }
  }
}
