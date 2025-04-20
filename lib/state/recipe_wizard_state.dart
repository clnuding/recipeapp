import 'dart:io';
import 'package:flutter/material.dart';
import 'package:recipeapp/models/recipeingredients.dart';
import 'package:recipeapp/models/tags.dart';

class RecipeWizardState extends ChangeNotifier {
  String? _recipeId;
  String? _title;
  String? _description;
  File? _image;
  int _servings = 2;
  int _prepTimeMinutes = 00;
  List<String> _tagIds = [];
  List<Tags> _tagObjects = [];
  List<Recipeingredients> _ingredients = [];
  bool _isEditing = false; // ✅ NEW

  // Getters
  String? get recipeId => _recipeId;
  String? get title => _title;
  String? get description => _description;
  File? get image => _image;
  int get servings => _servings;
  int get prepTimeMinutes => _prepTimeMinutes;
  List<String> get tagIds => _tagIds;
  List<Tags> get tagObjects => _tagObjects;
  List<Recipeingredients> get ingredients => _ingredients;
  bool get isEditing => _isEditing; // ✅ NEW

  // Setters
  void setRecipeId(String id) {
    _recipeId = id;
    notifyListeners();
  }

  void setEditing(bool value) {
    // ✅ NEW
    _isEditing = value;
    notifyListeners();
  }

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

  void setTagObjects(List<Tags> tags) {
    _tagObjects = tags;
    notifyListeners();
  }

  void addIngredient(Recipeingredients ingredient) {
    final index = _ingredients.indexWhere(
      (i) =>
          i.ingredientId == ingredient.ingredientId &&
          i.measurementId == ingredient.measurementId,
    );

    if (index != -1) {
      _ingredients[index] = ingredient;
    } else {
      _ingredients.add(ingredient);
    }
    notifyListeners();
  }

  void removeIngredient(String ingredientId) {
    _ingredients.removeWhere((i) => i.ingredientId == ingredientId);
    notifyListeners();
  }

  void clear() {
    _recipeId = null;
    _title = null;
    _description = null;
    _image = null;
    _servings = 2;
    _prepTimeMinutes = 00;
    _tagIds = [];
    _tagObjects = [];
    _ingredients = [];
    _isEditing = false; // ✅ RESET
    notifyListeners();
  }
}
