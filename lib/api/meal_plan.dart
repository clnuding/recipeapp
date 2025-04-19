import 'dart:math';
import 'package:intl/intl.dart';
import 'package:recipeapp/api/pb_client.dart';
import 'package:recipeapp/api/shopping_list.dart';
import 'package:recipeapp/api/utils.dart';

class MealPlannerService {
  late final ShoppingListService _shoppingListService;
  late String mealPlanId;

  MealPlannerService() {
    _shoppingListService = ShoppingListService();
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
    // return mealPlanId;
  }

  // Inserts a meal plan selection for one meal for the given user.
  Future<void> insertMealTimeSelection(
    Map<String, Map<String, int>> selectedMeals,
  ) async {
    final batch = pb.createBatch();
    for (var entry in selectedMeals.entries) {
      final dateStr = entry.key;
      final meals = entry.value; // { "breakfast": state, ... }
      batch
          .collection('mealPlanSelections')
          .create(
            body: {
              'userId': entry.key,
              'mealPlanId': mealPlanId,
              'date': dateStr,
              'breakfast': meals['breakfast'],
              'lunch': meals['lunch'],
              'dinner': meals['dinner'],
              'planned': entry.value['breakfast'] == 0 ? false : true,
            },
          );
    }
    final result = await batch.send();
    print(result);
  }

  // Inserts a recipe selection (accepted or rejected) for the given user.
  Future<void> insertRecipeSelection(
    String userId,
    String mealPlanId,
    String recipeId,
    bool selected,
  ) async {
    // Check if a record already exists
    final existingRecords = await pb
        .collection('recipe_selections')
        .getList(
          filter:
              'userId = "$userId" && recipeId = "$recipeId" && mealPlanId = "$mealPlanId"',
        );

    if (existingRecords.items.isNotEmpty) {
      // Update existing record
      await pb
          .collection('recipe_selections')
          .update(existingRecords.items.first.id, body: {'selected': selected});
    } else {
      // Create new record
      await pb
          .collection('recipe_selections')
          .create(
            body: {
              'userId': userId,
              'mealPlanId': mealPlanId,
              'recipeId': recipeId,
              'selected': selected,
            },
          );
    }
  }

  // Mark a user's selection as completed
  Future<void> markUserSelectionAsCompleted(
    String userId,
    String mealPlanId,
  ) async {
    final participantResponse = await pb
        .collection('meal_plan_participants')
        .getList(filter: 'userId = "$userId" && mealPlanId = "$mealPlanId"');

    if (participantResponse.items.isNotEmpty) {
      await pb
          .collection('meal_plan_participants')
          .update(
            participantResponse.items.first.id,
            body: {'selectionCompleted': true},
          );
    }

    // Check if all users have completed their selections
    await checkAndFinalizeMealPlan(mealPlanId);
  }

  // Check whether all household users have completed their recipe selection.
  Future<bool> checkHouseholdSelectionsCompleted(String mealPlanId) async {
    final participantsResponse = await pb
        .collection('meal_plan_participants')
        .getList(filter: 'mealPlanId = "$mealPlanId"');

    if (participantsResponse.items.isEmpty) return false;

    // Check if all participants have completed their selections
    for (var participant in participantsResponse.items) {
      if (participant.data['selectionCompleted'] != true) {
        return false;
      }
    }

    return true;
  }

  // Check if all users have completed selections and finalize the meal plan if so
  Future<void> checkAndFinalizeMealPlan(String mealPlanId) async {
    final allCompleted = await checkHouseholdSelectionsCompleted(mealPlanId);

    if (allCompleted) {
      // Get the meal plan to get the household ID
      final mealPlanResponse = await pb
          .collection('meal_plans')
          .getOne(mealPlanId);
      final householdId = mealPlanResponse.data['householdId'];

      // Update the meal plan status
      await pb
          .collection('meal_plans')
          .update(mealPlanId, body: {'status': 'finalized'});

      // Generate the final meal plan
      await finalizeMealPlan(mealPlanId, householdId);

      // Generate shopping list
      await _shoppingListService.generateShoppingListFromMealPlan(mealPlanId);
    }
  }

  // Finalizes the meal plan for the household
  Future<void> finalizeMealPlan(String mealPlanId, String householdId) async {
    // Get the meal plan to get start date
    final mealPlanResponse = await pb
        .collection('meal_plans')
        .getOne(mealPlanId);
    final DateTime startDate = DateTime.parse(
      mealPlanResponse.data['startDate'],
    );

    // Retrieve users in this household
    final usersResponse = await pb
        .collection('users')
        .getList(filter: 'householdId = "$householdId"');

    final List<String> userIds = usersResponse.items.map((e) => e.id).toList();

    // Get accepted recipes for each user
    final Map<String, List<String>> userAcceptedRecipes = {};
    for (var userId in userIds) {
      final selectionsResponse = await pb
          .collection('recipe_selections')
          .getList(
            filter:
                'userId = "$userId" && mealPlanId = "$mealPlanId" && selected = true',
          );

      userAcceptedRecipes[userId] =
          selectionsResponse.items
              .map<String>((item) => item.data['recipeId'] as String)
              .toList();
    }

    // Find common recipes (intersection of all users' accepted recipes)
    Set<String> commonRecipes =
        userAcceptedRecipes.values.isNotEmpty
            ? userAcceptedRecipes.values.first.toSet()
            : {};

    for (var recipes in userAcceptedRecipes.values.skip(1)) {
      commonRecipes = commonRecipes.intersection(recipes.toSet());
    }

    // If not enough common recipes, fill with recipes from the union
    final int totalMeals = 7 * 3; // 7 days x 3 meals
    final unionRecipes = userAcceptedRecipes.values.fold<Set<String>>(
      {},
      (previous, element) => previous..addAll(element),
    );

    List<String> finalRecipeCandidates = commonRecipes.toList();
    Random random = Random();

    while (finalRecipeCandidates.length < totalMeals &&
        unionRecipes.isNotEmpty) {
      // Choose a random recipe from the union
      final unionList = unionRecipes.toList();
      if (unionList.isEmpty) break;

      final String candidate = unionList[random.nextInt(unionList.length)];
      if (!finalRecipeCandidates.contains(candidate)) {
        finalRecipeCandidates.add(candidate);
        unionRecipes.remove(candidate);
      }
    }

    // Shuffle to randomize distribution
    finalRecipeCandidates.shuffle(random);

    // Assign recipes to each day and meal type
    final List<String> mealTypes = ['breakfast', 'lunch', 'dinner'];
    for (int dayOffset = 0; dayOffset < 7; dayOffset++) {
      final DateTime day = startDate.add(Duration(days: dayOffset));

      for (var meal in mealTypes) {
        if (finalRecipeCandidates.isEmpty)
          break; // In case we don't have enough recipes

        final String recipeId = finalRecipeCandidates.removeAt(0);
        int servings = await getHouseholdSize(householdId) * 2;

        await pb
            .collection('meal_plan_recipes')
            .create(
              body: {
                'mealPlanId': mealPlanId,
                'date': day.toIso8601String(),
                'mealType': meal,
                'recipeId': recipeId,
                'servings': servings,
                'completed': false,
              },
            );
      }
    }
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
        .getList(filter: 'householdId = "$householdId"');

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
          filter: 'mealPlanId = "$mealPlanId" && date ~ "$dateString"',
          expand: 'recipe',
        );

    return response.items.map((item) => item.data).toList();
  }
}
