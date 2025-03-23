import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:recipeapp/base/theme.dart';
import 'package:recipeapp/api/tags.dart';
import 'package:recipeapp/models/tags.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _portionsController = TextEditingController();

  File? _image;
  String? _selectedRecipeType;
  List<String> _mealTypes = [];

  @override
  void initState() {
    super.initState();
    _loadMealTypes();
  }

  Future<void> _loadMealTypes() async {
    try {
      final tags = await fetchTags();
      final mealTags = tags.where((tag) => tag.category == 'meal_type').toList();
      setState(() {
        _mealTypes = mealTags.map((tag) => tag.name).toList();
      });
    } catch (e) {
      print('Failed to load meal types: $e');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  Future<void> _showImageSourceDialog() async {
    final theme = RecipeAppTheme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.primaryBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: theme.primaryText),
              title: Text("Take a Photo", style: TextStyle(color: theme.primaryText)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.image, color: theme.primaryText),
              title: Text("Choose from Gallery", style: TextStyle(color: theme.primaryText)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _portionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = RecipeAppTheme.of(context);
    final Color backgroundColor = theme.alternateColor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text('Step 1: Add Recipe', style: theme.title1.copyWith(color: theme.primaryText)),
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(controller: _nameController, label: "Recipe Name", theme: theme),
                    const SizedBox(height: 16),
                    _buildInputField(controller: _portionsController, label: "Portions", theme: theme, keyboardType: TextInputType.number),
                    const SizedBox(height: 16),

                    // Dropdown from fetched tags
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedRecipeType,
                          hint: Text("Select Recipe Type", style: TextStyle(color: theme.primaryText.withOpacity(0.6))),
                          icon: Icon(Icons.arrow_drop_down, color: theme.primaryText),
                          isExpanded: true,
                          dropdownColor: backgroundColor,
                          style: TextStyle(color: theme.primaryText),
                          items: _mealTypes.map((type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() => _selectedRecipeType = newValue);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    GestureDetector(
                      onTap: _showImageSourceDialog,
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: _image == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo, color: theme.primaryText.withOpacity(0.6), size: 40),
                                  const SizedBox(height: 4),
                                  Text("Add Picture (Optional)", style: TextStyle(color: theme.primaryText.withOpacity(0.6))),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: Image.file(_image!, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      controller: _descriptionController,
                      label: "Description (Optional)",
                      theme: theme,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  _buildSquareIconButton(theme, Icons.close, () => Navigator.pop(context)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(7)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildProgressCircle(theme, true),
                          _buildProgressLine(theme),
                          _buildProgressCircle(theme, false),
                          _buildProgressLine(theme),
                          _buildProgressCircle(theme, false),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildSquareIconButton(theme, Icons.arrow_forward, () => Navigator.pushNamed(context, '/addIngredient')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required RecipeAppTheme theme,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(color: theme.primaryText),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: theme.primaryText.withOpacity(0.6)),
        filled: true,
        fillColor: theme.alternateColor,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildSquareIconButton(RecipeAppTheme theme, IconData icon, VoidCallback onPressed) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(color: theme.alternateColor, borderRadius: BorderRadius.circular(7)),
      child: IconButton(icon: Icon(icon, color: theme.primaryColor, size: 24), onPressed: onPressed),
    );
  }

  Widget _buildProgressCircle(RecipeAppTheme theme, bool isActive) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: isActive ? theme.primaryColor : Colors.transparent,
        border: Border.all(color: theme.primaryColor, width: 2),
        borderRadius: BorderRadius.circular(7),
      ),
    );
  }

  Widget _buildProgressLine(RecipeAppTheme theme) {
    return Container(width: 20, height: 3, color: theme.primaryColor);
  }
}
