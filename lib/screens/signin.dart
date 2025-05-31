import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:recipeapp/api/pb_client.dart';
import 'package:recipeapp/screens/signup.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/utils/google_auth.dart';
import 'package:recipeapp/utils/validation.dart';
import 'package:recipeapp/widgets/atomics/divider.dart';
import 'package:recipeapp/widgets/atomics/link_text.dart';
import 'package:recipeapp/widgets/atomics/primary_btn.dart';
import 'package:recipeapp/widgets/atomics/logo.dart';
import 'package:recipeapp/widgets/atomics/oauth_button.dart';
import 'package:recipeapp/widgets/atomics/text_form_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final _formSignInKey = GlobalKey<FormState>();
  bool rememberPassword = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signIn() async {
    if (!_formSignInKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      // Attempt to sign in with PocketBase.
      final authResponse = await pb
          .collection('users')
          .authWithPassword(email, password);

      // Check if a record was returned.
      final userId = authResponse.record?.id;

      if (userId == null) {
        print('Sign in failed: No record returned.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sign in failed: No record returned.")),
        );
      } else {
        print('Signed in successfully: $userId');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Signed in successfully!")),
        );
        // Navigate to the main screen after sign in.
        Navigator.pushReplacementNamed(context, '/main');
      }
    } catch (e) {
      print('Error signing in: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error signing in: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: SpoonSparkTheme.spacingXXL,
          ),
          child: Form(
            key: _formSignInKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: SpoonSparkTheme.spacingXL),
                // Fable logo (simplified)
                SizedBox(
                  height: 80,
                  child: Logo(color: theme.colorScheme.primary),
                ),
                const SizedBox(height: SpoonSparkTheme.spacingXL),
                Text('Welcome Back', style: theme.textTheme.headlineMedium),

                const SizedBox(height: SpoonSparkTheme.spacingXXL),

                // Email TextField
                CustomTextFormField(
                  fieldController: _emailController,
                  label: 'Email',
                  inputType: TextInputType.emailAddress,
                  validator: validateEmail,
                ),

                const SizedBox(height: SpoonSparkTheme.spacingL),

                CustomTextFormField(
                  fieldController: _passwordController,
                  label: 'Password',
                  validator: validatePassword,
                  isSecret: true,
                ),

                const SizedBox(height: SpoonSparkTheme.spacingS),

                // Forgot password?
                LinkText(text: 'Forgot password?'),

                const SizedBox(height: SpoonSparkTheme.spacingXXL),

                PrimaryButton(text: 'Sign in with Email', onPressed: _signIn),

                const SizedBox(height: SpoonSparkTheme.spacingL),

                HorizontalDivider(middleText: 'or'),

                const SizedBox(height: SpoonSparkTheme.spacingL),

                // OAuth Buttons
                OAuthButton(
                  text: 'Continue with Google',
                  icon: Brands.google,
                  onPressed: signInWithGoogle,
                ),
                const SizedBox(height: SpoonSparkTheme.spacingM),
                OAuthButton(
                  text: 'Continue with Google',
                  icon: Icons.apple,
                  onPressed: signInWithApple,
                ),

                const SizedBox(height: SpoonSparkTheme.spacingL),

                // Log In Link
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (e) => const SignUpScreen()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        'Sign Up',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
