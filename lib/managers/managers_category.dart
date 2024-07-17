
import 'dart:convert';

import '../models/models_category.dart';

class CategoryManager {
  static final CategoryManager _instance = CategoryManager._internal();
  List<Category> categories = [];

  factory CategoryManager() {
    return _instance;
  }

  CategoryManager._internal();

  void updateCategories(String jsonResponse) {
    final data = jsonDecode(jsonResponse)['categoryList'] as List;
    categories = data.map((json) => Category.fromJson(json)).toList();
  }
}

class CategoryDetailsManager {
  static final CategoryDetailsManager _instance = CategoryDetailsManager._internal();

  CategoryDetails? currentCategory;
  Map<String, CategoryDetails> categoryDetailsMap = {};

  factory CategoryDetailsManager() {
    return _instance;
  }

  CategoryDetailsManager._internal();

  void updateCategoryDetails(String jsonResponse) {
    final data = jsonDecode(jsonResponse);
    final categoryDetails = CategoryDetails.fromJson(data);
    currentCategory = categoryDetails;
    categoryDetailsMap[categoryDetails.id] = categoryDetails; // Map 업데이트
  }

  CategoryDetails? getCategoryDetails(String categoryId) {
    return categoryDetailsMap[categoryId];
  }
}
