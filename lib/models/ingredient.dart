class Ingredient {
  final String id;
  final String name;
  final String? nameEn;
  final String? description;
  final bool isAllergen;
  final String? standardMeasurementId;
  final double? standardServingSize;
  final String? categoryId;

  Ingredient({
    required this.id,
    required this.name,
    this.nameEn,
    this.description,
    this.isAllergen = false,
    this.standardMeasurementId,
    this.standardServingSize,
    this.categoryId,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'],
      name: json['name'],
      nameEn: json['name_en'],
      description: json['description'],
      isAllergen: json['is_allergen'] ?? false,
      standardMeasurementId: json['standard_measurement_id'],
      standardServingSize:
          (json['standard_serving_size'] is num)
              ? (json['standard_serving_size'] as num).toDouble()
              : null,
      categoryId: json['category_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_en': nameEn,
      'description': description,
      'is_allergen': isAllergen,
      'standard_measurement_id': standardMeasurementId,
      'standard_serving_size': standardServingSize,
      'category_id': categoryId,
    };
  }
}
