import 'dart:io';
import 'package:excel/excel.dart';
import 'package:pocketbase/pocketbase.dart';

Future<void> main() async {
  final pb = PocketBase('https://pocketbase.accelizen.com');

  // ✅ Replace with your real credentials


  final file = File('/Users/clemencenuding/Dropbox/IngredientsUpload.xlsx');
  final bytes = await file.readAsBytes();
  final excel = Excel.decodeBytes(bytes);

  final sheet = excel.tables[excel.tables.keys.first];
  if (sheet == null) {
    print('❌ Could not find any sheet in Excel file.');
    return;
  }

  // Get headers
  final headers = sheet.rows.first.map((cell) => cell?.value.toString().trim()).toList();

  for (int i = 1; i < sheet.rows.length; i++) {
    final row = sheet.rows[i];
    final Map<String, String?> record = {};

    for (int j = 0; j < headers.length; j++) {
      final header = headers[j];
      final value = row[j]?.value?.toString().trim();
      if (header != null && value != null && value.isNotEmpty) {
        record[header] = value;
      }
    }

    try {
      await pb.collection('ingredients').create(body: {
        'name_en': record['name_en'] ?? '',
        'name_de': record['name_de'] ?? '',
        'category_id': record['category_id']?.trim(),
        'standard_measurement_id': record['standard_measurement_id']?.trim(),
      });
      print('✅ Inserted: ${record['name_en']}');
    } catch (e) {
      print('❌ Failed to insert ${record['name_en']}: $e');
    }
  }

  print('✅ All done!');
}
