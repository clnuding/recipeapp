import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:recipeapp/api/recipeingredients.dart';
import 'package:recipeapp/screens/add_ingredient.dart';
import 'package:recipeapp/state/recipe_wizard_state.dart';
import 'dart:io';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/widgets/atomics/appbar.dart';
import 'package:recipeapp/models/tags.dart';
import 'package:recipeapp/api/tags.dart';
import 'package:recipeapp/api/pb_client.dart';
import 'package:recipeapp/api/recipes.dart';

class AddRecipePage extends StatefulWidget {
  final String? recipeId; // ✅ Accepts null for create mode

  const AddRecipePage({super.key, this.recipeId});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  bool get _isFormValid =>
      _nameController.text.trim().isNotEmpty && _selectedRecipeType != null;

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  File? _image;
  String? thumbnailUrl;

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
    if (widget.recipeId != null) {
      _loadRecipeData(widget.recipeId!);
    } else {
      _loadInitialWizardState();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final wizard = Provider.of<RecipeWizardState>(context, listen: false);

    // Only update if image not manually set
    if (_image == null && wizard.image != null) {
      setState(() {
        _image = wizard.image;
      });
    }

    if (thumbnailUrl == null &&
        wizard.recipeId != null &&
        wizard.thumbnailFilename != null &&
        wizard.thumbnailFilename!.isNotEmpty) {
      setState(() {
        thumbnailUrl =
            "${pb.baseUrl}/api/files/recipes/${wizard.recipeId}/${wizard.thumbnailFilename}";
      });
    }
  }

  void _loadInitialWizardState() {
    final wizard = Provider.of<RecipeWizardState>(context, listen: false);

    _nameController.text = wizard.title ?? '';
    _descriptionController.text = wizard.description ?? '';
    if (_image == null && wizard.image != null) {
      _image = wizard.image;
    }
    _portions = wizard.servings;

    final prepTime = wizard.prepTimeMinutes;
    _hourController.text = (prepTime ~/ 60).toString().padLeft(2, '0');
    _minuteController.text = (prepTime % 60).toString().padLeft(2, '0');

    _loadTags();
  }

