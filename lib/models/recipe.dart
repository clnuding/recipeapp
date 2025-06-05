import 'package:pocketbase/pocketbase.dart';
import 'package:recipeapp/api/pb_client.dart';

class Recipe {
  final String id;
  final String title;
  final String creatorId;
  final String? householdId;
  final List? tagId;
  final String? description;
  final String? thumbnail; // ✅ Raw filename from PB
  final String? thumbnailUrl; // ✅ Full URL to image
  final String? sourceUrl;
  final int? prepTime;
  final int? cookingTime;
  final int? servings;
  final bool nutritionAutoCalculated;
  final bool? weeklyPlanning;
  final int? numberOfMeals;

  Recipe({
    required this.id,
    required this.title,
    required this.creatorId,
    this.householdId,
    this.tagId,
    this.description,
    this.thumbnail,
    this.thumbnailUrl,
    this.sourceUrl,
    this.prepTime,
    this.cookingTime,
    this.servings,
    this.nutritionAutoCalculated = false,
    this.weeklyPlanning,
    this.numberOfMeals,
  });

  /// ✅ Create a Recipe from a PocketBase record
  factory Recipe.fromRecord(RecordModel record) {
    final thumbnailField = record.getStringValue('thumbnail');
    final thumbnailUrl =
        thumbnailField.isNotEmpty
            ? pb.getFileUrl(record, thumbnailField).toString()
            : null;

    return Recipe(
      id: record.id,
      title: record.getStringValue('name'),
      creatorId: record.getStringValue('user_id'),
      householdId: record.getStringValue('household_id'),
      tagId: record.data['tag_id'] as List?,
      description: record.getStringValue('instructions'),
      thumbnail: thumbnailField, // ✅ Save raw filename
      thumbnailUrl: thumbnailUrl, // ✅ Save URL
      sourceUrl: record.getStringValue('source_url'),
      prepTime: record.getIntValue('prep_time_minutes'),
      cookingTime: record.getIntValue('cook_time_minutes'),
      servings: record.getIntValue('servings'),
      nutritionAutoCalculated:
          record.getBoolValue('nutrition_auto_calculated') ?? false,
      weeklyPlanning: record.getBoolValue('weekly_planning'),
      numberOfMeals: record.getIntValue('number_of_meals'),
    );
  }

  /// ✅ Used when creating/updating a recipe; excludes `thumbnailUrl` and `thumbnail`
  Map<String, dynamic> toJson() {
    return {
      'name': title,
      'creator_id': creatorId,
      'household_id': householdId,
      'tag_id': tagId,
      'instructions': description,
      'source_url': sourceUrl,
      'prep_time_minutes': prepTime,
      'cook_time_minutes': cookingTime,
      'servings': servings,
      'nutrition_auto_calculated': nutritionAutoCalculated,
      'weekly_planning': weeklyPlanning,
      'number_of_meals': numberOfMeals,
    };
  }
}
