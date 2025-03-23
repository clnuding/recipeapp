import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:recipeapp/api/user.dart';
import 'package:recipeapp/utils/pocketbase.dart';

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
    pb ??= PocketBase('http://127.0.0.1:8090');
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
      appBar: AppBar(title: Text('Account')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child:
            _user == null
                ? Center(child: CircularProgressIndicator())
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileSection(),
                    SizedBox(height: 20),
                    _buildSettingsSection(),
                    SizedBox(height: 20),
                    _buildLogoutButton(),
                  ],
                ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(_user!.avatarUrl.toString()),
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _user!.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                _user!.email,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Change Password'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notification Preferences'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _logout,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade400,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        ),
        child: Text(
          'Logout',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    );
  }
}
