import 'package:recipeapp/models/recipe.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:recipeapp/api/pb_client.dart';

Future<RecordModel> createRecipe(Recipe recipe) async {
  Map<String, dynamic> recipeJson = recipe.toJson();
  recipeJson.remove("id");
  return await pb.collection('recipes').create(body: recipeJson);
}

Future<List<Recipe>> fetchRecipes() async {
  List<RecordModel> records = await pb.collection('recipes').getFullList();
  List<Recipe> recipes =
      records.map((record) => Recipe.fromJson(record.toJson())).toList();

  return recipes;
}

Future<Recipe> fetchRecipeById(String id) async {
  RecordModel record = await pb.collection('recipes').getOne(id);
  return Recipe.fromJson(record.toJson());
}

Future<RecordModel> updateRecipe(Recipe recipe) async {
  Map<String, dynamic> json = recipe.toJson();
  json.remove("id");
  return await pb.collection('recipes').update(recipe.id, body: json);
}

Future<void> deleteRecipe(String id) async {
  await pb.collection('recipes').delete(id);
}
