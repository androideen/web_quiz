import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:quiz/common/app.dart';
import 'package:quiz/common/data.dart';

class CategoryService{
  Future<List<Category>> categories() async {
    final data = await rootBundle.loadString(AppConfig.QUIZ_CATEGORY_FILE);

    final List<dynamic> json = jsonDecode(data);
    List<Category> categories = List<Category>();
    for (var i = 0; i < json.length; i++) {
      final category = Category.fromJson(json[i]);
      categories.add(category);
    }
    return categories;
  }
}