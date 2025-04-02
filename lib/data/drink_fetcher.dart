import 'package:appcohols/data/ingredient.dart';
import 'package:http/http.dart' as http;
import 'drink.dart';
import 'dart:convert';
import 'dart:io';

class DrinkFetcher {
  final String apiUrl = "https://cocktails.solvro.pl/api/v1";

  Future<List<Drink>> fetchDrinks() async {
    final uri = Uri.parse('$apiUrl/cocktails')
        .replace(queryParameters: {'page': '1', 'perPage': '25'});
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      List<dynamic> rawDrinkList = responseData['data'];
      return rawDrinkList.map((jsonObj) => Drink.fromJson(jsonObj)).toList();
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<Ingredient>> fetchIngredientsForDrink(int drinkId) async {
    final uri = Uri.parse('$apiUrl/cocktails/$drinkId');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      List<dynamic> rawIngredientsList = responseData['data']['ingredients'];
      return rawIngredientsList
          .map((jsonObj) => Ingredient.fromJson(jsonObj))
          .toList();
    } else {
      throw Exception('Failed to load album');
    }
  }
}
