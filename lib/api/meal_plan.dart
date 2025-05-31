import 'dart:math';
import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:recipeapp/api/pb_client.dart';
// import 'package:recipeapp/api/shopping_list.dart';
import 'package:recipeapp/api/utils.dart';
import 'package:recipeapp/models/meal.dart';
import 'package:recipeapp/models/tags.dart';

class MealPlannerService {
  // late final ShoppingListService _shoppingListService;
  late String mealPlanId;
  late DateTime startDate;
  late String startDateString;
  late String householdId;
  late String userId;

  MealPlannerService() {
    // _shoppingListService = ShoppingListService();
    userId = pb.authStore.record!.id;
    householdId = pb.authStore.record!.getStringValue('household_id');
  }

  // Create a new meal plan in 'in_progress' state
  Future<void> createMealPlan(String householdId, DateTime startDate) async {
    // create datetime string to compare in db
    final startDateString = createDateTimeString(startDate);

    final existingId = await findExistingId(
      collectionName: 'mealPlans',
      filters: {'household_id': householdId, 'start_date': startDateString},
    );

    if (existingId != null) {
      this.mealPlanId = existingId;
      this.startDateString = startDateString;
      this.startDate = startDate;
      return;
    }

    // Start date for the plan is current date
    final DateTime endDate = startDate.add(Duration(days: 6));

    // Create a meal plan record
    final mealPlanResponse = await pb
        .collection('mealPlans')
        .create(
          body: {
            'household_id': householdId,
            'user_id': userId,
            'start_date': DateFormat('yyyy-MM-dd').format(startDate),
            'end_date': DateFormat('yyyy-MM-dd').format(endDate),
            'status': 'in_progress',
          },
        );

    final String mealPlanId = mealPlanResponse.id;

    // Add all household members as participants
    final usersResponse = await pb
        .collection('users')
        .getList(filter: 'household_id = "$householdId"');

    for (var user in usersResponse.items) {
      await pb
          .collection('mealPlanParticipants')
          .create(
            body: {
              'household_id': householdId,
              'meal_plan_id': mealPlanId,
              'user_id': user.id,
              'selection_completed': false,
            },
          );
    }
    print("created Mealplan with id: $mealPlanId");
    this.mealPlanId = mealPlanId;
    this.startDateString = startDateString;
    this.startDate = startDate;
  }

  // Inserts a meal plan selection for one meal for the given user.
  Future<void> insertMealDaySelection(
    Map<String, Map<String, int>> selectedMeals,
  ) async {
    final existingId = await findExistingId(
      collectionName: 'mealPlanDaySelections',
      filters: {
        'meal_plan_id': mealPlanId,
        'date': startDateString,
        'user_id': userId,
      },
    );
    final batch = pb.createBatch();
    if (existingId != null) {
      for (var entry in selectedMeals.entries) {
        final dateStr = entry.key;
        final meals = entry.value; // { "breakfast": state, ... }
        batch
            .collection('mealPlanDaySelections')
            .update(
              existingId,
              body: {
                'date': dateStr,
                'breakfast': meals['breakfast'] == 0 ? false : true,
                'lunch': meals['lunch'] == 0 ? false : true,
                'dinner': meals['dinner'] == 0 ? false : true,
              },
            );
      }
    } else {
      for (var entry in selectedMeals.entries) {
        final dateStr = entry.key;
        final meals = entry.value; // { "breakfast": state, ... }
        batch
            .collection('mealPlanDaySelections')
            .create(
              body: {
                'household_id': householdId,
                'meal_plan_id': mealPlanId,
                'user_id': pb.authStore.record?.id,
                'date': dateStr,
                'breakfast': meals['breakfast'] == 0 ? false : true,
                'lunch': meals['lunch'] == 0 ? false : true,
                'dinner': meals['dinner'] == 0 ? false : true,
              },
            );
      }
    }
    await batch.send();
  }

  // Inserts a recipe selection (accepted or rejected) for the given user.
  Future<void> insertRecipeSelection(List<String> recipeIds) async {
    // Check if a record already exists
    final existingId = await findExistingId(
      collectionName: 'recipeSelections',
      filters: {'meal_plan_id': mealPlanId, 'user_id': userId},
    );

    if (existingId != null) {
      await pb
          .collection('recipeSelections')
          .update(existingId, body: {'recipe_ids': recipeIds});
    } else {
      // Create new record
      await pb
          .collection('recipeSelections')
          .create(
            body: {
              'household_id': householdId,
              'user_id': userId,
              'meal_plan_id': mealPlanId,
              'recipe_ids': recipeIds,
            },
          );
    }
  }

