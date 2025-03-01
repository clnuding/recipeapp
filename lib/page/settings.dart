import 'package:flutter/material.dart';
import 'package:recipeapp/components/switch.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _showRecipesListView = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _showRecipesListView = prefs.getBool('showTotalChaptersRead') ?? false;
    });
  }

  Future<void> _toggleShowListView(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _showRecipesListView = value;
    });
    await prefs.setBool('showListView', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    "Settings".toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Show recipes list view",
                      style: TextStyle(color: Colors.white),
                    ),
                    GlassSwitch(
                      value: _showRecipesListView,
                      onChanged: _toggleShowListView,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<bool> getRecipesViewPreference() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('showListView') ?? false;
}
