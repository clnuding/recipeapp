import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:recipeapp/theme/theme.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _portionsController = TextEditingController();

  File? _image;

  // 🥗 Anlass Dropdown
  String? _selectedRecipeType;
  final List<String> _mealTypes = [
    'Frühstück',
    'Hauptgang',
    'Beilage',
    'Dessert',
    'Snack',
  ];

  // 🍝 Kategorie Dropdown
  String? _selectedRecipeCategory;
  final List<String> _recipeCategories = [
    'Nudeln',
    'Reis',
    'Fleisch/Fisch/Tofu',
    'Kartoffeln',
    'Salate',
    'Eintöpfe/Suppen',
  ];

  // 🍝 Saison Dropdown
  String? _selectedRecipeSeason;
  final List<String> _recipeSeasons = [
    'Frühjahr',
    'Sommer',
    'Herbst',
    'Winter',
    'Ganzjährig',
  ];

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  Future<void> _showImageSourceDialog() async {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.onPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(
                Icons.camera_alt,
                color: theme.colorScheme.onSurface,
              ),
              title: Text(
                "Foto aufnehmen",
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.image, color: theme.colorScheme.onSurface),
              title: Text(
                "Aus Galerie wählen",
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Schritt 1: Rezept anlegen',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: "Name"),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _portionsController,
                      decoration: const InputDecoration(labelText: "Portionen"),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    // 🥗 Anlass Dropdown
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: _selectedRecipeType,
                      hint: const Text("Art wählen"),
                      decoration: const InputDecoration(labelText: "Art"),
                      items:
                          _mealTypes.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                      onChanged:
                          (value) =>
                              setState(() => _selectedRecipeType = value),
                    ),
                    const SizedBox(height: 16),

                    // 🍝 Typ Dropdown
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: _selectedRecipeCategory,
                      hint: const Text("Kategorie wählen"),
                      decoration: const InputDecoration(labelText: "Kategorie"),
                      items:
                          _recipeCategories.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                      onChanged:
                          (value) =>
                              setState(() => _selectedRecipeCategory = value),
                    ),
                    const SizedBox(height: 16),
                    // 🍝 Typ Dropdown
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: _selectedRecipeSeason,
                      hint: const Text("Saison wählen"),
                      decoration: const InputDecoration(labelText: "Saison"),
                      items:
                          _recipeSeasons.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                      onChanged:
                          (value) =>
                              setState(() => _selectedRecipeSeason = value),
                    ),
                    const SizedBox(height: 16),

                    GestureDetector(
                      onTap: _showImageSourceDialog,
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceBright,
                          borderRadius: BorderRadius.circular(
                            SpoonSparkTheme.radiusS,
                          ),
                        ),
                        child:
                            _image == null
                                ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_a_photo,
                                      color: theme.colorScheme.onSurface,
                                      size: 40,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Bild hinzufügen (optional)",
                                      style: TextStyle(
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                )
                                : ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    SpoonSparkTheme.radiusS,
                                  ),
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

                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: "Zubereitung (optional)",
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),

            // 🟡 Footer with minimal progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  _buildSquareIconButton(
                    Icons.close,
                    () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.surfaceBright,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: 0.33, // 🔄 Adjust this dynamically if needed
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surface.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildSquareIconButton(Icons.arrow_forward, () {
                    Navigator.pushNamed(context, '/addIngredient');
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquareIconButton(IconData icon, VoidCallback onPressed) {
    final theme = Theme.of(context);
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(7),
      ),
      child: IconButton(
        icon: Icon(icon, color: theme.colorScheme.onSurface),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildProgressCircle(bool isActive) {
    final theme = Theme.of(context);
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: isActive ? theme.colorScheme.primary : Colors.transparent,
        border: Border.all(color: theme.colorScheme.primary, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildProgressLine() {
    final theme = Theme.of(context);
    return Container(width: 20, height: 3, color: theme.colorScheme.primary);
  }
}
