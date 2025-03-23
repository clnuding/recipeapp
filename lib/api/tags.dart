import 'package:recipeapp/models/tags.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:recipeapp/api/pb_client.dart';

Future<List<Tags>> fetchTags() async {
  List<RecordModel> records = await pb.collection('tags').getFullList();
  List<Tags> tags =
      records.map((record) => Tags.fromJson(record.toJson())).toList();

  return tags;
}

