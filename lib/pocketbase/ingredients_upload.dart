// import 'package:pocketbase/pocketbase.dart';

// Future<void> main() async {
//   final pb = PocketBase('http://127.0.0.1:8090');

//   // Ingredients data extracted from the Excel file
//   final ingredients = [
//     { "name_en": "Apple", "name_de": "Apfel", "ingredients_categories_master_id": "9g36w40h850fxj8", "measurement_master_id": "lfoli11jn2cyzj9" },
//     { "name_en": "Banana", "name_de": "Banane", "ingredients_categories_master_id": "9g36w40h850fxj8", "measurement_master_id": "lfoli11jn2cyzj9" },
//     { "name_en": "Lemon", "name_de": "Zitrone", "ingredients_categories_master_id": "9g36w40h850fxj8", "measurement_master_id": "lfoli11jn2cyzj9" },
//     { "name_en": "Orange", "name_de": "Orange", "ingredients_categories_master_id": "9g36w40h850fxj8", "measurement_master_id": "lfoli11jn2cyzj9" },
//     { "name_en": "Strawberry", "name_de": "Erdbeere", "ingredients_categories_master_id": "9g36w40h850fxj8", "measurement_master_id": "lfoli11jn2cyzj9" },
//     { "name_en": "Grapes", "name_de": "Trauben", "ingredients_categories_master_id": "9g36w40h850fxj8", "measurement_master_id": "lfoli11jn2cyzj9" },
//     { "name_en": "Blueberry", "name_de": "Blaubeere", "ingredients_categories_master_id": "9g36w40h850fxj8", "measurement_master_id": "lfoli11jn2cyzj9" },
//     { "name_en": "Pineapple", "name_de": "Ananas", "ingredients_categories_master_id": "9g36w40h850fxj8", "measurement_master_id": "lfoli11jn2cyzj9" }
//     // Additional ingredients extracted from the Excel file
//   ];

//   for (final ingredient in ingredients) {
//     try {
//       final record = await pb.collection('ingredients_master').create(body: ingredient);
//       print('Added: $record');
//     } catch (e) {
//       print('Error adding: $ingredient, Error: $e');
//     }
//   }
// }



import 'dart:io';
import 'package:excel/excel.dart';
import 'package:pocketbase/pocketbase.dart';

Future<void> main() async {
  final pb = PocketBase('http://127.0.0.1:8090');
  final file = File('/Users/clemencenuding/Dropbox/IngredientsUpload.xlsx'); // Update the path
  final bytes = file.readAsBytesSync();
  final excel = Excel.decodeBytes(bytes);

  // Access the sheet
  final sheet = excel.tables['ingredients'];
  if (sheet == null) {
    print('Sheet "ingredients" not found.');
    return;
  }

  // Iterate over rows (skip header row)
  for (var i = 1; i < sheet.rows.length; i++) {
    var row = sheet.rows[i];
    
    final nameEn = row[0]?.value?.toString() ?? '';
    final nameDe = row[1]?.value?.toString() ?? '';
    final categoryId = row[2]?.value?.toString() ?? '';
    final measurementId = row[3]?.value?.toString() ?? '';

    if (nameEn.isEmpty || nameDe.isEmpty || categoryId.isEmpty || measurementId.isEmpty) {
      print('Skipping row $i due to missing values.');
      continue;
    }

    final body = {
      "name_en": nameEn,
      "name_de": nameDe,
      "ingredients_categories_master_id": categoryId,
      "measurement_master_id": measurementId
    };

    try {
      final record = await pb.collection('ingredients_master').create(body: body);
      print('Added: $record');
    } catch (e) {
      print('Error adding row $i: $e');
    }
  }
}
