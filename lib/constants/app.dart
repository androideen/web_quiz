import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppConfig {
  static const String APP_NAME = 'Quiz';

  static const Color primaryColor = Colors.deepPurple;
  static const Color backgroundColor = Colors.deepPurpleAccent;
  static const Color textColor = Colors.white;

  static TextTheme textTheme = TextTheme(bodyText1: TextStyle(color: Colors.white), bodyText2: TextStyle(color: Colors.white));

  static mediaWidth(context){
    return  MediaQuery.of(context).size.width;
  }
  static mediaHeight(context){
    return  MediaQuery.of(context).size.height;
  }
}
