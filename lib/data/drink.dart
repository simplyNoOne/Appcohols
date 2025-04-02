
import 'dart:collection';
import 'ingredient.dart';

class Drink {
  Drink(this.id, this.name, this.category, this.glass, this.instructions, this.imageUrl, this.isAlcoholic);

  int id;
  String name;
  String category;
  String glass;
  String instructions;
  String imageUrl;
  bool isAlcoholic;

  factory Drink.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'name': String name,
        'category': String category,
        'glass': String glass,
        'instructions': String instructions,
        'imageUrl': String imgUrl,
        'alcoholic': bool alcoholic,
        'createdAt' : String _,
        'updatedAt' : String _
      } => Drink(
        id,
        name,
        category,
        glass,
        instructions,
        imgUrl,
        alcoholic
      ),
      _ => throw const FormatException('Failed to load drink.'),
    };
  }
}
