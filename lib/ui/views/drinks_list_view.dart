import 'package:appcohols/ui/views/drink_details_view.dart';
import 'package:flutter/material.dart';
import 'package:appcohols/ui/components/drink_tile.dart';
import 'package:appcohols/data/drink.dart';
import 'package:appcohols/data/drink_fetcher.dart';
import 'package:appcohols/ui/app_theme.dart';

class DrinksListView extends StatefulWidget {
  const DrinksListView({super.key});

  @override
  State<DrinksListView> createState() => _DrinksListViewState();
}

class _DrinksListViewState extends State<DrinksListView> {
  List<Drink> allDrinks = [];
  List<Drink> filteredDrinks = [];
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    fetchDrinks();
  }

  Future<void> fetchDrinks() async {
    try {
      List<Drink> drinks = await DrinkFetcher().fetchDrinks(1, 25);
      setState(() {
        allDrinks = drinks;
        filteredDrinks = drinks;
      });
    } catch (e) {
      print("Error fetching drinks: $e");
    }
  }

  // Method to filter the drinks based on the search query
  void filterDrinks(String query) {
    final filtered = allDrinks.where((drink) {
      final nameLower = drink.name.toLowerCase();
      final searchLower = query.toLowerCase();
      return nameLower.contains(searchLower); // Filtering logic
    }).toList();

    setState(() {
      filteredDrinks = filtered;
    });
  }

  goToDrink(Drink drink) => {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DrinkDetailsView(drink: drink),
        ))
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColorLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Appcohols',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              controller: _searchController,
              onChanged: filterDrinks,
              hintText: 'Search for drink',
            ),
          ),
          Expanded(
            child: _DrinkList(
              drinks: filteredDrinks, // Use filtered drinks here
              goToDrink: goToDrink,
            ),
          ),
        ],
      ),
    );
  }
}

class _DrinkList extends StatelessWidget {
  const _DrinkList({
    super.key,
    required this.drinks,
    required this.goToDrink,
  });

  final List<Drink> drinks;
  final void Function(Drink) goToDrink;

  @override
  Widget build(BuildContext context) {
    if (drinks.isEmpty) {
      return const Center(child: Text('No drinks available.'));
    }
    return ListView.builder(
      itemCount: drinks.length,
      itemBuilder: (context, index) {
        final drink = drinks[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: DrinkTile(
            name: drink.name,
            imageUrl: drink.imageUrl,
            onTap: () => goToDrink(drink),
          ),
        );
      },
    );
  }
}
