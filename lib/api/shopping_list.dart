import 'package:recipeapp/api/pb_client.dart';
import 'package:recipeapp/models/shopping.dart';

class ShoppingListService {
  // Create a new shopping list for a finalized meal plan
  Future<ShoppingList> createShoppingList(
    String mealPlanId,
    String householdId,
  ) async {
    final response = await pb
        .collection('shopping_lists')
        .create(body: {'mealPlanId': mealPlanId, 'householdId': householdId});

    return ShoppingList.fromJson(response.data);
  }

  // Get a shopping list by meal plan ID
  Future<ShoppingList?> getShoppingListByMealPlanId(String mealPlanId) async {
    try {
      final response = await pb
          .collection('shopping_lists')
          .getList(filter: 'mealPlanId = "$mealPlanId"');

      if (response.items.isEmpty) {
        return null;
      }

      return ShoppingList.fromJson(response.items.first.data);
    } catch (e) {
      print('Error getting shopping list: $e');
      return null;
    }
  }

  // Add an item to the shopping list
  Future<ShoppingListItem> addShoppingListItem({
    required String shoppingListId,
    required String name,
    required String category,
    required double quantity,
    required String unit,
  }) async {
    final response = await pb
        .collection('shopping_list_items')
        .create(
          body: {
            'shoppingListId': shoppingListId,
            'name': name,
            'category': category,
            'quantity': quantity,
            'unit': unit,
            'purchased': false,
          },
        );

    return ShoppingListItem.fromJson(response.data);
  }

  // Get all items for a shopping list
  Future<List<ShoppingListItem>> getShoppingListItems(
    String shoppingListId,
  ) async {
    final response = await pb
        .collection('shopping_list_items')
        .getList(filter: 'shoppingListId = "$shoppingListId"');

    return response.items
        .map((item) => ShoppingListItem.fromJson(item.data))
        .toList();
  }

  // Mark item as purchased
  Future<void> markItemAsPurchased(String itemId, bool purchased) async {
    await pb
        .collection('shopping_list_items')
        .update(itemId, body: {'purchased': purchased});
  }

  // Update item quantity
  Future<void> updateItemQuantity(String itemId, double quantity) async {
    await pb
        .collection('shopping_list_items')
        .update(itemId, body: {'quantity': quantity});
  }

  // Create shopping list items from recipe ingredients
  Future<void> addIngredientsFromRecipe({
    required String shoppingListId,
    required String recipeId,
    required int servings,
  }) async {
    try {
      // Get the recipe
      final recipeResponse = await pb
          .collection('recipes')
          .getOne(recipeId, expand: 'ingredients');

      if (recipeResponse.data['expand'] == null ||
          recipeResponse.data['expand']['ingredients'] == null) {
        return;
      }

      final recipeServings = recipeResponse.data['servings'] ?? 1;
      final multiplier = servings / recipeServings;

      // Process each ingredient
      for (var ingredient in recipeResponse.data['expand']['ingredients']) {
        final name = ingredient['name'];
        final category = ingredient['category'] ?? 'Other';
        final quantity = (ingredient['quantity'] * multiplier).toDouble();
        final unit = ingredient['unit'] ?? '';

        // Check if this ingredient already exists in the shopping list
        final existingItems = await pb
            .collection('shopping_list_items')
            .getList(
              filter:
                  'shoppingListId = "$shoppingListId" AND name = "$name" AND unit = "$unit"',
            );

        if (existingItems.items.isNotEmpty) {
          // Update existing item quantity
          final existingItem = existingItems.items.first;
          final currentQuantity = existingItem.data['quantity'] ?? 0;
          await updateItemQuantity(
            existingItem.id,
            (currentQuantity + quantity).toDouble(),
          );
        } else {
          // Add new item
          await addShoppingListItem(
            shoppingListId: shoppingListId,
            name: name,
            category: category,
            quantity: quantity,
            unit: unit,
          );
        }
      }
    } catch (e) {
      print('Error adding ingredients from recipe: $e');
    }
  }

  // Generate a complete shopping list from all recipes in a meal plan
  Future<ShoppingList?> generateShoppingListFromMealPlan(
    String mealPlanId,
  ) async {
    try {
      // Get the meal plan
      final mealPlanResponse = await pb
          .collection('meal_plans')
          .getOne(mealPlanId);
      final householdId = mealPlanResponse.data['householdId'];

      // Create shopping list
      final shoppingList = await createShoppingList(mealPlanId, householdId);

      // Get all recipes in the meal plan
      final mealPlanRecipesResponse = await pb
          .collection('meal_plan_recipes')
          .getList(filter: 'mealPlanId = "$mealPlanId"');

      // Process each recipe
      for (var mealPlanRecipe in mealPlanRecipesResponse.items) {
        await addIngredientsFromRecipe(
          shoppingListId: shoppingList.id,
          recipeId: mealPlanRecipe.data['recipeId'],
          servings: mealPlanRecipe.data['servings'],
        );
      }

      return shoppingList;
    } catch (e) {
      print('Error generating shopping list: $e');
      return null;
    }
  }

  // Delete a shopping list item
  Future<void> deleteShoppingListItem(String itemId) async {
    await pb.collection('shopping_list_items').delete(itemId);
  }

  // Delete entire shopping list and its items
  Future<void> deleteShoppingList(String shoppingListId) async {
    // First delete all items
    final items = await getShoppingListItems(shoppingListId);
    for (var item in items) {
      await deleteShoppingListItem(item.id);
    }

    // Then delete the shopping list itself
    await pb.collection('shopping_lists').delete(shoppingListId);
  }
}
