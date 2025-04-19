// User model
import 'package:recipeapp/models/tags.dart';

class Recipe {
  final String id;
  final String title;
  final String creatorId;
  final String? householdId;
  final List<Tags> tags;
  final String? description;
  final String? thumbnail; // ✅ Raw filename from PB
  final String? thumbnailUrl; // ✅ Full URL to image
  final String? sourceUrl;
  final int? prepTime;
  final int? cookingTime;
  final int? servings;
  final bool nutritionAutoCalculated;

  Recipe({
    required this.id,
    required this.title,
    required this.creatorId,
    this.householdId,
    this.tags = const [],
    this.description,
    this.thumbnail,
    this.thumbnailUrl,
    this.sourceUrl,
    this.prepTime,
    this.cookingTime,
    this.servings,
    this.nutritionAutoCalculated = false,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final rawTags = json['expand']?['tag_id'] as List<dynamic>?;

    return Recipe(
      id: json['id'],
      title: json['name'],
      creatorId: json['user_id'],
      householdId: json['household_id'],
      tags:
          rawTags == null
              ? <Tags>[]
              : rawTags
                  .map((tag) => Tags.fromJson(tag as Map<String, dynamic>))
                  .toList(),
      description: json['description'],
      thumbnailUrl: json['thumbnail_url'],
      sourceUrl: json['source_url'],
      prepTime: json['prep_time_minutes'],
      cookingTime: json['cook_time_minutes'],
      servings: json['servings'],
      nutritionAutoCalculated: json['nutrition_auto_calculated'] ?? false,
    );
  }

  /// ✅ Used when creating/updating a recipe; excludes `thumbnailUrl` and `thumbnail`
  Map<String, dynamic> toJson() {
    return {
      'name': title,
      'creator_id': creatorId,
      'household_id': householdId,
      'tag_id': tags.map((tag) => tag.id).toList(),
      'description': description,
      'thumbnail_url': thumbnailUrl,
      'source_url': sourceUrl,
      'prep_time_minutes': prepTime,
      'cook_time_minutes': cookingTime,
      'servings': servings,
      'nutrition_auto_calculated': nutritionAutoCalculated,
    };
  }
}
