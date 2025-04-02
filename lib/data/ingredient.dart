class Ingredient {
  Ingredient(
      this.id, this.name, this.description, this.hasAlcohol, this.measure);

  final int id;
  final String name;
  final String description;
  final bool hasAlcohol;
  final String measure;

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'name': String name,
        'description': String? description,
        'alcohol': bool? alcohol,
        'type': String? _,
        'percentage': int? _,
        'imageUrl': String? _,
        'createdAt': String _,
        'updatedAt': String _,
        'measure': String? measure
      } =>
        Ingredient(id, name, description ?? 'Just a simple $name',
            alcohol ?? false, measure ?? 'Just eyeball it'),
      {
        'id': int id,
        'name': String name,
        'description': String? description,
        'alcohol': bool? alcohol,
        'type': String? _,
        'percentage': int? _,
        'imageUrl': String? _,
        'createdAt': String _,
        'updatedAt': String _
      } =>
        Ingredient(id, name, description ?? 'Just a simple $name',
            alcohol ?? false, 'Just eyeball it'),
      _ => throw const FormatException('Failed to load ingredient.'),
    };
  }
}
