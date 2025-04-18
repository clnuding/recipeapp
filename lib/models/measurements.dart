class Measurements {
  final String id;
  final String name;
  final String abbreviation;

  Measurements({
    required this.id,
    required this.name,
    required this.abbreviation,
  });

  factory Measurements.fromJson(Map<String, dynamic> json) {
    return Measurements(
      id: json['id'],
      name: json['name'],
      abbreviation: json['name_en'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'abbreviation': abbreviation};
  }
}
