import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recipeapp/models/recipeingredients.dart';

class RecipeWizardState extends ChangeNotifier {
  String? _title;
  String? _description;
  File? _image;
  int _servings = 2;
  int _prepTimeMinutes = 30;
  List<String> _tagIds = [];
  List<Recipeingredients> _ingredients = [];

  // Getters
  String? get title => _title;
  String? get description => _description;
  File? get image => _image;
  int get servings => _servings;
  int get prepTimeMinutes => _prepTimeMinutes;
  List<String> get tagIds => _tagIds;
  List<Recipeingredients> get ingredients => _ingredients;

  // Set recipe info from AddRecipePage
  void setRecipeInfo({
    required String title,
    String? description,
    File? image,
    required int servings,
    required int prepTimeMinutes,
    required List<String> tagIds,
  }) {
    _title = title;
    _description = description;
    _image = image;
    _servings = servings;
    _prepTimeMinutes = prepTimeMinutes;
    _tagIds = tagIds;
    notifyListeners();
  }

  // Prevent duplicates using hash
  void addIngredient(Recipeingredients ingredient) {
    final isDuplicate = _ingredients.any(
      (i) =>
          i.ingredientId == ingredient.ingredientId &&
          i.measurementId == ingredient.measurementId &&
          i.quantity == ingredient.quantity,
    );

    if (!isDuplicate) {
      _ingredients.add(ingredient);
      notifyListeners();
    }
  }

  void removeIngredient(String ingredientId) {
    _ingredients.removeWhere((i) => i.ingredientId == ingredientId);
    notifyListeners();
  }

  void clear() {
    _title = null;
    _description = null;
    _image = null;
    _servings = 2;
    _prepTimeMinutes = 30;
    _tagIds = [];
    _ingredients = [];
    notifyListeners();
  }
}
