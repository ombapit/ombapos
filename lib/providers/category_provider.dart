import 'package:flutter/material.dart';
import 'package:ombapos/helpers/dao/category_dao.dart';
import 'package:ombapos/models/category_model.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryDao _dao = CategoryDao();
  List<Category> _categories = [];

  List<Category> get categories => _categories;

  Future<void> fetchCategories() async {
    _categories = await _dao.getAll();
    notifyListeners();
  }

  Future<void> addCategory(String name) async {
    await _dao.insert(Category(name: name));
    await fetchCategories();
  }

  Future<void> updateCategory(Category category) async {
    await _dao.update(category);
    await fetchCategories();
  }

  Future<void> deleteCategory(int id) async {
    await _dao.delete(id);
    await fetchCategories();
  }
}
