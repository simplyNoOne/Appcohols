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

  bool neverSet = true;
  int lastPage = 1;
  final String apiUrl = "https://cocktails.solvro.pl/api/v1";
  final perPage = 30;
  final Map<(int, String, bool, String), List<Drink>> _drinksPagedCache = {};
  final Map<int, List<Ingredient>> _drinksIngredientsCache = {};
  List<String> _categories = [];

  int getLastPage() {
    return lastPage;
  }

  Future<List<Drink>> fetchDrinks(
      int page, String searchPhrase, bool alphabetical, String category) async {
    print('fetching page $page');
    if (!_drinksPagedCache
        .containsKey((page, searchPhrase, alphabetical, category))) {
      String sign = alphabetical ? '+' : '-';
      Uri uri = Uri.parse('$apiUrl/cocktails');
      if (category == '') {
        uri = uri.replace(queryParameters: {
          'page': '$page',
          'perPage': '$perPage',
          'name': '%$searchPhrase%',
          'sort': '${sign}name'
        });
      } else {
        uri = uri.replace(queryParameters: {
          'page': '$page',
          'perPage': '$perPage',
          'name': '%$searchPhrase%',
          'category': '$category',
          'sort': '${sign}name',
        });
      }
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (neverSet) {
          lastPage = responseData['meta']['lastPage'];
          neverSet = false;
        }
        List<dynamic> rawDrinkList = responseData['data'];
        _drinksPagedCache[(page, searchPhrase, alphabetical, category)] =
            rawDrinkList.map((jsonObj) => Drink.fromJson(jsonObj)).toList();
      } else {
        _drinksPagedCache[(page, searchPhrase, alphabetical, category)] = [];
        throw Exception('Failed to load drinks');
      }
    }
    return _drinksPagedCache[(page, searchPhrase, alphabetical, category)]!;
  }

  Future<List<Ingredient>> fetchIngredientsForDrink(int drinkId) async {
    if (!_drinksIngredientsCache.containsKey(drinkId)) {
      final uri = Uri.parse('$apiUrl/cocktails/$drinkId');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> rawIngredientsList = responseData['data']['ingredients'];
        _drinksIngredientsCache[drinkId] = rawIngredientsList
            .map((jsonObj) => Ingredient.fromJson(jsonObj))
            .toList();
      } else {
        _drinksIngredientsCache[drinkId] = [];
        throw Exception('Failed to load ingredients');
      }
    }
    return _drinksIngredientsCache[drinkId]!;
  }

  Future<List<String>> fetchCategories() async {
    if (_categories.isEmpty) {
      final uri = Uri.parse('$apiUrl/cocktails/categories');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        _categories = (responseData['data'] as List<dynamic>)
            .map((category) =>
                category.toString())
            .toList();
      } else {
        _categories = [];
        throw Exception('Failed to load categories');
      }
    }
    return _categories;
  }
}
