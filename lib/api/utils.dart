import 'package:recipeapp/api/pb_client.dart';

String createDateTimeString(DateTime dateTime) {
  final newStartDate = DateTime.utc(
    dateTime.year,
    dateTime.month,
    dateTime.day,
  );
  return newStartDate.toIso8601String().replaceFirst('T', ' ');
}

/// Builds a PocketBase‐style filter string from a map of field→value.
String _buildFilter(Map<String, String> filters) {
  return filters.entries.map((e) => '${e.key} = "${e.value}"').join(' && ');
}

/// Tries to find an existing record in [collectionName] matching all [filters].
/// If found, returns its id; otherwise returns null.
Future<String?> findExistingId({
  required String collectionName,
  required Map<String, String> filters,
  int page = 1,
  int perPage = 1,
}) async {
  final filterStr = _buildFilter(filters);
  final resp = await pb
      .collection(collectionName)
      .getList(page: page, perPage: perPage, filter: filterStr);

  if (resp.items.isNotEmpty) {
    return resp.items.first.id;
  }
  return null;
}
