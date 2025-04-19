import 'package:recipeapp/models/recipeingredients.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:recipeapp/api/pb_client.dart';

Future<RecordModel> createRecipeingredient(
  Recipeingredients recipeingredient,
) async {
  Map<String, dynamic> recipeingredientJson = recipeingredient.toJson();
  recipeingredientJson.remove("id");
  return await pb
      .collection('recipeIngredients')
      .create(body: recipeingredientJson);
}

Future<List<Recipeingredients>> fetchRecipeIngredients() async {
  List<RecordModel> records =
      await pb.collection('recipeIngredients').getFullList();
  List<Recipeingredients> recipeingredients =
      records
          .map((record) => Recipeingredients.fromJson(record.toJson()))
          .toList();

  return recipeingredients;
}

Future<List<Recipeingredients>> fetchRecipeIngredientsByRecipeId(
  String recipeId,
) async {
  final records = await pb
      .collection('recipeIngredients')
      .getFullList(
        filter: 'recipe_id="$recipeId"',
        expand: 'ingredient_id,measurement_id',
      );

  print("✅ Received ${records.length} recipeIngredients");
  return records
      .map((record) => Recipeingredients.fromJson(record.toJson()))
      .toList();
}

Future<RecordModel> updateRecipeIngredient(
  Recipeingredients recipeingredients,
) async {
  Map<String, dynamic> json = recipeingredients.toJson();
  json.remove("id");
  return await pb
      .collection('recipeIngredients')
      .update(recipeingredients.id, body: json);
}

Future<void> deleteRecipeIngredient(String id) async {
  await pb.collection('recipeIngredients').delete(id);
}

// void main() async {
//   Recipe test = Recipe(
//     id: "21qs06713lynj5w",
//     title: "test Create Updated",
//     creatorId: "nl9sx3r489d383f",
//     description: "test Create",
//     thumbnailUrl: "test Create",
//     category: "test",
//     sourceUrl: "test",
//     prepTime: 55,
//     cookingTime: 25,
//     servings: 2,
//     nutritionAutoCalculated: true,
//   );

//   await deleteRecipe(test.id);
//   // List<Recipe> recipes = await fetchRecipes();
//   // print(recipes.map((recipe) => recipe.toJson()).toList());
// }
