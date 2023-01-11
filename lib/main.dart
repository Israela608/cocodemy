import 'package:cocodemy/bindings/initial_bindings.dart';
import 'package:cocodemy/controllers/theme_controller.dart';
import 'package:cocodemy/firebase_options.dart';
import 'package:cocodemy/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/*
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    GetMaterialApp(
      home: DataUploaderScreen(),
    ),
  );
}
*/

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  InitialBindings().dependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      //Use this theme
      theme: Get.find<ThemeController>().lightTheme,
      getPages: AppRoutes.routes(),
      //home: HomeScreen(),
    );
  }
}
