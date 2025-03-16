import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

const pocketbaseUri = 'http://127.0.0.1:8090/';

// helper to init pocketbase instance with safed auth store
Future<PocketBase?> getPocketbaseWithSavedStore() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final store = AsyncAuthStore(
      save: (String data) async => prefs.setString('pb_auth', data),
      initial: prefs.getString('pb_auth'),
    );
    return PocketBase(pocketbaseUri, authStore: store);
  } catch (e) {
    print('Error initializing auth store: $e');
    return null;
  }
}
