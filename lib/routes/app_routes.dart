import 'package:cocodemy/controllers/question_papers/question_paper_controller.dart';
import 'package:cocodemy/controllers/question_papers/questions_controller.dart';
import 'package:cocodemy/controllers/zoom_drawer_controller.dart';
import 'package:cocodemy/screens/home/home_screen.dart';
import 'package:cocodemy/screens/introduction/introduction.dart';
import 'package:cocodemy/screens/login/login_screen.dart';
import 'package:cocodemy/screens/question/answer_check_screen.dart';
import 'package:cocodemy/screens/question/questions_screen.dart';
import 'package:cocodemy/screens/question/result_screen.dart';
import 'package:cocodemy/screens/question/test_overview_screen.dart';
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
            name: HomeScreen.routeName,
            page: () => const HomeScreen(),
            binding: BindingsBuilder(() {
              Get.put(QuestionPaperController());
              Get.put(MyZoomDrawerController());
            })),
        GetPage(
          name: LoginScreen.routeName,
          page: () => const LoginScreen(),
        ),
        GetPage(
            name: QuestionsScreen.routeName,
            page: () => const QuestionsScreen(),
            binding: BindingsBuilder(() {
              //We use the <Type> in this case because we are using id in Questions screen. So this will make sure we don't have any issues
              Get.put<QuestionsController>(QuestionsController());
            })),
        GetPage(
          name: TestOverviewScreen.routeName,
          page: () => const TestOverviewScreen(),
          //We don't need to bind QuestionController in this case, since this page will be called from QuestionsScreen and it has already been injected there
        ),
        GetPage(
          name: ResultScreen.routeName,
          page: () => const ResultScreen(),
        ),
        GetPage(
          name: AnswerCheckScreen.routeName,
          page: () => const AnswerCheckScreen(),
        ),
      ];
}
