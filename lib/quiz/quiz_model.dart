import 'package:flutter/material.dart';
import 'package:quiz/common/app.dart';
import 'package:quiz/common/data.dart';
import 'package:quiz/quiz/quiz_repository.dart';


class QuizModel with ChangeNotifier {
  QuizRepository quizRepository = QuizRepository();
  Quiz quiz = Quiz();
  Question question = Question("", "", "");
  List<String> answers = [];
  int index = 0;

  String get progress => "${(index + 1)} / ${quiz.questionCount}";
  bool get isLastQuestion => index == quiz.questionCount - 1;

  void nextQuestion(){
    if (index < quiz.questions.length - 1){
      index++;
      showQuestion();
    }
  }

  void loadQuiz(Category category) async{
    quiz.category = category;
    quiz.questions = await quizRepository.loadQuiz(category.category);
    showQuestion();
  }

  void showQuestion(){
    question = quiz.questions[index];
    answers = List<String>(question.answer.length);
    resetAnswers();
    notifyListeners();
  }
  String answersAsString() {
    var result = '';
    for (var i = 0; i < question.answer.length; i++) {
      result += answers[i].toString().toUpperCase();
    }
    return result;
  }

  void resetAnswers() {
    for (var i = 0; i < question.answer.length; i++) {
      answers[i] = AppConfig.answerPlaceholder;
    }
    //answers.map((e) => quizRepository.answerPlaceholder);
  }
  void resetAnswer(int index){
    answers[index] = AppConfig.answerPlaceholder;
  }

  bool answerNotSet(int index) => answers[index].toUpperCase() == AppConfig.answerPlaceholder;
  //compare answer with answers
  bool isCorrect() => question.answer.toUpperCase() == answersAsString();
  String imageURL() => '${AppConfig.QUIZ_RESOURCES}${quiz.category.category}/${question.image}';

}