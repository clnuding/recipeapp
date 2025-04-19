import 'package:recipeapp/models/ingredient.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:recipeapp/api/pb_client.dart';

// Future<RecordModel> createIngredient(Ingredient ingredient) async {
//   Map<String, dynamic> ingredientJson = ingredient.toJson();
//   ingredientJson.remove("id");
//   return await pb.collection('ingredients').create(body: ingredientJson);
// }

Future<List<Ingredient>> fetchIngredients() async {
  List<RecordModel> records = await pb.collection('ingredients').getFullList();
  return records.map((record) => Ingredient.fromJson(record.toJson())).toList();
}

Future<Ingredient> fetchIngredientById(String id) async {
  RecordModel record = await pb.collection('ingredients').getOne(id);
  return Ingredient.fromJson(record.toJson());
}

// Future<RecordModel> updateIngredient(Ingredient ingredient) async {
//   Map<String, dynamic> json = ingredient.toJson();
//   json.remove("id");
//   return await pb.collection('ingredients').update(ingredient.id, body: json);
// }

// Future<void> deleteIngredient(String id) async {
//   await pb.collection('ingredients').delete(id);
// }
