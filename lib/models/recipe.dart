class Recipe {
  final String title;
  final String imageUrl;
  final String? description;
  final String? subheader;
  final String? category;

  Recipe({
    required this.title,
    required this.imageUrl,
    this.subheader,
    this.description,
    this.category,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      subheader: json['subheader'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'subheader': subheader,
      'category': category,
    };
  }
}