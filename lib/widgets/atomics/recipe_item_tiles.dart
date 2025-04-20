import 'package:flutter/material.dart';
import 'package:recipeapp/api/tags.dart';
import 'package:recipeapp/models/recipe.dart';
import 'package:recipeapp/models/tags.dart';
import 'package:recipeapp/screens/recipe_details.dart';
import 'package:recipeapp/theme/theme.dart';

class RecipeItemTiles extends StatefulWidget {
  final List<Recipe> recipes;
  final String error;
  final bool isLoading;
  final VoidCallback? onChanged; // ✅ Added this

  const RecipeItemTiles({
    super.key,
    required this.recipes,
    required this.error,
    required this.isLoading,
    this.onChanged,
  });

  @override
  State<RecipeItemTiles> createState() => _RecipeItemTilesState();
}

class _RecipeItemTilesState extends State<RecipeItemTiles> {
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
    if (widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.error.isNotEmpty) {
      return Center(child: Text("Error: ${widget.error}"));
    }

    if (widget.recipes.isEmpty) {
      return const Center(child: Text("No recipes found."));
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),
      itemCount: widget.recipes.length,
      itemBuilder: (context, index) {
        final recipe = widget.recipes[index];

        final tagNames =
            (recipe.tagId ?? []).map((id) {
              return _allTags
                  .firstWhere(
                    (tag) => tag.id == id,
                    orElse: () => Tags(id: id, name: '?', category: ''),
                  )
                  .name;
            }).toList();

        return RecipeCard(
          recipe: recipe,
          tagNames: tagNames,
          onTap: () async {
            // ✅ Await result from detail screen
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetailScreen(recipeId: recipe.id),
              ),
            );

            if (result == true && widget.onChanged != null) {
              widget.onChanged!(); // ✅ Trigger reload if needed
            }
          },
        );
      },
    );
  }
}

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final List<String> tagNames;
  final VoidCallback? onTap;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.tagNames,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
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
        child: Column(
          children: [
            // 🖼 Image with overlays
            Expanded(
              flex: 2,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      recipe.thumbnailUrl ?? 'https://via.placeholder.com/150',
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Icon(
                            Icons.broken_image,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                            size: 50,
                          ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.timer,
                            size: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${recipe.prepTime ?? "-"} Min',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (tagNames.isNotEmpty)
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children:
                              tagNames.map((tag) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 6),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.85),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    tag,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    recipe.title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: SpoonSparkTheme.fontWeightSemibold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
