import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:recipeapp/api/user.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/utils/pocketbase.dart';
import 'package:recipeapp/widgets/atomics/appbar.dart';
import 'package:recipeapp/widgets/atomics/primary_btn.dart';
import 'package:recipeapp/widgets/atomics/secondary_btn.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountScreen> {
  User? _user;
  PocketBase? pb;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<PocketBase> _initPocketbase() async {
    await dotenv.load(fileName: ".env");
    pb = await getPocketbaseWithSavedStore();
    pb ??= PocketBase('https://pocketbase.accelizen.com');
    return pb!;
  }

  void _fetchUserData() async {
    pb = await _initPocketbase();

    // Sign out from Google
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: dotenv.env['GOOGLE_CLIENT_ID'] ?? '',
    );

    // Ensure the GoogleSignIn instance is initialized
    await googleSignIn.signInSilently();

    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }

    try {
      setState(() {
        _user = User.fromAuthStore(pb!.authStore, pb!);
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _logout() async {
    try {
      pb!.authStore.clear();
      setState(() {
        _user = null;
      });
      Navigator.pushReplacementNamed(context, '/signIn');
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LogoAppbar(showBackButton: false),
      body: Padding(
        padding: const EdgeInsets.all(SpoonSparkTheme.spacing24),
        child:
            _user == null
                ? Center(child: CircularProgressIndicator())
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileSection(),
                    SizedBox(height: SpoonSparkTheme.spacing18),
                    _user!.premium
                        ? SizedBox.shrink()
                        : PrimaryButton(
                          text: "Become a Premium Member",
                          onPressed: () {},
                        ),
                    SizedBox(height: SpoonSparkTheme.spacing18),
                    _buildSettingsSection(),
                    SizedBox(height: SpoonSparkTheme.spacing18),
                    PrimaryButton(text: "Logout", onPressed: _logout),
                    SizedBox(height: SpoonSparkTheme.spacing18),
                    SecondaryButton(text: "Logout", onPressed: () {}),
                  ],
                ),
      ),
    );
  }

  Widget _buildProfileSection() {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(SpoonSparkTheme.spacing12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(_user!.avatarUrl.toString()),
          ),
          SizedBox(width: SpoonSparkTheme.spacing16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_user!.name, style: theme.textTheme.titleLarge),
              SizedBox(height: SpoonSparkTheme.spacing4),
              Text(_user!.email, style: theme.textTheme.titleSmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Settings', style: theme.textTheme.titleMedium),
        SizedBox(height: SpoonSparkTheme.spacing8),
        ListTile(
          leading: Icon(Icons.lock),
          title: Text('Change Password'),
          subtitle: Text('Change your password'),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {},
        ),
        SizedBox(height: SpoonSparkTheme.spacing8),
        ListTile(
          leading: Icon(Icons.notifications),
          title: Text('Notification Preferences'),
          subtitle: Text('Manage notification settings'),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Navigate to notification preferences
          },
        ),
      ],
    );
  }
}
