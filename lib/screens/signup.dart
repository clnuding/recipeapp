import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:recipeapp/screens/signin.dart';
import 'package:recipeapp/api/pb_client.dart';
import 'package:recipeapp/utils/google_auth.dart';
import 'package:recipeapp/theme/theme_old.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formSignupKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Fable logo (simplified)
                SvgPicture.asset(
                  'assets/logos/spoonspark_logo.svg',
                  height: 80,
                  colorFilter: ColorFilter.mode(primary, BlendMode.srcIn),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 25),

                // Email TextField
                TextFormField(
                  cursorColor: Colors.black,
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
                      borderSide: const BorderSide(
                        color: Colors.black, // Black border when focused
                        width:
                            1.5, // Optional: make the border slightly thicker
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),

                    // Customize label color when focused
                    floatingLabelStyle: const TextStyle(
                      color: Colors.black, // Black label when floating
                    ),
                    label: const Text('Email'),
                    hintText: 'Enter Email',
                    hintStyle: const TextStyle(color: Colors.black26),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black12, // Default border color
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black12, // Default border color
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Password TextField
                TextFormField(
                  cursorColor: Colors.black,
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
                      borderSide: const BorderSide(
                        color: Colors.black, // Black border when focused
                        width:
                            1.5, // Optional: make the border slightly thicker
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),

                    // Customize label color when focused
                    floatingLabelStyle: const TextStyle(
                      color: Colors.black, // Black label when floating
                    ),
                    label: const Text('Password'),
                    hintText: 'Enter Password',
                    hintStyle: const TextStyle(color: Colors.black26),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black12, // Default border color
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black12, // Default border color
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                // confirm password
                // password
                TextFormField(
                  cursorColor: Colors.black,
                  controller: _confirmPasswordController,
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
                      borderSide: const BorderSide(
                        color: Colors.black, // Black border when focused
                        width:
                            1.5, // Optional: make the border slightly thicker
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),

                    // Customize label color when focused
                    floatingLabelStyle: const TextStyle(
                      color: Colors.black, // Black label when floating
                    ),
                    label: const Text('Confirm Password'),
                    hintText: 'Confirm Password',
                    hintStyle: const TextStyle(color: Colors.black26),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black12, // Default border color
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black12, // Default border color
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Terms Checkbox
                Row(
                  children: [
                    Checkbox(
                      // activeColor: Colors.black,
                      activeColor: primary,
                      value: _acceptedTerms,
                      onChanged: (bool? value) {
                        setState(() {
                          _acceptedTerms = value ?? false;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'I accept Spoonality\'s Terms of Service and Privacy Policy',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Sign Up with Email Button
                ElevatedButton(
                  onPressed: _acceptedTerms ? _createAccount : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: primary,
                    // disabledBackgroundColor: Colors.grey,
                    disabledBackgroundColor: secondary,
                  ),
                  child: const Text(
                    'Sign up with Email',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.7,
                        color: Colors.grey.withValues(alpha: 0.5),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 10,
                      ),
                      child: Text(
                        'or',
                        style: TextStyle(color: Colors.black45),
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
                const SizedBox(height: 16.0),

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
                const SizedBox(height: 16),
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
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(color: Colors.black45),
                      ),
                      const Text(
                        'Log In',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primary,
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
    return OutlinedButton.icon(
      onPressed: () => onPressed(context),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        side: const BorderSide(color: Colors.grey),
      ),
      // icon: Icon(icon, color: Colors.black),
      icon: Brand(icon, size: 20),
      label: Text(text, style: const TextStyle(color: Colors.black)),
    );
  }

  Widget _buildOAuthButtonIcon({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        side: const BorderSide(color: Colors.grey),
      ),
      icon: Icon(icon, color: Colors.black, size: 20),
      label: Text(text, style: const TextStyle(color: Colors.black)),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
