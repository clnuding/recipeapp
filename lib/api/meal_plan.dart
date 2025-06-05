import 'dart:math';
import 'package:intl/intl.dart';
import 'package:recipeapp/api/pb_client.dart';
import 'package:recipeapp/api/utils.dart';
import 'package:recipeapp/models/meal.dart';
import 'package:recipeapp/models/recipe.dart';

// Service responsible for managing meal planning operations including
// creation, recipe selection, finalization, and meal plan completion tracking.
class MealPlannerService {
  late String mealPlanId;
  late DateTime startDate;
  late String startDateString;
  late String householdId;
  late String userId;

  // Initializes the meal planner service with current user context.
  MealPlannerService() {
    userId = pb.authStore.record!.id;
    householdId = pb.authStore.record!.getStringValue('household_id');
  }

  // ============================================================================
  // MEAL PLAN CREATION
  // ============================================================================

  // Creates a new meal plan for the specified household and start date.
  //
  // If a meal plan already exists for the given parameters, it will be reused.
  // Otherwise, creates a new 7-day meal plan with all household members as participants.
  Future<void> createMealPlan(String householdId, DateTime startDate) async {
    final startDateString = createDateTimeString(startDate);

    final existingId = await _findExistingMealPlan(
      householdId,
      startDateString,
    );
    if (existingId != null) {
      _setMealPlanContext(existingId, startDateString, startDate);
      return;
    }

    final mealPlanId = await _createNewMealPlan(householdId, startDate);
    await _addHouseholdParticipants(householdId, mealPlanId);

    _setMealPlanContext(mealPlanId, startDateString, startDate);
    print("Created meal plan with id: $mealPlanId");
  }

  // Finds existing meal plan ID for given household and date.
  Future<String?> _findExistingMealPlan(
    String householdId,
    String startDateString,
  ) async {
    return await findExistingId(
      collectionName: 'mealPlans',
      filters: {'household_id': householdId, 'start_date': startDateString},
    );
  }

  // Creates a new meal plan record in the database.
  Future<String> _createNewMealPlan(
    String householdId,
    DateTime startDate,
  ) async {
    final endDate = startDate.add(const Duration(days: 6));

    final response = await pb
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

    return response.id;
  }

  // Adds all household members as participants in the meal plan.
  Future<void> _addHouseholdParticipants(
    String householdId,
    String mealPlanId,
  ) async {
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
  }

  // Sets the internal context variables for the current meal plan.
  void _setMealPlanContext(
    String mealPlanId,
    String startDateString,
    DateTime startDate,
  ) {
    this.mealPlanId = mealPlanId;
    this.startDateString = startDateString;
    this.startDate = startDate;
  }

  // ============================================================================
  // MEAL SELECTION
  // ============================================================================

  // Saves the user's meal day selections (which meals they want on which days).
  //
  // [selectedMeals] is a map where keys are date strings and values are maps
  // containing meal type selections (breakfast, lunch, dinner with 0/1 values).
  Future<void> insertMealDaySelection(
    Map<String, Map<String, int>> selectedMeals,
  ) async {
    final existingId = await _findExistingDaySelection();
    final batch = pb.createBatch();

    if (existingId != null) {
      _updateExistingDaySelections(batch, existingId, selectedMeals);
    } else {
      _createNewDaySelections(batch, selectedMeals);
    }

    await batch.send();
    print("Saved meal day selections for meal plan $mealPlanId");
  }

  // Finds existing day selection record for current user and meal plan.
  Future<String?> _findExistingDaySelection() async {
    return await findExistingId(
      collectionName: 'mealPlanDaySelections',
      filters: {
        'meal_plan_id': mealPlanId,
        'date': startDateString,
        'user_id': userId,
      },
    );
  }

