import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/event_model.dart';
import '../service/category_service.dart';
import '../service/event_service.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  final EventService _eventService = EventService();

  List<Category> _categories = [];
  List<EventModel> _events = [];
  bool _isLoading = false;

  List<Category> get categories => _categories;
  List<EventModel> get events => _events;
  bool get isLoading => _isLoading;

  CategoryProvider() {
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _categoryService.fetchCategories();
    } catch (e) {
      print("Erreur de chargement des catégories: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

}