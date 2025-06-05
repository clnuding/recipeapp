import 'dart:math';
import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:recipeapp/api/pb_client.dart';
// import 'package:recipeapp/api/shopping_list.dart';
import 'package:recipeapp/api/utils.dart';
import 'package:recipeapp/models/meal.dart';
import 'package:recipeapp/models/tags.dart';

// ----------------------------------------------------------
// Meal Plan Service
// ----------------------------------------------------------

// Service wrapper for everything related to meal planning.
// Holds all the functins and variables related to meal planning
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

  // ----------------------------------------------------------
  // Create meal plan
  // ----------------------------------------------------------
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
    // set internal variables to track meal plan
    // in every step of the planning process
    this.mealPlanId = mealPlanId;
    this.startDateString = startDateString;
    this.startDate = startDate;
  }

  // ----------------------------------------------------------
  // Selection of meals (breakfast, lunch, dinner)
  // ----------------------------------------------------------
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
    print("existingId: $existingId");
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
    print("Saved meals per day selection for mealplan $mealPlanId");
    await batch.send();
  }

  // ----------------------------------------------------------
  // Selection of recipes (swipeing)
  // ----------------------------------------------------------
  // Inserts a recipe selection (accepted or rejected) for the given user.
  // The selection process is done by swiping recipes from the list of all recipes.
  Future<void> insertRecipeSelection(List<String> recipeIds) async {
    final existingId = await findExistingId(
      collectionName: 'recipeSelections',
      filters: {'meal_plan_id': mealPlanId, 'user_id': userId},
    );

    if (existingId != null) {
      await pb
          .collection('recipeSelections')
          .update(existingId, body: {'recipe_ids': recipeIds});
    } else {
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

  // ----------------------------------------------------------
  // Check and mark completion
  // ----------------------------------------------------------
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

  // ----------------------------------------------------------
  // Finalize meal planning
  // ----------------------------------------------------------
  // Check if all users have completed selections and finalize the meal plan
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
      print("selections: $selections");
      userAcceptedRecipes[userId] = List<String>.from(
        selections.items.first.data['recipe_ids'],
      );
    }

    // 3) Build the set of all selected recipe IDs (union) and the common set (intersection)
    Set<String> userSelectedRecipes =
        userAcceptedRecipes.values.expand((list) => list).toSet();

    print("userAcceptedRecipes: $userAcceptedRecipes");
    print("userSelectedRecipes: $userSelectedRecipes");

    // Compute intersection (start with first user's list, then intersect with each subsequent)
    Set<String> commonRecipes =
        userAcceptedRecipes.values.isNotEmpty
            ? userAcceptedRecipes.values.first.toSet()
            : <String>{};
    for (var otherList in userAcceptedRecipes.values.skip(1)) {
      commonRecipes = commonRecipes.intersection(otherList.toSet());
    }

    final Set<String> unionRecipes = Set.from(userSelectedRecipes);

    // Count how many breakfasts and dinners (we ignore lunches, since lunches = prior dinner)
    final Map<String, int> neededByType = await countPlannedMealsByType();
    final int neededBreakfastCount = neededByType['breakfast']!;
    final int neededDinnerCount = neededByType['dinner']!;

    // We now need to separate “breakfast” vs. “main‐course” recipes.
    // We assume each Recipe record has a boolean field 'isBreakfast'.
    // So we will fetch ALL of unionRecipes in one batch, look at isBreakfast,
    // and then split them into two pools:
    //  - breakfastPool (all unionRecipes where isBreakfast == true)
    //  - mainPool      (all unionRecipes where isBreakfast == false)
    //
    // We’ll do the same for commonRecipes (to see which common ones are breakfasts/main).
    //
    // In PB’s Rest API, we can get a batch by filtering “id = X || id = Y || …”,
    // so let’s build that filter string.

    String makeIdListFilter(List<String> ids) {
      if (ids.isEmpty) return '';
      return ids.map((id) => 'id = "$id"').join(' || ');
    }

    // Build “OR” filter for all unionRecipes
    final unionFilter = makeIdListFilter(unionRecipes.toList());
    final unionResp = await pb
        .collection('recipes')
        .getList(filter: unionFilter);

    // Build “OR” filter for all commonRecipes
    final commonFilter = makeIdListFilter(commonRecipes.toList());
    final commonResp =
        commonRecipes.isEmpty
            ? null
            : await pb.collection('recipes').getList(filter: commonFilter);

    // Now loop through unionResp.items and commonResp (if non‐null) to classify by isBreakfast.
    final Set<String> unionBreakfastIds = {};
    final Set<String> unionMainIds = {};
    for (var item in unionResp.items) {
      final isBreakfast = item.data['isBreakfast'] == true;
      if (isBreakfast) {
        unionBreakfastIds.add(item.id);
      } else {
        unionMainIds.add(item.id);
      }
    }
    final Set<String> commonBreakfastIds = {};
    final Set<String> commonMainIds = {};
    if (commonResp != null) {
      for (var item in commonResp.items) {
        final isBreakfast = item.data['isBreakfast'] == true;
        if (isBreakfast) {
          commonBreakfastIds.add(item.id);
        } else {
          commonMainIds.add(item.id);
        }
      }
    }

    // Now split into:
    //    a) breakfastCommon   = intersection ∩ breakfast
    //    b) breakfastFillers  = (union - intersection) ∩ breakfast
    //    c) mainCommon        = intersection ∩ main
    //    d) mainFillers       = (union - intersection) ∩ main
    // Build lists for common recipes (selected by all household users
    // and filler recipes (only selected by e.g. a single user)
    final Set<String> breakfastCommon = commonRecipes.intersection(
      commonBreakfastIds,
    );
    final Set<String> breakfastFillers = (unionRecipes.difference(
      commonRecipes,
    )).intersection(unionBreakfastIds);

    final Set<String> mainCommon = commonRecipes.intersection(commonMainIds);
    final Set<String> mainFillers = (unionRecipes.difference(
      commonRecipes,
    )).intersection(unionMainIds);

    // SELECT BREAKFAST
    // Build two lists: selectedBreakfasts and selectedMains. We take from “common” first,
    // then from “fillers” if needed. Then shuffle each list.
    final List<String> selectedBreakfasts = [];
    // a) take from breakfastCommon up to neededBreakfastCount
    {
      final commonList = breakfastCommon.toList();
      for (int i = 0; i < neededBreakfastCount && i < commonList.length; i++) {
        selectedBreakfasts.add(commonList[i]);
      }
      // if we still need more, take from breakfastFillers
      final int stillNeed = neededBreakfastCount - selectedBreakfasts.length;
      if (stillNeed > 0) {
        final fillerList = breakfastFillers.toList();
        for (int i = 0; i < stillNeed && i < fillerList.length; i++) {
          selectedBreakfasts.add(fillerList[i]);
        }
      }
    }
    // shuffle
    selectedBreakfasts.shuffle(Random());

    // SELECT MAINS
    final List<String> selectedMains = [];
    // a) take from mainCommon up to neededDinnerCount
    {
      final commonList = mainCommon.toList();
      for (int i = 0; i < neededDinnerCount && i < commonList.length; i++) {
        selectedMains.add(commonList[i]);
      }
      // if we still need more, take from mainFillers
      final int stillNeed = neededDinnerCount - selectedMains.length;
      if (stillNeed > 0) {
        final fillerList = mainFillers.toList();
        for (int i = 0; i < stillNeed && i < fillerList.length; i++) {
          selectedMains.add(fillerList[i]);
        }
      }
    }
    // shuffle
    selectedMains.shuffle(Random());

    print(
      'selectedBreakfasts: ${selectedBreakfasts}, selectedMains: ${selectedMains}',
    );

    // Finally, create mealPlanRecipes in one batch. We will loop over the next 7 days (0..6):
    //    - If selectedBreakfasts still has an element, pop it and create a breakfast entry for that day.
    //    - If prevDinnerRecipeId != null, create a “lunch” entry using prevDinnerRecipeId for this day.
    //    - Pop the next dinner from selectedMains and create a dinner entry. Then assign it to prevDinnerRecipeId.

    final batch = pb.createBatch();
    String? prevDinnerRecipeId;
    int breakfastIndex = 0;
    int dinnerIndex = 0;

    for (int dayOffset = 0; dayOffset < 7; dayOffset++) {
      // Compute ISO date for this day
      final date = startDate.add(Duration(days: dayOffset)).toIso8601String();

      // 8.1) Breakfast (if still available)
      if (breakfastIndex < selectedBreakfasts.length) {
        final breakfastRecipeId = selectedBreakfasts[breakfastIndex++];
        batch
            .collection('mealPlanRecipes')
            .create(
              body: {
                'household_id': householdId,
                'meal_plan_id': mealPlanId,
                'date': date,
                'meal_type': 'breakfast',
                'recipe_id': breakfastRecipeId,
                'servings': await getHouseholdSize(householdId),
                'completed': false,
              },
            );
      }

      // 8.2) Lunch from prevDinner (skip if dayOffset == 0 or prevDinnerRecipeId == null)
      if (prevDinnerRecipeId != null) {
        batch
            .collection('mealPlanRecipes')
            .create(
              body: {
                'household_id': householdId,
                'meal_plan_id': mealPlanId,
                'date': date,
                'meal_type': 'lunch',
                'recipe_id': prevDinnerRecipeId,
                'servings': await getHouseholdSize(householdId),
                'completed': false,
              },
            );
      }

      // 8.3) Dinner (if still available)
      if (dinnerIndex < selectedMains.length) {
        final dinnerRecipeId = selectedMains[dinnerIndex++];
        batch
            .collection('mealPlanRecipes')
            .create(
              body: {
                'household_id': householdId,
                'meal_plan_id': mealPlanId,
                'date': date,
                'meal_type': 'dinner',
                'recipe_id': dinnerRecipeId,
                'servings': await getHouseholdSize(householdId),
                'completed': false,
              },
            );
        // Store it so the *next* iteration (dayOffset + 1) can assign it as lunch
        prevDinnerRecipeId = dinnerRecipeId;
      } else {
        // If we ran out of mains, reset prevDinnerRecipeId to null (no future lunch)
        prevDinnerRecipeId = null;
      }
    }

    // 9) Send the batch
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
