import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:quiz/quiz/quiz_model.dart';
import 'package:quiz/quiz/quiz_screen.dart';
import 'package:quiz/quiz_category/category_screen.dart';

import 'common/app.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => QuizModel()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.APP_NAME,
      theme: ThemeData(
        primarySwatch: AppConfig.primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        backgroundColor: AppConfig.backgroundColor,
        scaffoldBackgroundColor: AppConfig.backgroundColor,
        textTheme: AppConfig.textTheme,
        primaryTextTheme: AppConfig.textTheme,
      ),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => CategoryPage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/quiz': (context) =>
            QuizPage(category: ModalRoute.of(context).settings.arguments),
      },
    );
  }
}
