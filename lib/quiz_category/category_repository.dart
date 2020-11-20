
import 'package:quiz/common/data.dart';
import 'package:quiz/quiz_category/category_service.dart';

class CategoryRepository{
  final service = CategoryService();

  Future<List<Category>> categories() async{
    return await service.categories();
  }
}