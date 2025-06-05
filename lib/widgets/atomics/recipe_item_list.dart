import 'package:flutter/material.dart';
import 'package:recipeapp/models/recipe.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/api/tags.dart';
import 'package:recipeapp/models/tags.dart';
import 'package:recipeapp/screens/recipe_details.dart';

class RecipeItemList extends StatefulWidget {
  final List<Recipe> recipes;
  final String error;
  final bool isLoading;
  final VoidCallback? onChanged;

  const RecipeItemList({
    super.key,
    required this.recipes,
    required this.error,
    required this.isLoading,
    this.onChanged,
  });

  @override
  State<RecipeItemList> createState() => _RecipeItemListState();
}

class _RecipeItemListState extends State<RecipeItemList> {
  List<Tags> _allTags = [];

  @override
  void initState() {
    super.initState();
    _loadTags();
  }

  Future<void> _loadTags() async {
    final tags = await fetchTags();
    setState(() {
      _allTags = tags;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.error.isNotEmpty) {
      return Center(child: Text("Error: ${widget.error}"));
    }

    if (widget.recipes.isEmpty) {
      return const Center(child: Text("No recipes found."));
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 4),
      itemCount: widget.recipes.length,
      itemBuilder: (context, index) {
        final recipe = widget.recipes[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
          child: InkWell(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailScreen(recipeId: recipe.id),
                ),
              );
              if (result == true && widget.onChanged != null) {
                widget.onChanged!();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 234, 234, 234),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                children: [
                  // ✅ IMAGE
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    child: Image.network(
                      recipe.thumbnailUrl ?? '',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            width: 80,
                            height: 80,
                            color: theme.colorScheme.surfaceBright,
                            child: Icon(
                              Icons.broken_image,
                              size: 40,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                    ),
                  ),

                  // ✅ TEXT
                  Expanded(
                    child: Container(
                      height: 80,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            recipe.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: SpoonSparkTheme.fontWeightSemibold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children:
                                  recipe.tags.map((tagObj) {
                                    final tag = _allTags.firstWhere(
                                      (t) => t.id == tagObj.id,
                                      orElse:
                                          () => Tags(
                                            id: tagObj.id,
                                            name: '?',
                                            category: '',
                                            internal: '',
                                          ),
                                    );
                                    return Container(
                                      margin: const EdgeInsets.only(right: 4),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.85,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        tag.name,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
