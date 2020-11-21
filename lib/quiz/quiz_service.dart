import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:quiz/common/app.dart';
import 'package:quiz/common/data.dart';


class QuizService{
   Future<List<Question>> loadQuiz(String category) async {
    final data =
    await rootBundle.loadString(AppConfig.ASSET_QUIZ_RESOURCES_FOLDER + '$category.json');
    final List<dynamic> json = jsonDecode(data);
    List<Question> questions = [];
    for (var i = 0; i < json.length; i++) {
      final question = Question.fromJson(json[i]);
      question.randomChoices = _randomChoices(question.answer);
      questions.add(question);
    }
    return questions;
  }
   List<String> _randomChoices(String answer) {
     List<String> answerList = [];
     for (int i = 0; i < answer.length; i++) {
       answerList.add(answer[i].toUpperCase());
     }
     final rand = _randomString();
     var result = (answerList + rand)..shuffle();
     return result;
   }

   List<String> _randomString() {
     var vowels = "AEIOU";
     var consonants = "BCDFGHJKLMNPQRSTVWZ";
     var numbers = "0123456789";
     var rand = Random();
     var list1 = List<String>.generate(2, (index) {
       int i = rand.nextInt(vowels.length);
       return vowels[i];
     });
     var list2 = List<String>.generate(2, (index) {
       int i = rand.nextInt(consonants.length);
       return consonants[i];
     });
     var list3 = List<String>.generate(1, (index) {
       int i = rand.nextInt(numbers.length);
       return numbers[i];
     });
     return list1 + list2 + list3;
   }

   String imageURL(String category, String image){
     return '${AppConfig.QUIZ_FOLDER}$category/$image';
   }
}