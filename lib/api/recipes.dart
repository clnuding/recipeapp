import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:recipeapp/models/recipe.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:recipeapp/api/pb_client.dart';

Future<RecordModel> createRecipe(Recipe recipe, {File? imageFile}) async {
  final Map<String, dynamic> data = recipe.toJson();

  return await pb
      .collection('recipes')
      .create(
        body: data,
        files:
            imageFile != null
                ? [
                  http.MultipartFile.fromBytes(
                    'thumbnail',
                    await imageFile.readAsBytes(),
                    filename: 'thumbnail.jpg',
                  ),
                ]
                : [],
      );
}

Future<RecordModel> updateRecipe(Recipe recipe, {File? imageFile}) async {
  final Map<String, dynamic> data = recipe.toJson();

  return await pb
      .collection('recipes')
      .update(
        recipe.id,
        body: data,
        files:
            imageFile != null
                ? [
                  http.MultipartFile.fromBytes(
                    'thumbnail',
                    await imageFile.readAsBytes(),
                    filename: 'thumbnail.jpg',
                  ),
                ]
                : [],
      );
}

Future<List<Recipe>> fetchRecipes() async {
  final records = await pb.collection('recipes').getFullList();
  return records.map((r) => Recipe.fromRecord(r)).toList();
}

Future<Recipe> fetchRecipeById(String id) async {
  final record = await pb.collection('recipes').getOne(id);
  return Recipe.fromRecord(record);
}

Future<void> deleteRecipe(String id) async {
  await pb.collection('recipes').delete(id);
}