  // Mark a user's selection as completed
  Future<void> markUserSelectionAsCompleted() async {
    final recordId = await findExistingId(
      collectionName: 'mealPlanParticipants',
      filters: {'meal_plan_id': mealPlanId, 'user_id': userId},
    );

    if (recordId != null) {
      await pb
          .collection('mealPlanParticipants')
          .update(recordId, body: {'selection_completed': true});
    }

    // Check if all users have completed their selections
    await checkAndFinalizeMealPlan();
  }

  // Check whether all household users have completed their recipe selection.
  Future<bool> checkHouseholdSelectionsCompleted() async {
    final participantsResponse = await pb
        .collection('mealPlanParticipants')
        .getList(filter: 'meal_plan_id = "$mealPlanId"');

    if (participantsResponse.items.isEmpty) return false;

    // Check if all participants have completed their selections
    for (var participant in participantsResponse.items) {
      if (participant.data['selection_completed'] != true) {
        return false;
      }
    }

    return true;
  }

  // Check if all users have completed selections and finalize the meal plan if so
  Future<void> checkAndFinalizeMealPlan() async {
    final allCompleted = await checkHouseholdSelectionsCompleted();

    if (allCompleted) {
      // Update the meal plan status
      await pb
          .collection('mealPlans')
          .update(mealPlanId, body: {'status': 'finalized'});

      // Generate the final meal plan
      await finalizeMealPlan();

      // // Generate shopping list
      // await _shoppingListService.generateShoppingListFromMealPlan(mealPlanId);
    }
  }

  Future<void> finalizeMealPlan() async {
    // Retrieve users in this household
    final usersResponse = await pb
        .collection('users')
        .getList(filter: 'household_id = "$householdId"');

    final List<String> userIds = usersResponse.items.map((e) => e.id).toList();

    // Get accepted recipes for each user
    final Map<String, List<String>> userAcceptedRecipes = {};
    for (var userId in userIds) {
      final selections = await pb
          .collection('recipeSelections')
          .getList(
            filter: 'user_id = "$userId" && meal_plan_id = "$mealPlanId"',
          );
      userAcceptedRecipes[userId] = List<String>.from(
        selections.items.first.data['recipe_ids'],
      );
    }

    // Compute intersection (common) and union of accepted recipes
    Set<String> commonRecipes =
        userAcceptedRecipes.values.isNotEmpty
            ? userAcceptedRecipes.values.first.toSet()
            : {};
    for (var recipes in userAcceptedRecipes.values.skip(1)) {
      commonRecipes = commonRecipes.intersection(recipes.toSet());
    }

    final Set<String> unionRecipes = userAcceptedRecipes.values
        .fold<Set<String>>({}, (all, list) => all..addAll(list));

    // Count how many meals of each type we need
    final Map<String, int> neededByType = await countPlannedMealsByType();

    // Helper: group recipe IDs by their "meal_type" tag
    Future<Map<String, List<String>>> groupByMealType(Set<String> ids) async {
      final Map<String, List<String>> map = {
        'breakfast': [],
        'lunch': [],
        'dinner': [],
      };
      if (ids.isEmpty) return map;

      // build: id = "a" || id = "b" ...
      final filter = makeIdListFilter(ids.toList());

      // Fetch tag info in batch
      final resp = await pb
          .collection('recipes')
          .getList(filter: filter, expand: 'tag_id');

      for (var item in resp.items) {
        final tagsRecords = (item.get<List<RecordModel>>('expand.tag_id'));
        List<Tags> tags =
            tagsRecords.map((e) => Tags.fromJson(e.toJson())).toList();

        for (var tag in tags) {
          if (tag.category == 'meal_type') {
            map[tag.internal]!.add(item.id);
          }
        }
      }
      return map;
    }

    // Prepare final candidates per meal type
    final Map<String, List<String>> candidatesByType = {
      'breakfast': [],
      'lunch': [],
      'dinner': [],
    };

    print("neededByType: $neededByType");

    // Fill from commonRecipes first
    final commonByType = await groupByMealType(commonRecipes);
    commonByType.forEach((meal, list) {
      final take = neededByType[meal]!;
      candidatesByType[meal] = list.take(take).toList();
    });

    // Fill shortages from unionRecipes
    final unionByType = await groupByMealType(
      unionRecipes..removeAll(commonRecipes),
    );

    for (var meal in candidatesByType.keys) {
      final have = candidatesByType[meal]!.length;
      final need = neededByType[meal]! - have;
      if (need > 0) {
        candidatesByType[meal]!.addAll(unionByType[meal]!.take(need).toList());
      }
      // Shuffle each meal list
      candidatesByType[meal]!.shuffle(Random());
    }

    // Batch create mealPlanRecipes entries
    final batch = pb.createBatch();
    for (int dayOffset = 0; dayOffset < 7; dayOffset++) {
      final date = startDate.add(Duration(days: dayOffset)).toIso8601String();
      for (var meal in ['breakfast', 'lunch', 'dinner']) {
        final list = candidatesByType[meal]!;
        if (list.isEmpty) continue;
        final recipeId = list.removeAt(0);
        final servings = await getHouseholdSize(householdId);
        batch
            .collection('mealPlanRecipes')
            .create(
              body: {
                'household_id': householdId,
                'meal_plan_id': mealPlanId,
                'date': date,
                'meal_type': meal,
                'recipe_id': recipeId,
                'servings': servings,
                'completed': false,
              },
            );
      }
    }
    await batch.send();
  }

