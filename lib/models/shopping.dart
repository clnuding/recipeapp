// ShoppingList model
class ShoppingList {
  final String id;
  final String mealPlanId;
  final String householdId;

  ShoppingList({
    required this.id,
    required this.mealPlanId,
    required this.householdId,
  });

  factory ShoppingList.fromJson(Map<String, dynamic> json) {
    return ShoppingList(
      id: json['id'],
      mealPlanId: json['mealPlanId'],
      householdId: json['householdId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'mealPlanId': mealPlanId, 'householdId': householdId};
  }
}

// ShoppingListItem model
class ShoppingListItem {
  final String id;
  final String shoppingListId;
  final String name;
  final String category;
  final double quantity;
  final String unit;
  final bool purchased;

  ShoppingListItem({
    required this.id,
    required this.shoppingListId,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    this.purchased = false,
  });

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) {
    return ShoppingListItem(
      id: json['id'],
      shoppingListId: json['shoppingListId'],
      name: json['name'],
      category: json['category'],
      quantity: json['quantity'],
      unit: json['unit'],
      purchased: json['purchased'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shoppingListId': shoppingListId,
      'name': name,
      'category': category,
      'quantity': quantity,
      'unit': unit,
      'purchased': purchased,
    };
  }
}
