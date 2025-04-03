import 'package:pocketbase/pocketbase.dart';

void main() async {
final pb = PocketBase('https://pocketbase.accelizen.com');

  // 🔐 Authenticate with superuser credentials
  // 📥 Fetch ingredient categories
  final categories = await pb.collection('measurements').getFullList(
    sort: 'name_en',
    batch: 200,
  );

  for (final cat in categories) {
    final id = cat.id;
    final nameEn = cat.data['name_en'];
    final nameDe = cat.data['name_de'];

    print('ID: $id, EN: $nameEn, DE: $nameDe');
  }
}



