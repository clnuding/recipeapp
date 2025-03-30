import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:recipeapp/api/pb_client.dart';
import 'package:recipeapp/screens/signup.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/utils/google_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
            horizontal: SpoonSparkTheme.spacing24,
          ),
          child: Form(
            key: _formSignInKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: SpoonSparkTheme.spacing18),
                // Fable logo (simplified)
                SvgPicture.asset(
                  'assets/logos/spoonspark_logo.svg',
                  height: 80,
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: SpoonSparkTheme.spacing18),
                Text('Welcome Back', style: theme.textTheme.headlineMedium),

                const SizedBox(height: SpoonSparkTheme.spacing24),

                // Email TextField
                TextFormField(
                  cursorColor: theme.colorScheme.onSurface,
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(
                      r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    ).hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.colorScheme.onSurface,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(
                        SpoonSparkTheme.radiusMedium,
                      ),
                    ),

                    // Customize label color when focused
                    floatingLabelStyle: TextStyle(
                      color: theme.colorScheme.onSurface,
                    ),
                    label: Text('Email', style: theme.textTheme.bodyMedium),
                    hintText: 'Enter Email',
                    hintStyle: theme.textTheme.bodyMedium,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.colorScheme.tertiary),
                      borderRadius: BorderRadius.circular(
                        SpoonSparkTheme.radiusNormal,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.colorScheme.tertiary),
                      borderRadius: BorderRadius.circular(
                        SpoonSparkTheme.radiusNormal,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: SpoonSparkTheme.spacing16),
                // Password TextField
                TextFormField(
                  cursorColor: theme.colorScheme.onSurface,
                  controller: _passwordController,
                  obscureText: true,
                  obscuringCharacter: '*',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.colorScheme.onSurface,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(
                        SpoonSparkTheme.radiusNormal,
                      ),
                    ),

                    // Customize label color when focused
                    floatingLabelStyle: TextStyle(
                      color: theme.colorScheme.onSurface,
                    ),
                    label: Text('Password', style: theme.textTheme.bodyMedium),
                    hintText: 'Enter Password',
                    hintStyle: theme.textTheme.bodyMedium,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.colorScheme.tertiary),
                      borderRadius: BorderRadius.circular(
                        SpoonSparkTheme.radiusNormal,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color:
                            theme.colorScheme.tertiary, // Default border color
                      ),
                      borderRadius: BorderRadius.circular(
                        SpoonSparkTheme.radiusNormal,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: SpoonSparkTheme.spacing8),
                // Forgot password?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: Text(
                        'Forgot password?',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: SpoonSparkTheme.spacing24),
                // Sign Up with Email Button
                ElevatedButton(
                  onPressed: _signIn,
                  child: Text(
                    'Sign in with Email',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: SpoonSparkTheme.spacing16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.7,
                        color: Colors.grey.withValues(alpha: 0.5),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 10,
                      ),
                      child: Text(
                        'or',
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.7,
                        color: Colors.grey.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SpoonSparkTheme.spacing16),

                // OAuth Buttons
                _buildOAuthButtonBrand(
                  text: 'Continue with Google',
                  icon: Brands.google,
                  onPressed: signInWithGoogle,
                ),
                const SizedBox(height: 12),
                _buildOAuthButtonIcon(
                  text: 'Continue with Apple',
                  icon: Icons.apple,
                  onPressed: () {},
                ),
                const SizedBox(height: SpoonSparkTheme.spacing16),
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

  Widget _buildOAuthButtonBrand({
    required String text,
    required String icon,
    required Future<void> Function(BuildContext) onPressed,
  }) {
    final theme = Theme.of(context);

    return OutlinedButton.icon(
      onPressed: () => onPressed(context),
      icon: Brand(icon, size: 20),
      label: Text(text, style: theme.textTheme.bodyMedium),
    );
  }

  Widget _buildOAuthButtonIcon({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.black, size: 20),
      label: Text(text, style: theme.textTheme.bodyMedium),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