  void _showTimePickerBottomSheet({
    required bool isHour,
    required TextEditingController controller,
  }) {
    final theme = Theme.of(context);
    final List<int> options =
        isHour
            ? List.generate(7, (index) => index) // 0 to 6
            : List.generate(12, (index) => index * 5); // 0 to 55 by 5

    final currentValue = int.tryParse(controller.text) ?? 0;
    final initialIndex = options.indexOf(currentValue);
    final scrollController = FixedExtentScrollController(
      initialItem: initialIndex,
    );

    int selectedValue = currentValue;

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.onPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Text(
                isHour ? "Stunden wählen" : "Minuten wählen",
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    ListWheelScrollView.useDelegate(
                      controller: scrollController,
                      itemExtent: 50,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (index) {
                        selectedValue = options[index];
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: options.length,
                        builder: (context, index) {
                          final value = options[index].toString().padLeft(
                            2,
                            '0',
                          );
                          return Center(
                            child: Text(
                              value,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color:
                                    options[index] == selectedValue
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.onSurface,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      controller.text = selectedValue.toString().padLeft(
                        2,
                        '0',
                      );
                    });
                    Navigator.pop(context);
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  child: const Text("Bestätigen"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _handleBackPressed() async {
    final shouldLeave = await _showDiscardChangesDialog();
    if (shouldLeave && mounted) {
      // 🧹 Clear wizard state
      Provider.of<RecipeWizardState>(context, listen: false).clear();
      Navigator.of(context).pop(); // ⬅️ actually go back
    }
    return false; // Prevent default back navigation
  }

  Future<bool> _showDiscardChangesDialog() async {
    final theme = Theme.of(context);
    bool shouldLeave = false;

    await showModalBottomSheet(
      context: context,
      isDismissible: true,
      backgroundColor: theme.colorScheme.onPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 40,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text("Änderungen verwerfen?", style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                "Wenn du zurück gehst, gehen deine Eingaben verloren.",
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  shouldLeave = true;
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text("Ja, zurückgehen"),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Abbrechen"),
              ),
            ],
          ),
        );
      },
    );

    return shouldLeave;
  }

  Future<void> _loadRecipeData(String recipeId) async {
    final recipe = await fetchRecipeById(recipeId);
    final tags = await fetchTags();
    final dbIngredients = await fetchRecipeIngredientsByRecipeId(recipeId);

    final wizard = Provider.of<RecipeWizardState>(context, listen: false);

    // ✅ Mark as editing
    wizard.setEditing(true);
    wizard.setRecipeId(recipeId);
    wizard.setThumbnail(
      recipe.thumbnail,
    ); // this sets the filename (e.g., "thumbnail.jpg")

    // ✅ Basic metadata
    wizard.setRecipeInfo(
      title: recipe.title,
      description: recipe.description ?? '',
      image: null,
      servings: recipe.servings ?? 1,
      prepTimeMinutes: recipe.prepTime ?? 0,
      tagIds: (recipe.tagId ?? []).cast<String>(),
    );

    wizard.setTagObjects(
      (recipe.tagId ?? []).map((id) {
        return tags.firstWhere(
          (tag) => tag.id == id,
          orElse: () => Tags(id: id, name: '?', category: ''),
        );
      }).toList(),
    );

    // ✅ ✅ ✅ ADD THIS: populate ingredients
    for (final ing in dbIngredients) {
      wizard.addIngredient(ing);
    }

    if (recipe.thumbnail != null && recipe.thumbnail!.isNotEmpty) {
      thumbnailUrl =
          "${pb.baseUrl}/api/files/recipes/${recipe.id}/${recipe.thumbnail}";
    }

    // Continue local form setup
    _loadInitialWizardState();
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
      isDismissible: true,
      backgroundColor: theme.colorScheme.onPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_a_photo,
                size: 40,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text("Bild hinzufügen", style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                "Wähle eine Option zum Hinzufügen eines Bildes.",
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text("Foto aufnehmen"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
                icon: const Icon(Icons.image),
                label: const Text("Aus Galerie wählen"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.surfaceBright,
                  foregroundColor: theme.colorScheme.onSurface,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Abbrechen"),
              ),
            ],
          ),
        );
      },
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
                orElse:
                    () => Tags(id: '', name: '', category: '', internal: ''),
              )
              .id,
          _recipeCategories
              .firstWhere(
                (tag) => tag.name == _selectedRecipeCategory,
                orElse:
                    () => Tags(id: '', name: '', category: '', internal: ''),
              )
              .id,
          _recipeSeasons
              .firstWhere(
                (tag) => tag.name == _selectedRecipeSeason,
                orElse:
                    () => Tags(id: '', name: '', category: '', internal: ''),
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
    final wizard = Provider.of<RecipeWizardState>(context, listen: false);
    final imageToShow = _image ?? wizard.image;

    return WillPopScope(
      onWillPop: _handleBackPressed, // <-- handle physical back button
      child: Scaffold(
        appBar: LogoAppbar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back), // same style as forward
            onPressed: () async {
              final shouldLeave = await _handleBackPressed();
              if (shouldLeave && mounted) {
                Navigator.of(context).pop();
              }
            },
          ),

          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: _isFormValid ? _submitRecipe : null,
              color: _isFormValid ? null : Colors.grey,
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

                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          SpoonSparkTheme.radiusS,
                                        ),
                                        child:
                                            imageToShow != null
                                                ? Image.file(
                                                  imageToShow,
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                )
                                                : (thumbnailUrl != null
                                                    ? Image.network(
                                                      thumbnailUrl!,
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                    )
                                                    : Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.add_a_photo,
                                                            color:
                                                                theme
                                                                    .colorScheme
                                                                    .onSurface,
                                                            size: 40,
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          Text(
                                                            "Bild hinzufügen (optional)",
                                                            style: TextStyle(
                                                              color:
                                                                  theme
                                                                      .colorScheme
                                                                      .onSurface,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                      ),
                                      if (imageToShow != null ||
                                          thumbnailUrl != null)
                                        Positioned(
                                          right: 8,
                                          bottom: 8,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: theme.colorScheme.surface,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                6.0,
                                              ),
                                              child: Icon(
                                                Icons.edit,
                                                size: 18,
                                                color:
                                                    theme.colorScheme.primary,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
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
                                    (_) => setState(
                                      () {},
                                    ), // 👈 Refresh when typing
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
                                          _boxedTimeField(
                                            _hourController,
                                            isHour: true,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 4,
                                            ),
                                            child: Text(":"),
                                          ),
                                          _boxedTimeField(
                                            _minuteController,
                                            isHour: false,
                                          ),
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
                                      _selectedRecipeType == null &&
                                              !_isFormValid
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

  Widget _boxedTimeField(
    TextEditingController controller, {
    required bool isHour,
  }) => GestureDetector(
    onTap:
        () =>
            _showTimePickerBottomSheet(isHour: isHour, controller: controller),
    child: Container(
      width: 50,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Text(
        controller.text,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
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
