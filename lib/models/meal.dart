// User model
import 'package:recipeapp/models/recipe.dart';

class User {
  final String id;
  final String email;
  final String householdId;
  final String name;
  final String avatarUrl;

  User({
    required this.id,
    required this.email,
    required this.householdId,
    required this.name,
    this.avatarUrl = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      householdId: json['householdId'],
      name: json['name'],
      avatarUrl: json['avatarUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'householdId': householdId,
      'name': name,
      'avatarUrl': avatarUrl,
    };
  }
}

// Household model
class Household {
  final String id;
  final String name;
  final String createdBy;

  Household({required this.id, required this.name, required this.createdBy});

  factory Household.fromJson(Map<String, dynamic> json) {
    return Household(
      id: json['id'],
      name: json['name'],
      createdBy: json['createdBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'createdBy': createdBy};
  }
}

// MealPlan model with status
class MealPlan {
  final String id;
  final String householdId;
  final DateTime startDate;
  final DateTime endDate; // Calculated as startDate + 6 days
  final String status; // 'in_progress', 'finalized', 'completed'

  MealPlan({
    required this.id,
    required this.householdId,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['id'],
      householdId: json['householdId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'householdId': householdId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status,
    };
  }
}

// MealPlanParticipant model to track participants
class MealPlanParticipant {
  final String id;
  final String mealPlanId;
  final String userId;
  final bool selectionCompleted;

  MealPlanParticipant({
    required this.id,
    required this.mealPlanId,
    required this.userId,
    required this.selectionCompleted,
  });

  factory MealPlanParticipant.fromJson(Map<String, dynamic> json) {
    return MealPlanParticipant(
      id: json['id'],
      mealPlanId: json['mealPlanId'],
      userId: json['userId'],
      selectionCompleted: json['selectionCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mealPlanId': mealPlanId,
      'userId': userId,
      'selectionCompleted': selectionCompleted,
    };
  }
}

// MealPlanSelection model with mealPlanId
class MealPlanSelection {
  final String id;
  final String mealPlanId;
  final String userId;
  final DateTime date;
  final String mealType; // breakfast, lunch, dinner
  final bool planned;

  MealPlanSelection({
    required this.id,
    required this.mealPlanId,
    required this.userId,
    required this.date,
    required this.mealType,
    required this.planned,
  });

  factory MealPlanSelection.fromJson(Map<String, dynamic> json) {
    return MealPlanSelection(
      id: json['id'],
      mealPlanId: json['mealPlanId'],
      userId: json['userId'],
      date: DateTime.parse(json['date']),
      mealType: json['mealType'],
      planned: json['planned'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mealPlanId': mealPlanId,
      'userId': userId,
      'date': date.toIso8601String(),
      'mealType': mealType,
      'planned': planned,
    };
  }
}

// RecipeSelection model with mealPlanId
class RecipeSelection {
  final String id;
  final String mealPlanId;
  final String userId;
  final String recipeId;
  final bool selected;

  RecipeSelection({
    required this.id,
    required this.mealPlanId,
    required this.userId,
    required this.recipeId,
    required this.selected,
  });

  factory RecipeSelection.fromJson(Map<String, dynamic> json) {
    return RecipeSelection(
      id: json['id'],
      mealPlanId: json['mealPlanId'],
      userId: json['userId'],
      recipeId: json['recipeId'],
      selected: json['selected'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mealPlanId': mealPlanId,
      'userId': userId,
      'recipeId': recipeId,
      'selected': selected,
    };
  }
}

// MealPlanRecipe model
class MealPlanRecipe {
  final String id;
  final String mealPlanId;
  final DateTime date;
  final String mealType;
  final String recipeId;
  final int portions;
  final bool completed;

  // Expand related records
  final Recipe? recipe;

  MealPlanRecipe({
    required this.id,
    required this.mealPlanId,
    required this.date,
    required this.mealType,
    required this.recipeId,
    required this.portions,
    this.completed = false,
    this.recipe,
  });

  factory MealPlanRecipe.fromJson(Map<String, dynamic> json) {
    return MealPlanRecipe(
      id: json['id'],
      mealPlanId: json['mealPlanId'],
      date: DateTime.parse(json['date']),
      mealType: json['mealType'],
      recipeId: json['recipeId'],
      portions: json['portions'],
      completed: json['completed'] ?? false,
      recipe:
          json['expand']?['recipe'] != null
              ? Recipe.fromJson(json['expand']['recipe'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mealPlanId': mealPlanId,
      'date': date.toIso8601String(),
      'mealType': mealType,
      'recipeId': recipeId,
      'portions': portions,
      'completed': completed,
    };
  }
}
