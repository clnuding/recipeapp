class Recipe {
  final String title;
  final String description;
  final String imageUrl;

  Recipe({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description, 'image_url': imageUrl};
  }
}
