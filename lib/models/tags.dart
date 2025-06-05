class Tags {
  final String id;
  final String name;
  final String category;
  final String internal;

  Tags({
    required this.id,
    required this.name,
    required this.category,
    required this.internal,
  });

  factory Tags.fromJson(Map<String, dynamic> json) {
    return Tags(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      internal: json['internal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': name,
      'category': category,
      'internal': internal,
    };
  }
}
