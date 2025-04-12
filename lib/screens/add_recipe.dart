import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/widgets/atomics/appbar.dart';

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

  String? _selectedRecipeType;
  final List<String> _mealTypes = [
    'Frühstück',
    'Hauptgang',
    'Beilage',
    'Dessert',
    'Snack',
  ];

  String? _selectedRecipeCategory;
  final List<String> _recipeCategories = [
    'Nudeln',
    'Reis',
    'Fleisch/Fisch/Tofu',
    'Kartoffeln',
    'Salate',
    'Eintöpfe/Suppen',
  ];

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
    if (pickedFile != null) setState(() => _image = File(pickedFile.path));
  }

  Future<void> _showImageSourceDialog() async {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.onPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder:
          (context) => Wrap(
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
          ),
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
      appBar: LogoAppbar(
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => Navigator.pushNamed(context, '/addIngredient'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: SpoonSparkTheme.spacingL),

              _buildStepper(theme),
              const SizedBox(height: SpoonSparkTheme.spacingL),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
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

                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: _selectedRecipeType,
                      hint: const Text("Art wählen"),
                      decoration: const InputDecoration(labelText: "Art"),
                      items:
                          _mealTypes
                              .map(
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ),
                              )
                              .toList(),
                      onChanged:
                          (value) =>
                              setState(() => _selectedRecipeType = value),
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: _selectedRecipeCategory,
                      hint: const Text("Kategorie wählen"),
                      decoration: const InputDecoration(labelText: "Kategorie"),
                      items:
                          _recipeCategories
                              .map(
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ),
                              )
                              .toList(),
                      onChanged:
                          (value) =>
                              setState(() => _selectedRecipeCategory = value),
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: _selectedRecipeSeason,
                      hint: const Text("Saison wählen"),
                      decoration: const InputDecoration(labelText: "Saison"),
                      items:
                          _recipeSeasons
                              .map(
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ),
                              )
                              .toList(),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepper(ThemeData theme) {
    const stepLabels = ["Rezept", "Zutaten", "Prüfen"];
    const int activeIndex = 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpoonSparkTheme.spacingL),
      child: Column(
        children: [
          Row(
            children: List.generate(3, (index) {
              final isActive = index == activeIndex;
              final isCompleted = index < activeIndex;
              final Color barColor =
                  isActive
                      ? theme.colorScheme.primary
                      : isCompleted
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceBright;

              BorderRadius borderRadius = BorderRadius.zero;
              if (index == 0) {
                borderRadius = const BorderRadius.horizontal(
                  left: Radius.circular(12),
                );
              } else if (index == 2) {
                borderRadius = const BorderRadius.horizontal(
                  right: Radius.circular(12),
                );
              }

              return Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: index < 2 ? 4 : 0),
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: barColor,
                          borderRadius: borderRadius,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          stepLabels[index],
                          style: theme.textTheme.labelSmall?.copyWith(
                            color:
                                isActive
                                    ? theme.colorScheme.onSurface
                                    : theme.colorScheme.onSurface,
                          ),
                        ),
                        if (isCompleted)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.check,
                              size: 12,
                              color: theme.colorScheme.primary.withOpacity(0.7),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
