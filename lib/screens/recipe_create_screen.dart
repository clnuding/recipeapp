import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/widgets/atomics/appbar.dart';
import 'package:recipeapp/widgets/atomics/text_form_field.dart';

class RecipeCreateScreen extends StatefulWidget {
  const RecipeCreateScreen({super.key});

  @override
  _RecipeCreateScreenState createState() => _RecipeCreateScreenState();
}

class _RecipeCreateScreenState extends State<RecipeCreateScreen>
    with SingleTickerProviderStateMixin {
  XFile? _pickedImage;
  final _titleController = TextEditingController();
  final _instructionsController = TextEditingController();
  int _servings = 2;

  final List<String> mealOccasions = [
    'Wähle den Anlass',
    'Frühstück',
    'Hauptgang',
    'Beilage',
  ];

  final List<String> mealTypes = [
    'Wähle den Typ',
    'Nudeln',
    'Reis',
    'Fleisch/Fisch/Tofu',
    'Kartoffeln',
    'Salate',
    'Eintöpfe/Suppen',
  ];

  String selectedMealOccasion = 'Wähle den Anlass';
  String selectedMealType = 'Wähle den Typ';

  final LayerLink _layerLink1 = LayerLink();
  final LayerLink _layerLink2 = LayerLink();
  OverlayEntry? _dropdownOverlay;

  final GlobalKey _tagKey1 = GlobalKey();
  final GlobalKey _tagKey2 = GlobalKey();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _pickedImage = image);
    }
  }

  void _toggleDropdown(
    GlobalKey key,
    List<String> items,
    Function(String) onSelected,
  ) {
    if (_dropdownOverlay != null) {
      _removeDropdown();
    } else {
      _showDropdown(key, items, onSelected);
    }
  }

  void _removeDropdown() {
    _dropdownOverlay?.remove();
    _dropdownOverlay = null;
  }

  void _showDropdown(
    GlobalKey key,
    List<String> items,
    Function(String) onSelected,
  ) {
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    _dropdownOverlay = OverlayEntry(
      builder: (context) {
        final theme = Theme.of(context);
        return Positioned(
          left: offset.dx,
          top: offset.dy + size.height + 4,
          width: size.width,
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceBright,
                borderRadius: BorderRadius.circular(SpoonSparkTheme.radiusS),
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children:
                    items.map((type) {
                      return InkWell(
                        onTap: () {
                          onSelected(type);
                          _removeDropdown();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: SpoonSparkTheme.spacingM,
                            vertical: SpoonSparkTheme.spacingS,
                          ),
                          child: Text(
                            type,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_dropdownOverlay!);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _instructionsController.dispose();
    _dropdownOverlay?.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const LogoAppbar(actions: []),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: SpoonSparkTheme.spacingXXL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🖼 Image Picker
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SpoonSparkTheme.spacingL,
                    vertical: SpoonSparkTheme.spacingXS,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      SpoonSparkTheme.radiusXXL,
                    ),
                    child: AspectRatio(
                      aspectRatio: 1.9,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceBright,
                                image:
                                    (_pickedImage != null && !kIsWeb)
                                        ? DecorationImage(
                                          image: FileImage(
                                            File(_pickedImage!.path),
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                        : null,
                              ),
                              child:
                                  _pickedImage == null
                                      ? Center(
                                        child: Icon(
                                          Icons.add_a_photo,
                                          size: 40,
                                          color: theme.colorScheme.onSurface
                                              .withOpacity(0.5),
                                        ),
                                      )
                                      : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: SpoonSparkTheme.spacingL),

                // 📝 Rezeptname
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SpoonSparkTheme.spacingL,
                  ),
                  child: CustomTextFormField(
                    label: 'Rezeptname',
                    fieldController: _titleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte trage einen Rezeptnamen ein';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: SpoonSparkTheme.spacingL),

                // 🔽 Dropdowns
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SpoonSparkTheme.spacingL,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: CompositedTransformTarget(
                          link: _layerLink1,
                          child: GestureDetector(
                            key: _tagKey1,
                            onTap:
                                () => _toggleDropdown(
                                  _tagKey1,
                                  mealOccasions,
                                  (value) => setState(
                                    () => selectedMealOccasion = value,
                                  ),
                                ),
                            child: _buildDropdownTag(
                              theme,
                              selectedMealOccasion,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: SpoonSparkTheme.spacingS),
                      Expanded(
                        child: CompositedTransformTarget(
                          link: _layerLink2,
                          child: GestureDetector(
                            key: _tagKey2,
                            onTap:
                                () => _toggleDropdown(
                                  _tagKey2,
                                  mealTypes,
                                  (value) =>
                                      setState(() => selectedMealType = value),
                                ),
                            child: _buildDropdownTag(theme, selectedMealType),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: SpoonSparkTheme.spacingL),

                // 📑 Tabs
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SpoonSparkTheme.spacingL,
                  ),
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        labelColor: theme.colorScheme.primary,
                        unselectedLabelColor: theme.colorScheme.onSurface
                            .withOpacity(0.6),
                        indicatorColor: theme.colorScheme.primary,
                        tabs: const [
                          Tab(text: 'Zutaten'),
                          Tab(text: 'Zubereitung'),
                        ],
                      ),
                      const SizedBox(height: SpoonSparkTheme.spacingM),
                      SizedBox(
                        height: 350,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // 🧾 Zutaten Tab
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () {
                                        if (_servings > 1) {
                                          setState(() => _servings--);
                                        }
                                      },
                                    ),
                                    Text(
                                      '$_servings Portionen',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed:
                                          () => setState(() => _servings++),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Center(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // TODO: Zutaten hinzufügen
                                    },
                                    icon: const Icon(Icons.add),
                                    label: const Text('Zutat hinzufügen'),
                                  ),
                                ),
                              ],
                            ),

                            // ✍️ Zubereitung Tab
                            Padding(
                              padding: const EdgeInsets.all(
                                SpoonSparkTheme.spacingL,
                              ),
                              child: TextFormField(
                                controller: _instructionsController,
                                maxLines: 10,
                                decoration: InputDecoration(
                                  labelText: 'Zubereitungsschritte',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      SpoonSparkTheme.radiusM,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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

  Widget _buildDropdownTag(ThemeData theme, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SpoonSparkTheme.spacingM,
        vertical: SpoonSparkTheme.spacingS,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(SpoonSparkTheme.radiusS),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: SpoonSparkTheme.spacingXS),
          Icon(
            Icons.keyboard_arrow_down,
            color: theme.colorScheme.onSurface,
            size: theme.textTheme.labelSmall?.fontSize ?? 14,
          ),
        ],
      ),
    );
  }
}
