import 'package:appcohols/data/ingredient.dart';
import 'package:http/http.dart' as http;
import 'drink.dart';
import 'dart:convert';
import 'dart:io';

class DrinkFetcher {
  DrinkFetcher._privateConst();

  static final DrinkFetcher _instance = DrinkFetcher._privateConst();

  factory DrinkFetcher() {
    return _instance;
  }



  final String apiUrl = "https://cocktails.solvro.pl/api/v1";

  final Map<(int, int), List<Drink>> _drinksPagedCache = {};
  final Map<int, List<Ingredient>> _drinksIngredientsCache = {};

  Future<List<Drink>> fetchDrinks(int page, int perPage) async {
    if (!_drinksPagedCache.containsKey((page, perPage))) {
      print("Fetching deets from URL");
    final uri = Uri.parse('$apiUrl/cocktails')
        .replace(queryParameters: {'page': '$page', 'perPage': '$perPage'});
    final response = await http.get(uri);

    if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    List<dynamic> rawDrinkList = responseData['data'];
    _drinksPagedCache[(page, perPage)] = rawDrinkList.map((jsonObj) => Drink.fromJson(jsonObj)).toList();

    } else {
      _drinksPagedCache[(page, perPage)] = [];
    throw Exception('Failed to load album');
    }
    }
    return _drinksPagedCache[(page, perPage)]!;
  }

  Future<List<Ingredient>> fetchIngredientsForDrink(int drinkId) async {
    if (!_drinksIngredientsCache.containsKey(drinkId)) {
      print("Fetching from URL");
      final uri = Uri.parse('$apiUrl/cocktails/$drinkId');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> rawIngredientsList = responseData['data']['ingredients'];
        _drinksIngredientsCache[drinkId] =  rawIngredientsList
            .map((jsonObj) => Ingredient.fromJson(jsonObj))
            .toList();
      } else {
        _drinksIngredientsCache[drinkId] = [];
        throw Exception('Failed to load album');
      }
    }
    return _drinksIngredientsCache[drinkId]!;
  }
}
