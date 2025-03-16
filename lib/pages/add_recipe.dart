
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:recipeapp/base/theme.dart'; // Provides RecipeAppTheme

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _portionsController = TextEditingController();

  File? _image; // Store selected image
  String? _selectedRecipeType; // Store selected recipe type

  // Test data for recipe types
  final List<String> _recipeTypes = [
    'Side Dish',
    'Main Course',
    'Dessert',
    'Snack',
    'Dip/Spread',
  ];

  // ✅ Pick image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // ✅ Show dialog to choose image source
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
    final Color backgroundColor = theme.alternateColor; // ✅ Matches input fields

    return Scaffold(
      backgroundColor: Colors.white, // ✅ Full-screen white background
      body: SafeArea(
        child: Column(
          children: [
            // ✅ Form Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Title
                    Center(
                      child: Text(
                        'Step 1: Add Recipe',
                        textAlign: TextAlign.center,
                        style: theme.title1.copyWith(color: theme.primaryText),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ✅ Recipe Name Field
                    _buildInputField(
                      controller: _nameController,
                      label: "Recipe Name",
                      theme: theme,
                    ),
                    const SizedBox(height: 16),

                    // ✅ Portions Field
                    _buildInputField(
                      controller: _portionsController,
                      label: "Portions",
                      theme: theme,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    // ✅ Recipe Type Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                      decoration: BoxDecoration(
                        color: backgroundColor, // ✅ Matches input fields
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedRecipeType,
                          hint: Text(
                            "Select Recipe Type",
                            style: TextStyle(color: theme.primaryText.withOpacity(0.6)),
                          ),
                          icon: Icon(Icons.arrow_drop_down, color: theme.primaryText),
                          isExpanded: true,
                          dropdownColor: backgroundColor, // ✅ Consistent color
                          style: TextStyle(color: theme.primaryText),
                          items: _recipeTypes.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedRecipeType = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ✅ Picture Upload (Optional)
                    GestureDetector(
                      onTap: _showImageSourceDialog,
                      child: Container(
                        height: 100, // ✅ Reduced height
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: backgroundColor, // ✅ Matches input fields
                          borderRadius: BorderRadius.circular(7), // ✅ Rounded corners
                        ),
                        child: _image == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo, color: theme.primaryText.withOpacity(0.6), size: 40),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Add Picture (Optional)",
                                    style: TextStyle(color: theme.primaryText.withOpacity(0.6)),
                                  ),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ✅ Description Field (Optional)
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

            // ✅ Styled Bottom Bar (Consistent Backgrounds & Sizes)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // ✅ Close Button (Left)
                  _buildSquareIconButton(theme, Icons.close, () => Navigator.pop(context)),

                  const SizedBox(width: 8), // ✅ Spacing

                  // ✅ Progress Bar (Now matches icon height)
                  Expanded(
                    child: Container(
                      height: 55, // ✅ Matches icon backgrounds
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: backgroundColor, // ✅ Background matches input fields
                        borderRadius: BorderRadius.circular(7),
                      ),
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

                  const SizedBox(width: 8), // ✅ Spacing

                  // ✅ Navigation Arrow (Right)
                  _buildSquareIconButton(theme, Icons.arrow_forward, () => Navigator.pushNamed(context, '/addIngredient')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ **Reusable Input Field Builder**
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
        fillColor: theme.alternateColor, // ✅ Themed background
        border: InputBorder.none, // ✅ No border
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7), // ✅ Rounded corners
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7), // ✅ Rounded corners
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  /// ✅ **Progress Circle**
  Widget _buildProgressCircle(RecipeAppTheme theme, bool isActive) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: isActive ? theme.primaryColor : Colors.transparent, // ✅ Active fills color
        border: Border.all(color: theme.primaryColor, width: 2), // ✅ Outline for inactive
        borderRadius: BorderRadius.circular(7), // ✅ Matches UI
      ),
    );
  }

  /// ✅ **Progress Line Between Circles**
  Widget _buildProgressLine(RecipeAppTheme theme) {
    return Container(
      width: 20,
      height: 3,
      color: theme.primaryColor, // ✅ Consistent accent color
    );
  }

  /// ✅ **Reusable Square Icon Button**
  Widget _buildSquareIconButton(RecipeAppTheme theme, IconData icon, VoidCallback onPressed) {
    return Container(
      height: 55,
      width:55,
      decoration: BoxDecoration(
        color: theme.alternateColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: IconButton(
        icon: Icon(icon, color: theme.primaryColor, size: 24),
        onPressed: onPressed,
      ),
    );
  }
}
