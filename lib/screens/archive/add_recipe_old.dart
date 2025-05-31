import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:recipeapp/screens/add_ingredient.dart';
import 'package:recipeapp/state/recipe_wizard_state.dart';
import 'dart:io';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/widgets/atomics/appbar.dart';
import 'package:recipeapp/models/tags.dart';
import 'package:recipeapp/api/tags.dart';
import 'package:recipeapp/api/pb_client.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  bool get _isFormValid =>
      _nameController.text.trim().isNotEmpty && _selectedRecipeType != null;

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  File? _image;

  int _portions = 2;
  final TextEditingController _hourController = TextEditingController(
    text: '00',
  );
  final TextEditingController _minuteController = TextEditingController(
    text: '00',
  );

  String? _selectedRecipeType;
  String? _selectedRecipeCategory;
  String? _selectedRecipeSeason;

  List<Tags> _mealTypes = [];
  List<Tags> _recipeCategories = [];
  List<Tags> _recipeSeasons = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    final wizard = Provider.of<RecipeWizardState>(context, listen: false);

    // Load previously saved values
    _nameController.text = wizard.title ?? '';
    _descriptionController.text = wizard.description ?? '';
    _image = wizard.image;
    _portions = wizard.servings;

    final prepTime = wizard.prepTimeMinutes;
    _hourController.text = (prepTime ~/ 60).toString().padLeft(2, '0');
    _minuteController.text = (prepTime % 60).toString().padLeft(2, '0');

    // Load tags after fetching them
    _loadTags();
  }

  Future<void> _loadTags() async {
    final tags = await fetchTags();
    final wizard = Provider.of<RecipeWizardState>(context, listen: false);
    final tagIds = wizard.tagIds;

    final mealTypes = tags.where((tag) => tag.category == 'meal_type').toList();
    final recipeCategories =
        tags.where((tag) => tag.category == 'meal_category').toList();
    final recipeSeasons =
        tags.where((tag) => tag.category == 'season').toList();

    String? getSelectedName(List<Tags> list) {
      final match = list.firstWhere(
        (tag) => tagIds.contains(tag.id),
        orElse: () => Tags(id: '', name: '', category: ''),
      );
      return match.name.isEmpty ? null : match.name;
    }

    setState(() {
      _mealTypes = mealTypes;
      _recipeCategories = recipeCategories;
      _recipeSeasons = recipeSeasons;

      _selectedRecipeType = getSelectedName(_mealTypes);
      _selectedRecipeCategory = getSelectedName(_recipeCategories);
      _selectedRecipeSeason = getSelectedName(_recipeSeasons);

      _isLoading = false;
    });
  }

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

  Future<void> _submitRecipe() async {
    final wizard = Provider.of<RecipeWizardState>(context, listen: false);

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final servings = _portions;
    final prepMinutes =
        (int.tryParse(_hourController.text) ?? 0) * 60 +
        (int.tryParse(_minuteController.text) ?? 0);

    final tagIds =
        [
          _mealTypes
              .firstWhere(
                (tag) => tag.name == _selectedRecipeType,
                orElse: () => Tags(id: '', name: '', category: ''),
              )
              .id,
          _recipeCategories
              .firstWhere(
                (tag) => tag.name == _selectedRecipeCategory,
                orElse: () => Tags(id: '', name: '', category: ''),
              )
              .id,
          _recipeSeasons
              .firstWhere(
                (tag) => tag.name == _selectedRecipeSeason,
                orElse: () => Tags(id: '', name: '', category: ''),
              )
              .id,
        ].where((id) => id.isNotEmpty).toList();

    wizard.setRecipeInfo(
      title: name,
      description: description,
      image: _image,
      servings: servings,
      prepTimeMinutes: prepMinutes,
      tagIds: tagIds,
    );

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => AddIngredientPage(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: LogoAppbar(
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: _isFormValid ? _submitRecipe : null,
            color:
                _isFormValid
                    ? null
                    : Colors.grey, // Optional: visually indicate disabled
          ),
        ],
      ),

      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add_a_photo,
                                              color:
                                                  theme.colorScheme.onSurface,
                                              size: 40,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "Bild hinzufügen (optional)",
                                              style: TextStyle(
                                                color:
                                                    theme.colorScheme.onSurface,
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
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: "Name *",
                                hintText: "Namen eintragen",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                errorText:
                                    _nameController.text.trim().isEmpty &&
                                            !_isFormValid
                                        ? "Pflichtfeld"
                                        : null,
                              ),
                              onChanged:
                                  (_) =>
                                      setState(() {}), // 👈 Refresh when typing
                            ),

                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: InputDecorator(
                                    decoration: const InputDecoration(
                                      labelText: "Portionen",
                                      border: OutlineInputBorder(),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _boxedButton(
                                          Icons.remove,
                                          () => setState(
                                            () =>
                                                _portions =
                                                    _portions > 1
                                                        ? _portions - 1
                                                        : 1,
                                          ),
                                        ),
                                        Text(
                                          '$_portions',
                                          style: theme.textTheme.bodyLarge,
                                        ),
                                        _boxedButton(
                                          Icons.add,
                                          () => setState(() => _portions++),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: InputDecorator(
                                    decoration: const InputDecoration(
                                      labelText: "Zubereitungszeit",
                                      border: OutlineInputBorder(),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _boxedTimeField(_hourController),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 4,
                                          ),
                                          child: Text(":"),
                                        ),
                                        _boxedTimeField(_minuteController),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: _selectedRecipeType,
                              hint: const Text("Art wählen"),
                              decoration: InputDecoration(
                                labelText: "Art *",
                                errorText:
                                    _selectedRecipeType == null && !_isFormValid
                                        ? "Pflichtfeld"
                                        : null,
                              ),
                              items:
                                  _mealTypes
                                      .map(
                                        (tag) => DropdownMenuItem(
                                          value: tag.name,
                                          child: Text(tag.name),
                                        ),
                                      )
                                      .toList(),
                              onChanged:
                                  (value) => setState(
                                    () => _selectedRecipeType = value,
                                  ),
                            ),

                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: _selectedRecipeCategory,
                              hint: const Text("Kategorie wählen"),
                              decoration: const InputDecoration(
                                labelText: "Kategorie",
                              ),
                              items:
                                  _recipeCategories
                                      .map(
                                        (tag) => DropdownMenuItem(
                                          value: tag.name,
                                          child: Text(tag.name),
                                        ),
                                      )
                                      .toList(),
                              onChanged:
                                  (value) => setState(
                                    () => _selectedRecipeCategory = value,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: _selectedRecipeSeason,
                              hint: const Text("Saison wählen"),
                              decoration: const InputDecoration(
                                labelText: "Saison",
                              ),
                              items:
                                  _recipeSeasons
                                      .map(
                                        (tag) => DropdownMenuItem(
                                          value: tag.name,
                                          child: Text(tag.name),
                                        ),
                                      )
                                      .toList(),
                              onChanged:
                                  (value) => setState(
                                    () => _selectedRecipeSeason = value,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _descriptionController,
                              decoration: const InputDecoration(
                                labelText: "Zubereitung (optional)",
                                hintText: "Beschreibung eintragen",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
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

  Widget _boxedButton(IconData icon, VoidCallback onPressed) => Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade300),
      color: Colors.white,
    ),
    child: IconButton(
      icon: Icon(icon, size: 20),
      padding: EdgeInsets.zero,
      onPressed: onPressed,
    ),
  );

  Widget _boxedTimeField(TextEditingController controller) => Container(
    width: 50,
    height: 40,
    alignment: Alignment.center,
    child: TextField(
      controller: controller,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: const InputDecoration(),
    ),
  );

  Widget _buildStepper(ThemeData theme) {
    const stepLabels = ["Rezept", "Zutaten", "Prüfen"];
    const int activeIndex = 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpoonSparkTheme.spacingL),
      child: Row(
        children: List.generate(3, (index) {
          final isActive = index == activeIndex;
          final isCompleted = index < activeIndex;
          final Color barColor =
              isActive || isCompleted
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surfaceBright;

          BorderRadius borderRadius = BorderRadius.zero;
          if (index == 0)
            borderRadius = const BorderRadius.horizontal(
              left: Radius.circular(12),
            );
          if (index == 2)
            borderRadius = const BorderRadius.horizontal(
              right: Radius.circular(12),
            );

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
                Text(
                  stepLabels[index],
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
