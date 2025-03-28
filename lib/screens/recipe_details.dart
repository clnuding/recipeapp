import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recipeapp/theme/theme.dart';

class RecipeDetailScreen extends StatelessWidget {
  final List<String> tags = ['Vegan', 'Gluten-Free', 'Dinner'];
  final String description =
      'A healthy and delicious vegan dinner recipe perfect for weeknights.';
  final List<String> ingredients = [
    '1 cup quinoa',
    '2 cups water',
    '1 tbsp olive oil',
    '1 garlic clove',
    '1 cup cherry tomatoes',
    '1/2 cup spinach',
  ];

  RecipeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(icon: const Icon(Icons.delete), onPressed: () {}),
          IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
        ],
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'spoon',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 2),
            // SVG Logo
            SvgPicture.asset(
              'assets/logos/spoonspark_logo.svg', // Make sure to add this path in your pubspec.yaml
              height: 25, // Adjust height as needed
            ),
            const SizedBox(width: 2),
            const Text(
              'spark',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        backgroundColor: lightBackground, // Customize as needed
        elevation: 0, // Remove shadow if desired
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 4.0,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 1.9,
                  child: Image.network(
                    'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.tastingtable.com%2Fimg%2Fgallery%2Fclassic-liver-and-onions-recipe%2Fl-intro-1666124471.jpg&f=1&nofb=1&ipt=1f14b3af8c9548580dbfdf288cbea9ad270a8573ac9bec45e01633915e8c524f&ipo=images',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 40,
              margin: const EdgeInsets.only(left: 16.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tags.length,
                itemBuilder:
                    (context, index) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(child: Text(tags[index])),
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(description, style: TextStyle(fontSize: 16)),
            ),

            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatCard(
                    icon: Icons.restaurant,
                    label: 'Serves',
                    value: '2',
                  ),
                  _StatCard(
                    icon: Icons.schedule,
                    label: 'Time',
                    value: '30 min',
                  ),
                  _StatCard(
                    icon: Icons.list,
                    label: 'Ingredients',
                    value: ingredients.length.toString(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Ingredients',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: ingredients.length,
                itemBuilder:
                    (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text("• ${ingredients[index]}"),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon),
          SizedBox(height: 4),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
