import 'package:pocketbase/pocketbase.dart';

class User {
  final String name;
  final String email;
  final Uri avatarUrl;
  final bool premium;

  User({
    required this.name,
    required this.email,
    required this.avatarUrl,
    this.premium = false,
  });

  factory User.fromAuthStore(AuthStore authStore, PocketBase pb) {
    return User(
      name: authStore.model!.data['name'],
      email: authStore.model!.data['email'],
      avatarUrl: pb.files.getUrl(
        authStore.model,
        authStore.model!.data['avatar'],
      ),
      premium: authStore.model!.data['premiumUser'],
    );
  }
}
