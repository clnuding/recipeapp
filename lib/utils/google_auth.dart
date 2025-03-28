import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:pocketbase/pocketbase.dart';
//import 'package:recipeapp/screens/signin.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipeapp/api/pb_client.dart';

Future<void> signInWithGoogle(BuildContext context) async {
  // create local authstore to keep logged in user
  // information persistent
  final prefs = await SharedPreferences.getInstance();
  final store = AsyncAuthStore(
    save: (String data) async => prefs.setString('pb_auth', data),
    initial: prefs.getString('pb_auth'),
  );

  try {
    final authData = await pb.collection('users').authWithOAuth2('google', (
      url,
    ) async {
      launchOAuthURL(url);
    });
    store.save(authData.token, authData.record);
    Navigator.pushReplacementNamed(context, '/main');
  } catch (e) {
    print('Error signing in with Google: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error signing in with Google: ${e.toString()}")),
    );
  }
}

// redirect uri launcher for oauth
void launchOAuthURL(Uri url) async {
  try {
    await launchUrl(
      url,
      customTabsOptions: CustomTabsOptions(
        colorSchemes: CustomTabsColorSchemes.defaults(
          toolbarColor: lightColorScheme.surface,
          navigationBarColor: lightColorScheme.surface,
        ),
        shareState: CustomTabsShareState.on,
        urlBarHidingEnabled: true,
        showTitle: true,
      ),
      safariVCOptions: SafariViewControllerOptions(
        preferredBarTintColor: lightColorScheme.surface,
        preferredControlTintColor: lightColorScheme.onSurface,
        barCollapsingEnabled: true,
        entersReaderIfAvailable: false,
        modalPresentationStyle:
            ViewControllerModalPresentationStyle.overFullScreen,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.done,
      ),
    );
  } catch (e) {
    // If opening fails, fallback to WebView or another method
    print("Failed to launch URL: $e");
  }
}
