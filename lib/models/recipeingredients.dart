class Recipeingredients {
  final String id;
  final String userId;
  final String householdId;
  final String recipeId;
  final String ingredientId;
  final String measurementId;
  final double quantity;

  Recipeingredients({
    required this.id,
    required this.userId,
    required this.householdId,
    required this.recipeId,
    required this.ingredientId,
    required this.measurementId,
    required this.quantity,
  });

  factory Recipeingredients.fromJson(Map<String, dynamic> json) {
    return Recipeingredients(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      householdId: json['household_id'] ?? '',
      recipeId: json['recipe_id'] ?? '',
      ingredientId: json['ingredient_id'] ?? '',
      measurementId: json['measurement_id'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'household_id': householdId,
      'recipe_id': recipeId,
      'ingredient_id': ingredientId,
      'measurement_id': measurementId,
      'quantity': quantity,
    };
  }
}
