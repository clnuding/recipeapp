// User model

// ============================================================================
// MEAL PLAN MODEL
// ============================================================================

// MealPlan model with status
import 'package:recipeapp/models/recipe.dart';

class MealPlan {
  final String id;
  final String householdId;
  final String userId;
  final DateTime startDate;
  final DateTime endDate; // Calculated as startDate + 6 days
  final String status; // 'in_progress', 'finalized', 'completed'

  MealPlan({
    required this.id,
    required this.householdId,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['id'],
      householdId: json['household_id'],
      userId: json['user_id'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'household_id': householdId,
      'user_id': userId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'status': status,
    };
  }
}

// ============================================================================
// RECIPE SUBCLASSES FOR MEAL PLANNING
// ============================================================================

// Analysis of recipe selections across household members.
class RecipeSelectionAnalysis {
  final Set<String> allSelected;
  final Set<String> common;

  RecipeSelectionAnalysis({required this.allSelected, required this.common});
}

/// Categorized recipes by meal type and preference, including always-planned recipes.
class RecipeCategoriesWithFrequency {
  final Set<String> breakfastCommon;
  final Set<String> breakfastFillers;
  final Set<String> mainCommon;
  final Set<String> mainFillers;
  final List<Recipe> alwaysPlannedBreakfasts;
  final List<Recipe> alwaysPlannedMains;

  RecipeCategoriesWithFrequency({
    required this.breakfastCommon,
    required this.breakfastFillers,
    required this.mainCommon,
    required this.mainFillers,
    required this.alwaysPlannedBreakfasts,
    required this.alwaysPlannedMains,
  });
}

// Recipe categorization by meal type.
class RecipeCategorization {
  final Set<String> breakfastIds;
  final Set<String> mainIds;

  RecipeCategorization({required this.breakfastIds, required this.mainIds});
}

// Selected recipes for meal plan generation.
class SelectedRecipes {
  final List<String> breakfasts;
  final List<String> mains;

  SelectedRecipes({required this.breakfasts, required this.mains});
}

/// Statistics about recipe planning for a household.
class RecipePlanningStats {
  final int totalRecipes;
  final int alwaysPlannedRecipes;
  final int breakfastRecipes;
  final int mainMealRecipes;
  final int highFrequencyRecipes;
  final int totalAlwaysPlannedSlots;

  RecipePlanningStats({
    required this.totalRecipes,
    required this.alwaysPlannedRecipes,
    required this.breakfastRecipes,
    required this.mainMealRecipes,
    required this.highFrequencyRecipes,
    required this.totalAlwaysPlannedSlots,
  });

  /// Returns true if always-planned recipes would exceed available meal slots.
  bool hasCapacityIssues(Map<String, int> mealCounts) {
    final breakfastSlots = mealCounts['breakfast'] ?? 0;
    final dinnerSlots = mealCounts['dinner'] ?? 0;

    // This is a simplified check - in practice you'd want to separate
    // always-planned breakfast vs dinner recipes
    return totalAlwaysPlannedSlots > (breakfastSlots + dinnerSlots);
  }
}

// ============================================================================
// LEGACY
// ============================================================================

// // MealPlanParticipant model to track participants
// class MealPlanParticipant {
//   final String id;
//   final String mealPlanId;
//   final String userId;
//   final bool selectionCompleted;

//   MealPlanParticipant({
//     required this.id,
//     required this.mealPlanId,
//     required this.userId,
//     required this.selectionCompleted,
//   });

//   factory MealPlanParticipant.fromJson(Map<String, dynamic> json) {
//     return MealPlanParticipant(
//       id: json['id'],
//       mealPlanId: json['mealPlanId'],
//       userId: json['userId'],
//       selectionCompleted: json['selectionCompleted'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'mealPlanId': mealPlanId,
//       'userId': userId,
//       'selectionCompleted': selectionCompleted,
//     };
//   }
// }

// MealPlanSelection model with mealPlanId
// class MealPlanSelection {
//   final String id;
//   final String mealPlanId;
//   final String userId;
//   final DateTime date;
//   final String mealType; // breakfast, lunch, dinner
//   final bool planned;

//   MealPlanSelection({
//     required this.id,
//     required this.mealPlanId,
//     required this.userId,
//     required this.date,
//     required this.mealType,
//     required this.planned,
//   });

//   factory MealPlanSelection.fromJson(Map<String, dynamic> json) {
//     return MealPlanSelection(
//       id: json['id'],
//       mealPlanId: json['mealPlanId'],
//       userId: json['userId'],
//       date: DateTime.parse(json['date']),
//       mealType: json['mealType'],
//       planned: json['planned'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'mealPlanId': mealPlanId,
//       'userId': userId,
//       'date': date.toIso8601String(),
//       'mealType': mealType,
//       'planned': planned,
//     };
//   }
// }

// // RecipeSelection model with mealPlanId
// class RecipeSelection {
//   final String id;
//   final String mealPlanId;
//   final String userId;
//   final String recipeId;
//   final bool selected;

//   RecipeSelection({
//     required this.id,
//     required this.mealPlanId,
//     required this.userId,
//     required this.recipeId,
//     required this.selected,
//   });

//   factory RecipeSelection.fromJson(Map<String, dynamic> json) {
//     return RecipeSelection(
//       id: json['id'],
//       mealPlanId: json['mealPlanId'],
//       userId: json['userId'],
//       recipeId: json['recipeId'],
//       selected: json['selected'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'mealPlanId': mealPlanId,
//       'userId': userId,
//       'recipeId': recipeId,
//       'selected': selected,
//     };
//   }
// }

// // MealPlanRecipe model
// class MealPlanRecipe {
//   final String id;
//   final String mealPlanId;
//   final DateTime date;
//   final String mealType;
//   final String recipeId;
//   final int portions;
//   final bool completed;

//   // Expand related records
//   final Recipe? recipe;

//   MealPlanRecipe({
//     required this.id,
//     required this.mealPlanId,
//     required this.date,
//     required this.mealType,
//     required this.recipeId,
//     required this.portions,
//     this.completed = false,
//     this.recipe,
//   });

//   factory MealPlanRecipe.fromJson(Map<String, dynamic> json) {
//     return MealPlanRecipe(
//       id: json['id'],
//       mealPlanId: json['mealPlanId'],
//       date: DateTime.parse(json['date']),
//       mealType: json['mealType'],
//       recipeId: json['recipeId'],
//       portions: json['portions'],
//       completed: json['completed'] ?? false,
//       recipe:
//           json['expand']?['recipe'] != null
//               ? Recipe.fromJson(json['expand']['recipe'])
//               : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'mealPlanId': mealPlanId,
//       'date': date.toIso8601String(),
//       'mealType': mealType,
//       'recipeId': recipeId,
//       'portions': portions,
//       'completed': completed,
//     };
//   }
// }
