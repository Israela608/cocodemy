import 'package:cocodemy/controllers/question_papers/question_paper_controller.dart';
import 'package:cocodemy/controllers/zoom_drawer_controller.dart';
import 'package:cocodemy/screens/home/home_screen.dart';
import 'package:cocodemy/screens/introduction/introduction.dart';
import 'package:cocodemy/screens/splash/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static List<GetPage> routes() => [
        GetPage(
          name: '/',
          page: () => SplashScreen(),
        ),
        GetPage(
          name: '/introduction',
          page: () => AppIntroductionScreen(),
        ),
        GetPage(
            name: '/home',
            page: () => const HomeScreen(),
            binding: BindingsBuilder(() {
              Get.put(QuestionPaperController());
              Get.put(MyZoomDrawerController());
            })),
      ];
}
