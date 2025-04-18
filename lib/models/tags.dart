class Tags {
  final String id;
  final String name;
  final String category;

  Tags({required this.id, required this.name, required this.category});

  factory Tags.fromJson(Map<String, dynamic> json) {
    return Tags(id: json['id'], name: json['name'], category: json['category']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': name, 'category': category};
  }
}
