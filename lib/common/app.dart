import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppConfig {
  static const String APP_NAME = 'Flutter Quiz';
  static const String WEBSITE = 'https://www.tldevtech.com';

  /*Theme*/
  static const Color primaryColor = Colors.blue;
  static const Color backgroundColor = Color(0xFFFEFEFE);
  static const Color containerColor = Colors.blue;
  static const Color textColor = Colors.black;
  static const Color textColorInContainer = Colors.white;
  static const Color successColor = Colors.lightGreen;

  static TextTheme textTheme = TextTheme(bodyText1: TextStyle(color: Colors.black), bodyText2: TextStyle(color: Colors.black));

  /*quiz*/
  static const ASSET_QUIZ_FOLDER = 'assets/quiz/';
  static const ASSET_QUIZ_RESOURCES_FOLDER = 'assets/quiz/resources/';
  static const QUIZ_FOLDER = 'quiz/';
  static const QUIZ_RESOURCES_FOLDER = 'quiz/resources/';
  static const QUIZ_CATEGORY_FILE = AppConfig.ASSET_QUIZ_FOLDER + 'quizzes.json';
  static const String answerPlaceholder = '_';


}