  // Mark a meal as completed
  Future<void> markMealAsCompleted(
    String mealPlanRecipeId,
    bool completed,
  ) async {
    await pb
        .collection('meal_plan_recipes')
        .update(mealPlanRecipeId, body: {'completed': completed});

    // Check if all meals are completed to mark the meal plan as completed
    final mealPlanRecipeResponse = await pb
        .collection('meal_plan_recipes')
        .getOne(mealPlanRecipeId);
    final mealPlanId = mealPlanRecipeResponse.data['mealPlanId'];

    await checkIfMealPlanCompleted(mealPlanId);
  }

  // Check if all meals in a plan are completed and update status accordingly
  Future<void> checkIfMealPlanCompleted(String mealPlanId) async {
    final mealRecipesResponse = await pb
        .collection('meal_plan_recipes')
        .getList(filter: 'mealPlanId = "$mealPlanId"');

    bool allCompleted = true;
    for (var meal in mealRecipesResponse.items) {
      if (meal.data['completed'] != true) {
        allCompleted = false;
        break;
      }
    }

    if (allCompleted && mealRecipesResponse.items.isNotEmpty) {
      await pb
          .collection('meal_plans')
          .update(mealPlanId, body: {'status': 'completed'});
    }
  }

  // Helper function to get household size
  Future<int> getHouseholdSize(String householdId) async {
    final householdResponse = await pb
        .collection('users')
        .getList(filter: 'household_id = "$householdId"');

    return householdResponse.items.length;
  }

  // Get current week's meal plan for a household
  Future<Map<String, dynamic>?> getCurrentMealPlan(String householdId) async {
    try {
      final now = DateTime.now();
      final response = await pb
          .collection('meal_plans')
          .getList(
            filter:
                'householdId = "$householdId" && startDate <= "${now.toIso8601String()}" && endDate >= "${now.toIso8601String()}"',
            sort: '-created',
          );

      if (response.items.isEmpty) {
        return null;
      }

      return response.items.first.data;
    } catch (e) {
      print('Error getting current meal plan: $e');
      return null;
    }
  }

  // Get meals for a specific day in a meal plan
  Future<List<Map<String, dynamic>>> getMealsForDay(
    String mealPlanId,
    DateTime date,
  ) async {
    final dateString =
        DateTime(
          date.year,
          date.month,
          date.day,
        ).toIso8601String().split('T')[0];

    final response = await pb
        .collection('meal_plan_recipes')
        .getList(
          filter: 'meal_plan_id = "$mealPlanId" && date ~ "$dateString"',
          expand: 'recipe',
        );

    return response.items.map((item) => item.data).toList();
  }

  Future<bool> deleteMealPlan(String mealPlanId) async {
    try {
      await pb.collection('mealPlans').delete(mealPlanId);
      return true;
    } catch (e) {
      print('Error deleting meal plan: $e');
      return false;
    }
  }

  Future<MealPlan?> mealPlanExists(
    DateTime startDate,
    String householdId,
  ) async {
    final startDateString = createDateTimeString(startDate);
    final response = await pb
        .collection('mealPlans')
        .getList(
          filter:
              'start_date = "$startDateString" && household_id = "$householdId"',
        );

    if (response.items.isEmpty) {
      return null;
    }

    return MealPlan.fromJson(response.items.first.data);
  }

  Future<Map<String, int>> countPlannedMealsByType() async {
    // Fetch all 7 day‑records for this mealPlanId and userId
    final records = await pb
        .collection('mealPlanDaySelections')
        .getList(
          filter:
              'meal_plan_id = "$mealPlanId" && household_id = "$householdId"',
        );

    // Initialize counters for each meal type
    final counts = <String, int>{'breakfast': 0, 'lunch': 0, 'dinner': 0};

    // Increment the counter for each meal if it's planned
    for (final rec in records.items) {
      if (rec.getBoolValue('breakfast')) {
        counts['breakfast'] = counts['breakfast']! + 1;
      }
      if (rec.getBoolValue('lunch')) {
        counts['lunch'] = counts['lunch']! + 1;
      }
      if (rec.getBoolValue('dinner')) {
        counts['dinner'] = counts['dinner']! + 1;
      }
    }

    return counts;
  }
}

String makeIdListFilter(List<String> ids) {
  if (ids.isEmpty) return '';
  return ids.map((id) => 'id = "$id"').join(' || ');
}
