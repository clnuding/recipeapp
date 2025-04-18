import 'package:recipeapp/models/measurements.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:recipeapp/api/pb_client.dart';

Future<List<Measurements>> fetchMeasurements() async {
  List<RecordModel> records = await pb.collection('measurements').getFullList();
  return records
      .map((record) => Measurements.fromJson(record.toJson()))
      .toList();
}

Future<Measurements> fetchMeasurementsById(String id) async {
  RecordModel record = await pb.collection('measurements').getOne(id);
  return Measurements.fromJson(record.toJson());
}
