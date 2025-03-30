class Recipe {
  final String id;
  final String title;
  final String creatorId;
  final String? description;
  final String? thumbnailUrl;
  final String? sourceUrl;
  final int? prepTime;
  final int? cookingTime;
  final int? servings;
  final bool nutritionAutoCalculated;

  Recipe({
    required this.id,
    required this.title,
    required this.creatorId,
    this.description,
    this.thumbnailUrl,
    this.sourceUrl,
    this.prepTime,
    this.cookingTime,
    this.servings,
    this.nutritionAutoCalculated = false,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      creatorId: json['creator_id'],
      description: json['description'],
      thumbnailUrl: json['thumbnail_url'],
      sourceUrl: json['source_url'],
      prepTime: json['prep_time_minutes'],
      cookingTime: json['cook_time_minutes'],
      servings: json['servings'],
      nutritionAutoCalculated: json['nutrition_auto_calculated'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'creator_id': creatorId,
      'description': description,
      'thumbnail_url': thumbnailUrl,
      'source_url': sourceUrl,
      'prep_time': prepTime,
      'cooking_time': cookingTime,
      'servings': servings,
      'nutrition_auto_calculated': nutritionAutoCalculated,
    };
  }
}
