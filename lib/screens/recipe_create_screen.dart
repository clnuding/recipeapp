import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/widgets/ingredients_grid.dart';
import 'package:recipeapp/widgets/atomics/appbar.dart';
import 'package:recipeapp/widgets/atomics/tag.dart';

class RecipeCreateScreen extends StatefulWidget {
  const RecipeCreateScreen({super.key});

  @override
  _RecipeCreateScreenState createState() => _RecipeCreateScreenState();
}

class _RecipeCreateScreenState extends State<RecipeCreateScreen> {
  final List<String> tags = ['french', 'dinner', 'vegetarian'];
  XFile? _pickedImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const LogoAppbar(actions: []),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: SpoonSparkTheme.spacingXXL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image or placeholder
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: SpoonSparkTheme.spacingL,
                  vertical: SpoonSparkTheme.spacingXS,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(SpoonSparkTheme.radiusXXL),
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
                              image: (_pickedImage != null && !kIsWeb)
                                  ? DecorationImage(
                                      image: FileImage(File(_pickedImage!.path)),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _pickedImage == null
                                ? Center(
                                    child: Icon(
                                      Icons.add_a_photo,
                                      size: 40,
                                      color: theme.colorScheme.onSurface.withOpacity(0.5),
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

              // Tags
              SizedBox(
                height: SpoonSparkTheme.spacingXXL,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: SpoonSparkTheme.spacingL),
                  scrollDirection: Axis.horizontal,
                  itemCount: tags.length,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(SpoonSparkTheme.radiusS),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onPrimary.withAlpha(80),
                            borderRadius: BorderRadius.circular(SpoonSparkTheme.radiusXXL),
                          ),
                          margin: const EdgeInsets.only(right: SpoonSparkTheme.spacingS),
                          padding: const EdgeInsets.symmetric(
                            horizontal: SpoonSparkTheme.spacingM,
                            vertical: SpoonSparkTheme.spacingXS,
                          ),
                          child: Text(
                            tags[index],
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: SpoonSparkTheme.spacingXXL),

              // Ingredients Grid (empty)
              IngredientsGrid(
                initialServings: 2,
                ingredients: [],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
