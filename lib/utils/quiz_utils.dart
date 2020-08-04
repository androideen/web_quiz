import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:quiz/models/quiz.dart';

class QuizUtil {
  static const String answerPlaceholder = '_';
  static const QUIZ_FOLDER = 'quiz/';
  static const QUIZ_RESOURCES_FOLDER = 'quiz/resources/';

  static Future<List<Category>> loadQuizzes() async {
    final data = await rootBundle.loadString(QUIZ_FOLDER + 'quizzes.json');

    final List<dynamic> json = jsonDecode(data);
    List<Category> categories = List<Category>();
    for (var i = 0; i < json.length; i++) {
      final category = Category.fromJson(json[i]);
      categories.add(category);
    }
    return categories;
  }

  static Future<List<Question>> loadQuiz(String category) async {
    final data =
    await rootBundle.loadString(QUIZ_RESOURCES_FOLDER + '$category.json');
    final List<dynamic> json = jsonDecode(data);
    List<Question> questions = [];
    for (var i = 0; i < json.length; i++) {
      final question = Question.fromJson(json[i]);
      question.randomChoices = randomChoices(question.answer);
      questions.add(question);
    }
    return questions;
  }

  static List<String> randomChoices(String answer) {
    List<String> answerList = [];
    for (int i = 0; i < answer.length; i++) {
      answerList.add(answer[i].toUpperCase());
    }
    final rand = randomString();
    var result = (answerList + rand)..shuffle();
    return result;
  }

  static List<String> randomString() {
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

  static String imageURL(String category, String image){
    return 'quiz/${category}/$image';
  }

}
