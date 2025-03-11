import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:recipeapp/base/theme.dart'; // Provides RecipeAppTheme

// Global PocketBase client.
final pb = PocketBase('http://127.0.0.1:8090');

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the form fields.
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _portionsController = TextEditingController();
  final _imageUrlController = TextEditingController();

  bool _isLoading = false;

  Future<void> _createRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Debug print to verify authStore status.
    print('Auth store is valid: ${pb.authStore.isValid}');
    print('Auth store model: ${pb.authStore.model}');

    // Retrieve the current signed-in user's id.
    final userId = pb.authStore.model?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not signed in")),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final String name = _nameController.text.trim();
    final String description = _descriptionController.text.trim();
    final int? portions = int.tryParse(_portionsController.text.trim());
    final String imageUrl = _imageUrlController.text.trim();

    // Include user_id in the body.
    final Map<String, dynamic> body = {
      'user_id': userId,
      'name': name,
      'description': description,
      'portions': portions,
      'image': imageUrl,
    };

    try {
      final record = await pb.collection('user_recipes').create(body: body);
      print('Recipe created successfully: ${record.id}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Recipe created successfully!")),
      );
      // Navigate back to the recipe page.
      Navigator.pop(context);
    } catch (e) {
      print('Error creating recipe: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error creating recipe: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _portionsController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // We don't use an AppBar, so we'll overlay the "X" button and arrow on the Stack.
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image.
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1625631979614-7ab4aa53d600?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Apply blur effect.
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0),
            ),
          ),
          // "X" button at the top-right.
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, size: 30, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          // The form container.
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(24),
                constraints: const BoxConstraints(maxWidth: 570),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 4,
                      color: Color(0x33000000),
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Add New Recipe',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      // Recipe Name Field.
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Recipe Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a recipe name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Description Field.
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Portions Field.
                      TextFormField(
                        controller: _portionsController,
                        decoration: const InputDecoration(
                          labelText: 'Portions',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the number of portions';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Image URL Field.
                      TextFormField(
                        controller: _imageUrlController,
                        decoration: const InputDecoration(
                          labelText: 'Image URL',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an image URL';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _createRecipe,
                                child: const Text('Create'),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Positioned arrow at the bottom-right with navigation to ingredient page.
          Positioned(
            bottom: 20,
            right: 20,
            child: InkWell(
              onTap: () {
                // Navigate to the AddIngredientPage.
                // Ensure that the recipe is created first so that you have a valid recipe id.
                Navigator.pushNamed(
                  context,
                  '/addIngredient',
                  arguments: {
                    'recipeId': _nameController.text.trim().isEmpty
                        ? 'dummy_recipe_id'
                        : _nameController.text.trim(),
                  },
                );
              },
              child: const Icon(
                Icons.arrow_forward,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
