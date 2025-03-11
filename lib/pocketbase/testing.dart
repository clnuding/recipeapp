//  import 'package:pocketbase/pocketbase.dart';

// final pb = PocketBase('http://127.0.0.1:8090');

// Future<void> fetchAllRecords() async {
//   final result = await pb.collection('ingredients_categories_master').getList(
//     page: 1,
//     perPage: 100, // Adjust perPage to control the number of records fetched
//   );

//   for (var record in result.items) {
//     print(record.toJson()); // Print all columns of each record
//   }
// }


// void main() {
//   fetchAllRecords();
// }


import 'package:pocketbase/pocketbase.dart';

final pb = PocketBase('http://127.0.0.1:8090');

Future<void> fetchAllRecords() async {
  final result = await pb.collection('measurements_master').getList(
    page: 1,
    perPage: 100, // Adjust perPage to control the number of records fetched
  );

  if (result.items.isEmpty) {
    print("No records found.");
    return;
  }

  // Extract column names dynamically
  List<String> columns = result.items.first.toJson().keys.toList();

  // Determine the maximum width for each column for alignment
  Map<String, int> columnWidths = {};
  for (var col in columns) {
    columnWidths[col] = col.length; // Initialize with column name length
  }

  // Update column widths based on actual data
  for (var record in result.items) {
    for (var col in columns) {
      String value = record.toJson()[col]?.toString() ?? "";
      if (value.length > columnWidths[col]!) {
        columnWidths[col] = value.length;
      }
    }
  }

  // Print table header
  String header = columns.map((col) => col.padRight(columnWidths[col]!)).join(" | ");
  print(header);
  print("-" * header.length); // Separator line

  // Print each row
  for (var record in result.items) {
    String row = columns.map((col) => (record.toJson()[col]?.toString() ?? "").padRight(columnWidths[col]!)).join(" | ");
    print(row);
  }
}

void main() {
  fetchAllRecords();
}