  // Updates existing day selection records.
  void _updateExistingDaySelections(
    dynamic batch,
    String existingId,
    Map<String, Map<String, int>> selectedMeals,
  ) {
    for (var entry in selectedMeals.entries) {
      final dateStr = entry.key;
      final meals = entry.value;

      batch
          .collection('mealPlanDaySelections')
          .update(
            existingId,
            body: {
              'date': dateStr,
              'breakfast': meals['breakfast'] != 0,
              'lunch': meals['lunch'] != 0,
              'dinner': meals['dinner'] != 0,
            },
          );
    }
  }

  // Creates new day selection records.
  void _createNewDaySelections(
    dynamic batch,
    Map<String, Map<String, int>> selectedMeals,
  ) {
    for (var entry in selectedMeals.entries) {
      final dateStr = entry.key;
      final meals = entry.value;

      batch
          .collection('mealPlanDaySelections')
          .create(
            body: {
              'household_id': householdId,
              'meal_plan_id': mealPlanId,
              'user_id': userId,
              'date': dateStr,
              'breakfast': meals['breakfast'] != 0,
              'lunch': meals['lunch'] != 0,
              'dinner': meals['dinner'] != 0,
            },
          );
    }
  }

  // ============================================================================
  // RECIPE SELECTION
  // ============================================================================

  // Saves the user's recipe selections (accepted recipes from swiping interface).
  Future<void> insertRecipeSelection(List<String> recipeIds) async {
    final existingId = await _findExistingRecipeSelection();

    if (existingId != null) {
      await _updateRecipeSelection(existingId, recipeIds);
    } else {
      await _createRecipeSelection(recipeIds);
    }
  }

  // Finds existing recipe selection for current user and meal plan.
  Future<String?> _findExistingRecipeSelection() async {
    return await findExistingId(
      collectionName: 'recipeSelections',
      filters: {'meal_plan_id': mealPlanId, 'user_id': userId},
    );
  }

  // Updates existing recipe selection.
  Future<void> _updateRecipeSelection(
    String existingId,
    List<String> recipeIds,
  ) async {
    await pb
        .collection('recipeSelections')
        .update(existingId, body: {'recipe_ids': recipeIds});
  }

