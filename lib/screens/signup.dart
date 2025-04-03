import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:recipeapp/screens/signin.dart';
import 'package:recipeapp/api/pb_client.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/utils/google_auth.dart';
import 'package:recipeapp/utils/validation.dart';
import 'package:recipeapp/widgets/atomics/checkbox.dart';
import 'package:recipeapp/widgets/atomics/divider.dart';
import 'package:recipeapp/widgets/atomics/primary_btn.dart';
import 'package:recipeapp/widgets/atomics/logo.dart';
import 'package:recipeapp/widgets/atomics/oauth_button.dart';
import 'package:recipeapp/widgets/atomics/text_form_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formSignupKey = GlobalKey<FormState>();
  bool _acceptedTerms = false;

  // Controllers for the text fields.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _createAccount() async {
    if (!_formSignupKey.currentState!.validate()) return;
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    // Derive a simple username from the email (everything before '@')
    final username = email.split('@')[0];

    final body = {
      "email": email,
      "password": password,
      "passwordConfirm": password,
      "username": username,
    };

    try {
      final record = await pb.collection('users').create(body: body);
      print('User created: $record');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully!")),
      );
      // Navigate to the sign-in page after a successful sign-up.
      Navigator.pushReplacementNamed(context, '/signIn');
    } catch (e) {
      print('Error creating account: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: SpoonSparkTheme.spacing24,
          ),
          child: Form(
            key: _formSignupKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: SpoonSparkTheme.spacing18),
                SizedBox(
                  height: 80,
                  child: Logo(color: theme.colorScheme.primary),
                ),
                const SizedBox(height: SpoonSparkTheme.spacing18),

                Text('Create Account', style: theme.textTheme.headlineMedium),

                const SizedBox(height: SpoonSparkTheme.spacing24),

                // Email TextField
                CustomTextFormField(
                  fieldController: _emailController,
                  label: 'Email',
                  inputType: TextInputType.emailAddress,
                  validator: validateEmail,
                ),

                const SizedBox(height: SpoonSparkTheme.spacing16),

                CustomTextFormField(
                  fieldController: _passwordController,
                  label: 'Password',
                  validator: validatePassword,
                  isSecret: true,
                ),

                const SizedBox(height: SpoonSparkTheme.spacing16),

                CustomTextFormField(
                  fieldController: _confirmPasswordController,
                  label: 'Confirm Password',
                  validator: validatePassword,
                  isSecret: true,
                  hintText: 'Confirm Password',
                ),

                const SizedBox(height: SpoonSparkTheme.spacing4),

                // Terms Checkbox
                CustomCheckBox(
                  value: _acceptedTerms,
                  onChanged: (bool? value) {
                    setState(() {
                      _acceptedTerms = value ?? false;
                    });
                  },
                  label: 'I accept SpoonaSparks Terms of Service',
                ),

                const SizedBox(height: SpoonSparkTheme.spacing8),
                // Sign Up with Email Button
                PrimaryButton(
                  text: 'Sign up with Email',
                  onPressed: _acceptedTerms ? _createAccount : null,
                ),

                const SizedBox(height: SpoonSparkTheme.spacing16),

                HorizontalDivider(middleText: 'or'),

                const SizedBox(height: SpoonSparkTheme.spacing16),

                // OAuth Buttons
                OAuthButton(
                  text: 'Continue with Google',
                  icon: Brands.google,
                  onPressed: signInWithGoogle,
                ),
                const SizedBox(height: SpoonSparkTheme.spacing12),
                OAuthButton(
                  text: 'Continue with Google',
                  icon: Icons.apple,
                  onPressed: signInWithApple,
                ),

                const SizedBox(height: SpoonSparkTheme.spacing16),
                // Log In Link
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (e) => const SignInScreen()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        'Log In',
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
