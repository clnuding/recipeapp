import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

// Global PocketBase client.
final pb = PocketBase('http://127.0.0.1:8090');

class AddIngredientPage extends StatefulWidget {
  // The recipeId is passed from the Add Recipe screen.
  final String recipeId;
  const AddIngredientPage({Key? key, required this.recipeId}) : super(key: key);

  @override
  State<AddIngredientPage> createState() => _AddIngredientPageState();
}

class _AddIngredientPageState extends State<AddIngredientPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller for the amount field.
  final _amountController = TextEditingController();

  // Selected values for dropdowns.
  String? _selectedIngredientId;
  String? _selectedMeasurementId;

  bool _isLoading = false;

  // Futures to load master data.
  late Future<List<RecordModel>> _ingredientsFuture;
  late Future<List<RecordModel>> _measurementsFuture;

  @override
  void initState() {
    super.initState();
    _ingredientsFuture = pb.collection('ingredients').getFullList();
    _measurementsFuture = pb.collection('measurements').getFullList();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _createUserIngredient() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() {
    _isLoading = true;
  });

  final amount = double.tryParse(_amountController.text.trim());
  if (amount == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please enter a valid amount")),
    );
    setState(() {
      _isLoading = false;
    });
    return;
  }

  // Retrieve the current user id from the auth store.
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

  final body = {
    'user_id': userId,
    'recipe_id': widget.recipeId,
    'ingredient_id': _selectedIngredientId,
    'measurement_id': _selectedMeasurementId,
    'amount': amount,
  };

  try {
    final record = await pb.collection('user_ingredients').create(body: body);
    print('User ingredient created: ${record.id}');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Ingredient added successfully!")),
    );
    Navigator.pop(context);
  } catch (e) {
    print('Error adding ingredient: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error adding ingredient: ${e.toString()}")),
    );
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Stack to display background image, blur, form, and arrow.
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
          // Blur effect.
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withOpacity(0)),
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
          // Form container.
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
                        'Add Ingredient',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      // Dropdown for Ingredient (using "name" field).
                      FutureBuilder<List<RecordModel>>(
                        future: _ingredientsFuture,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }
                          final ingredients = snapshot.data!;
                          return DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Ingredient',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            dropdownColor: Colors.white,
                            style: const TextStyle(color: Colors.black),
                            value: _selectedIngredientId,
                            items: ingredients.map((record) {
                              return DropdownMenuItem<String>(
                                value: record.id,
                                child: Text(record.data['name'] ?? 'Unnamed'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedIngredientId = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select an ingredient';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      // Dropdown for Measurement (using "abbreviation" field).
                      FutureBuilder<List<RecordModel>>(
                        future: _measurementsFuture,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }
                          final measurements = snapshot.data!;
                          return DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Measurement',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            dropdownColor: Colors.white,
                            style: const TextStyle(color: Colors.black),
                            value: _selectedMeasurementId,
                            items: measurements.map((record) {
                              return DropdownMenuItem<String>(
                                value: record.id,
                                child: Text(record.data['abbreviation'] ?? 'N/A'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedMeasurementId = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a measurement';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      // Amount Field.
                      TextFormField(
                        controller: _amountController,
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.black),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the amount';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Enter a valid number';
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
                                onPressed: _createUserIngredient,
                                child: const Text('Add Ingredient'),
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
                // Navigate to the ingredient page.
                Navigator.pushNamed(
                  context,
                  '/addIngredient',
                  arguments: {'recipeId': widget.recipeId},
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
