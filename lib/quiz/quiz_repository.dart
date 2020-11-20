import 'package:quiz/common/data.dart';
import 'package:quiz/quiz/quiz_service.dart';

class QuizRepository {
  final quizService = QuizService();

  Future<List<Question>> loadQuiz(String category) async {
    return quizService.loadQuiz(category);
  }
  String imageURL(String category, String image){
    return quizService.imageURL(category, image);
  }
}
