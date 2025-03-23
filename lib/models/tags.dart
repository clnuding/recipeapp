class Tags {
  final String id;
  final String name;
  final String category;
  final String? creatorId;


  Tags({
    required this.id,
    required this.name,
    required this.category,
    required this.creatorId,
  });

  factory Tags.fromJson(Map<String, dynamic> json) {
    return Tags(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      creatorId: json['creator_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': name,
      'category': category,
      'creator_id': creatorId,
    };
  }
}
