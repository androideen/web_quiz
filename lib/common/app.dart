import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppConfig {
  static const String APP_NAME = 'Quiz';

  static const Color primaryColor = Colors.blue;
  static const Color backgroundColor = Color(0xFFFEFEFE);
  static const Color containerColor = Colors.blue;
  static const Color textColor = Colors.black;
  static const Color textColorInContainer = Colors.white;
  static const Color successColor = Colors.lightGreen;

  static TextTheme textTheme = TextTheme(bodyText1: TextStyle(color: Colors.black), bodyText2: TextStyle(color: Colors.black));

  static const ASSET_QUIZ_FOLDER = 'assets/quiz/';
  static const ASSET_QUIZ_RESOURCES_FOLDER = 'assets/quiz/resources/';
  static const QUIZ_FOLDER = 'quiz/';
  static const QUIZ_RESOURCES = 'quiz/resources/';
  static const QUIZ_CATEGORY_FILE = 'quizzes.json';
  static const String answerPlaceholder = '_';

  static mediaWidth(context){
    return  MediaQuery.of(context).size.width;
  }
  static mediaHeight(context){
    return  MediaQuery.of(context).size.height;
  }
}