  // Creates new recipe selection record.
  Future<void> _createRecipeSelection(List<String> recipeIds) async {
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

  // ============================================================================
  // COMPLETION MANAGEMENT
  // ============================================================================

  // Marks the current user's selection as completed and checks if meal plan can be finalized.
  Future<void> markUserSelectionAsCompleted() async {
    await _updateParticipantCompletion();
    await checkAndFinalizeMealPlan();
  }

  // Updates the participant record to mark selection as completed.
  Future<void> _updateParticipantCompletion() async {
    final recordId = await findExistingId(
      collectionName: 'mealPlanParticipants',
      filters: {'meal_plan_id': mealPlanId, 'user_id': userId},
    );

    if (recordId != null) {
      await pb
          .collection('mealPlanParticipants')
          .update(recordId, body: {'selection_completed': true});
    }
  }

  // Checks if all household members have completed their selections.
  Future<bool> checkHouseholdSelectionsCompleted() async {
    final participantsResponse = await pb
        .collection('mealPlanParticipants')
        .getList(filter: 'meal_plan_id = "$mealPlanId"');

    if (participantsResponse.items.isEmpty) return false;

    return participantsResponse.items.every(
      (participant) => participant.data['selection_completed'] == true,
    );
  }

  // Checks if all users completed selections and finalizes the meal plan if ready.
  Future<void> checkAndFinalizeMealPlan() async {
    final allCompleted = await checkHouseholdSelectionsCompleted();

    if (allCompleted) {
      await _updateMealPlanStatus('finalized');
      await finalizeMealPlan();
    }
  }

  // Updates the meal plan status.
  Future<void> _updateMealPlanStatus(String status) async {
    await pb
        .collection('mealPlans')
        .update(mealPlanId, body: {'status': status});
  }

  // ============================================================================
  // MEAL PLAN FINALIZATION
  // ============================================================================

  // Generates the final meal plan by selecting recipes and creating meal plan entries.
  Future<void> finalizeMealPlan() async {
    final userRecipeSelections = await _getUserRecipeSelections();
    final alwaysPlannedRecipes = await _getAlwaysPlannedRecipes();
    final recipeAnalysis = _analyzeRecipeSelections(userRecipeSelections);
    final mealCounts = await countPlannedMealsByType();

    final selectedRecipes = await _selectRecipesForMealPlan(
      recipeAnalysis,
      mealCounts,
      alwaysPlannedRecipes,
    );

    await _createMealPlanEntries(selectedRecipes);
  }

  // Retrieves recipe selections for all household users.
  Future<Map<String, List<String>>> _getUserRecipeSelections() async {
    final usersResponse = await pb
        .collection('users')
        .getList(filter: 'household_id = "$householdId"');

    final userIds = usersResponse.items.map((e) => e.id).toList();
    final Map<String, List<String>> userRecipeSelections = {};

    for (var userId in userIds) {
      final selections = await pb
          .collection('recipeSelections')
          .getList(
            filter: 'user_id = "$userId" && meal_plan_id = "$mealPlanId"',
          );

      if (selections.items.isNotEmpty) {
        userRecipeSelections[userId] = List<String>.from(
          selections.items.first.data['recipe_ids'],
        );
      }
    }

    return userRecipeSelections;
  }

  /// Retrieves recipes that are marked as always planned for the household.
  Future<List<Recipe>> _getAlwaysPlannedRecipes() async {
    final response = await pb
        .collection('recipes')
        .getList(
          filter: 'household_id = "$householdId" && always_plan = true',
          expand: 'tag_id',
        );

    return response.items.map((item) => Recipe.fromJson(item.data)).toList();
  }

  // Analyzes user recipe selections to find common and unique recipes.
  RecipeSelectionAnalysis _analyzeRecipeSelections(
    Map<String, List<String>> userRecipeSelections,
  ) {
    final allSelectedRecipes =
        userRecipeSelections.values.expand((list) => list).toSet();

    Set<String> commonRecipes =
        userRecipeSelections.values.isNotEmpty
            ? userRecipeSelections.values.first.toSet()
            : <String>{};

    for (var otherList in userRecipeSelections.values.skip(1)) {
      commonRecipes = commonRecipes.intersection(otherList.toSet());
    }

    return RecipeSelectionAnalysis(
      allSelected: allSelectedRecipes,
      common: commonRecipes,
    );
  }

  // Selects appropriate recipes for breakfast and main meals based on analysis.
  Future<SelectedRecipes> _selectRecipesForMealPlan(
    RecipeSelectionAnalysis analysis,
    Map<String, int> mealCounts,
    List<Recipe> alwaysPlannedRecipes,
  ) async {
    final recipeCategories = await _categorizeRecipesByType(
      analysis,
      alwaysPlannedRecipes,
    );

    final selectedBreakfasts = _selectMealTypeRecipes(
      recipeCategories.breakfastCommon,
      recipeCategories.breakfastFillers,
      recipeCategories.alwaysPlannedBreakfasts,
      mealCounts['breakfast']!,
    );

    final selectedMains = _selectMealTypeRecipes(
      recipeCategories.mainCommon,
      recipeCategories.mainFillers,
      recipeCategories.alwaysPlannedMains,
      mealCounts['dinner']!,
    );

    return SelectedRecipes(
      breakfasts: selectedBreakfasts,
      mains: selectedMains,
    );
  }

  // Categorizes recipes by type (breakfast vs main) and preference (common vs filler).
  Future<RecipeCategoriesWithFrequency> _categorizeRecipesByType(
    RecipeSelectionAnalysis analysis,
    List<Recipe> alwaysPlannedRecipes,
  ) async {
    final allRecipesData = await _fetchRecipesByIds(
      analysis.allSelected.toList(),
    );
    final commonRecipesData = await _fetchRecipesByIds(
      analysis.common.toList(),
    );

    final categorization = _categorizeRecipes(
      allRecipesData,
      commonRecipesData,
    );

    final alwaysPlannedBreakfasts = <Recipe>[];
    final alwaysPlannedMains = <Recipe>[];

    return RecipeCategories(
      breakfastCommon: analysis.common.intersection(
        categorization.breakfastIds,
      ),
      breakfastFillers: analysis.allSelected
          .difference(analysis.common)
          .intersection(categorization.breakfastIds),
      mainCommon: analysis.common.intersection(categorization.mainIds),
      mainFillers: analysis.allSelected
          .difference(analysis.common)
          .intersection(categorization.mainIds),
    );
  }

  // Fetches recipe data for given recipe IDs.
  Future<List<dynamic>> _fetchRecipesByIds(List<String> recipeIds) async {
    if (recipeIds.isEmpty) return [];

    final filter = recipeIds.map((id) => 'id = "$id"').join(' || ');
    final response = await pb.collection('recipes').getList(filter: filter);
    return response.items;
  }

  // Categorizes recipes into breakfast and main meal types.
  RecipeCategorization _categorizeRecipes(
    List<dynamic> allRecipes,
    List<dynamic> commonRecipes,
  ) {
    final breakfastIds = <String>{};
    final mainIds = <String>{};

    for (var recipe in allRecipes) {
      if (recipe.data['isBreakfast'] == true) {
        breakfastIds.add(recipe.id);
      } else {
        mainIds.add(recipe.id);
      }
    }

    return RecipeCategorization(breakfastIds: breakfastIds, mainIds: mainIds);
  }

  // Selects recipes for a specific meal type, prioritizing common recipes.
  List<String> _selectMealTypeRecipes(
    Set<String> commonRecipes,
    Set<String> fillerRecipes,
    int neededCount,
  ) {
    final selected = <String>[];

    final commonList = commonRecipes.toList();
    final fillerList = fillerRecipes.toList();

    selected.addAll(commonList.take(neededCount));

    final stillNeeded = neededCount - selected.length;
    if (stillNeeded > 0) {
      selected.addAll(fillerList.take(stillNeeded));
    }

    selected.shuffle(Random());
    return selected;
  }

  // Creates meal plan recipe entries for the selected recipes.
  Future<void> _createMealPlanEntries(SelectedRecipes selectedRecipes) async {
    final batch = pb.createBatch();
    final householdSize = await getHouseholdSize(householdId);

    String? previousDinnerRecipeId;
    int breakfastIndex = 0;
    int dinnerIndex = 0;

    for (int dayOffset = 0; dayOffset < 7; dayOffset++) {
      final date = startDate.add(Duration(days: dayOffset)).toIso8601String();

      _addBreakfastEntry(
        batch,
        selectedRecipes.breakfasts,
        breakfastIndex++,
        date,
        householdSize,
      );

      if (previousDinnerRecipeId != null) {
        _addLunchEntry(batch, previousDinnerRecipeId, date, householdSize);
      }

      previousDinnerRecipeId = _addDinnerEntry(
        batch,
        selectedRecipes.mains,
        dinnerIndex++,
        date,
        householdSize,
      );
    }

    await batch.send();
  }

  // Adds breakfast entry to batch if available.
  void _addBreakfastEntry(
    dynamic batch,
    List<String> breakfasts,
    int index,
    String date,
    int servings,
  ) {
    if (index < breakfasts.length) {
      _addMealEntry(batch, breakfasts[index], 'breakfast', date, servings);
    }
  }

  // Adds lunch entry to batch.
  void _addLunchEntry(
    dynamic batch,
    String recipeId,
    String date,
    int servings,
  ) {
    _addMealEntry(batch, recipeId, 'lunch', date, servings);
  }

  // Adds dinner entry to batch if available and returns the recipe ID.
  String? _addDinnerEntry(
    dynamic batch,
    List<String> mains,
    int index,
    String date,
    int servings,
  ) {
    if (index < mains.length) {
      final recipeId = mains[index];
      _addMealEntry(batch, recipeId, 'dinner', date, servings);
      return recipeId;
    }
    return null;
  }

  // Adds a meal entry to the batch.
  void _addMealEntry(
    dynamic batch,
    String recipeId,
    String mealType,
    String date,
    int servings,
  ) {
    batch
        .collection('mealPlanRecipes')
        .create(
          body: {
            'household_id': householdId,
            'meal_plan_id': mealPlanId,
            'date': date,
            'meal_type': mealType,
            'recipe_id': recipeId,
            'servings': servings,
            'completed': false,
          },
        );
  }

  // ============================================================================
  // MEAL COMPLETION TRACKING
  // ============================================================================

  // Marks a meal as completed and checks if the entire meal plan is completed.
  Future<void> markMealAsCompleted(
    String mealPlanRecipeId,
    bool completed,
  ) async {
    await pb
        .collection('meal_plan_recipes')
        .update(mealPlanRecipeId, body: {'completed': completed});

    final mealPlanRecipeResponse = await pb
        .collection('meal_plan_recipes')
        .getOne(mealPlanRecipeId);

    final mealPlanId = mealPlanRecipeResponse.data['mealPlanId'];
    await checkIfMealPlanCompleted(mealPlanId);
  }

  // Checks if all meals in a plan are completed and updates status accordingly.
  Future<void> checkIfMealPlanCompleted(String mealPlanId) async {
    final mealRecipesResponse = await pb
        .collection('meal_plan_recipes')
        .getList(filter: 'mealPlanId = "$mealPlanId"');

    if (mealRecipesResponse.items.isEmpty) return;

    final allCompleted = mealRecipesResponse.items.every(
      (meal) => meal.data['completed'] == true,
    );

    if (allCompleted) {
      await pb
          .collection('meal_plans')
          .update(mealPlanId, body: {'status': 'completed'});
    }
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  // Returns the number of users in the specified household.
  Future<int> getHouseholdSize(String householdId) async {
    final householdResponse = await pb
        .collection('users')
        .getList(filter: 'household_id = "$householdId"');

    return householdResponse.items.length;
  }

  // Retrieves the current week's meal plan for a household.
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

      return response.items.isEmpty ? null : response.items.first.data;
    } catch (e) {
      print('Error getting current meal plan: $e');
      return null;
    }
  }

