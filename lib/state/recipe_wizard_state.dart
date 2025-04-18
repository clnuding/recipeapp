import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recipeapp/models/recipe.dart';
import 'package:recipeapp/models/recipeingredients.dart';

class RecipeWizardState extends ChangeNotifier {
  String? _recipeId; // Will exist after creation
  String? _title;
  String? _description;
  File? _image;
  int _servings = 2;
  int _prepTimeMinutes = 30;
  List<String> _tagIds = [];
  List<Recipeingredients> _ingredients = [];

  // Getters
  String? get recipeId => _recipeId;
  String? get title => _title;
  String? get description => _description;
  File? get image => _image;
  int get servings => _servings;
  int get prepTimeMinutes => _prepTimeMinutes;
  List<String> get tagIds => _tagIds;
  List<Recipeingredients> get ingredients => _ingredients;

  // Setters
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

  void setRecipeId(String id) {
    _recipeId = id;
    notifyListeners();
  }

  Set<String> _submittedIngredientIds = {};

  void addIngredient(Recipeingredients ingredient) {
    if (!_submittedIngredientIds.contains(ingredient.id)) {
      _ingredients.add(ingredient);
      _submittedIngredientIds.add(ingredient.id);
      notifyListeners();
    }
  }

  void removeIngredient(String id) {
    _ingredients.removeWhere((ing) => ing.id == id);
    notifyListeners();
  }

  void clear() {
    _recipeId = null;
    _title = null;
    _description = null;
    _image = null;
    _servings = 2;
    _prepTimeMinutes = 30;
    _tagIds = [];
    _ingredients = [];
    notifyListeners();
    _submittedIngredientIds.clear();
  }
}
