import 'package:quiz/utils/quiz_utils.dart';

class Quiz {
  int score;
  Category category;
  List<Question> questions;

  int get questionCount => questions.length;

}

class Category {
  final String category;
  final String description;

  Category(this.category, this.description);

  Category.fromJson(Map<String, dynamic> json)
      : category = json['category'],
        description = json['description'];
}

class Question {
  final String question;
  final String image;
  final String answer;
  List<String> randomChoices;

  Question(this.question, this.image, this.answer);

  Question.fromJson(Map<String, dynamic> json)
      : question = json['question'],
        image = json['image'],
        randomChoices = json['randomChoices'],
        answer = json['answer'];
}