  // Retrieves all meals for a specific day in a meal plan.
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

  // Deletes a meal plan and returns success status.
  Future<bool> deleteMealPlan(String mealPlanId) async {
    try {
      await pb.collection('mealPlans').delete(mealPlanId);
      return true;
    } catch (e) {
      print('Error deleting meal plan: $e');
      return false;
    }
  }

  // Checks if a meal plan exists for the given start date and household.
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

    return response.items.isEmpty
        ? null
        : MealPlan.fromJson(response.items.first.data);
  }

  // Counts the number of planned meals by type for the current meal plan.
  Future<Map<String, int>> countPlannedMealsByType() async {
    final records = await pb
        .collection('mealPlanDaySelections')
        .getList(
          filter:
              'meal_plan_id = "$mealPlanId" && household_id = "$householdId"',
        );

    final counts = <String, int>{'breakfast': 0, 'lunch': 0, 'dinner': 0};

    for (final record in records.items) {
      if (record.getBoolValue('breakfast'))
        counts['breakfast'] = counts['breakfast']! + 1;
      if (record.getBoolValue('lunch')) counts['lunch'] = counts['lunch']! + 1;
      if (record.getBoolValue('dinner'))
        counts['dinner'] = counts['dinner']! + 1;
    }

    return counts;
  }
}

// ============================================================================
// HELPER FUNCTIONS
// ============================================================================

// Utility function to create ID list filter for PocketBase queries.
String makeIdListFilter(List<String> ids) {
  if (ids.isEmpty) return '';
  return ids.map((id) => 'id = "$id"').join(' || ');
}
