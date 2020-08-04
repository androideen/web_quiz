import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz/models/quiz.dart';
import 'package:quiz/utils/quiz_utils.dart';

class QuizController extends GetxController{
  var quiz = Quiz();
  var index = 0.obs;
  var question = Question("", "", "").obs;
  List<String> choices = [];

  String get progress => "${(index.value + 1)} / ${quiz.questionCount}";

  @override
  void onInit() {
    super.onInit();
  }

  void loadQuiz(String category) async{
    quiz.category = Category(category, '');
    quiz.questions = await QuizUtil.loadQuiz(category);
    updateQuestion();
  }
  void updateIndex(){
    if (index.value < quiz.questions.length - 1){
      index.value++;
      updateQuestion();
    }
  }
  void updateQuestion(){
    question.value = quiz.questions[index.value];
    choices = List<String>(question.value.answer.length);
    resetAnswerControllers();
  }
  String choicesAsString() {
    var result = '';
    for (var i = 0; i < question.value.answer.length; i++) {
      result += choices[i].toString().toUpperCase();
    }
    return result;
  }

  void resetAnswerControllers() {
    for (var i = 0; i < question.value.answer.length; i++) {
      choices[i] = QuizUtil.answerPlaceholder;
    }
  }
  bool validateAnswer(){
    return question.value.answer.toUpperCase() == choicesAsString();
  }


  String imageURL(String image){
    return 'quiz/resources/${quiz.category.category}/$image';
  }
}