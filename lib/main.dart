import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:quiz/screens/home_screen.dart';
import 'package:quiz/screens/quiz_screen.dart';

import 'constants/app.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConfig.APP_NAME,
      initialRoute: '/',
      theme: ThemeData(
        primarySwatch: AppConfig.primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        backgroundColor: AppConfig.backgroundColor,
        scaffoldBackgroundColor: AppConfig.backgroundColor,
        textTheme: AppConfig.textTheme,
        primaryTextTheme: AppConfig.textTheme,
      ),
      getPages: [
        GetPage(name: '/', page: () => MyHomePage()),
        GetPage(
            name: '/quiz/:category',
            page: () => QuizPage(),
            transition: Transition.zoom),
      ],
    );
  }
}
