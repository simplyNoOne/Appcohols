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
  final perPage = 30;
  final Map<(int, String, bool), List<Drink>> _drinksPagedCache = {};
  final Map<int, List<Ingredient>> _drinksIngredientsCache = {};

  Future<List<Drink>> fetchDrinks(int page, String searchPhrase, bool alphabetical) async {
    if (!_drinksPagedCache.containsKey((page, searchPhrase, alphabetical))) {
      print("Fetching deets from URL");
      String sign = alphabetical ? '+' : '-';
    final uri = Uri.parse('$apiUrl/cocktails')
        .replace(queryParameters: {'page': '$page', 'perPage': '$perPage', 'name': '%$searchPhrase%', 'sort': '${sign}name'});
    final response = await http.get(uri);

    if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    List<dynamic> rawDrinkList = responseData['data'];
    // return rawDrinkList.map((jsonObj) => Drink.fromJson(jsonObj)).toList();
    _drinksPagedCache[(page, searchPhrase, alphabetical)] = rawDrinkList.map((jsonObj) => Drink.fromJson(jsonObj)).toList();

    } else {
      _drinksPagedCache[(page, searchPhrase, alphabetical)] = [];
    throw Exception('Failed to load album');
    }
    }
    return _drinksPagedCache[(page, searchPhrase, alphabetical)]!;
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
