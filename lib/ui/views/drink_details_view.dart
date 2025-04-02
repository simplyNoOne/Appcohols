import 'package:flutter/material.dart';
import 'package:appcohols/data/drink.dart';
import 'package:appcohols/data/ingredient.dart';
import 'package:appcohols/data/drink_fetcher.dart';

class DrinkDetailsView extends StatefulWidget {
  const DrinkDetailsView({super.key, required this.drink});

  final Drink drink;

  @override
  State<DrinkDetailsView> createState() => _DrinkDetailsViewState();
}

class _DrinkDetailsViewState extends State<DrinkDetailsView> {
  late Future<List<Ingredient>> futureIngredients;

  @override
  void initState() {
    super.initState();
    futureIngredients =
        DrinkFetcher().fetchIngredientsForDrink(widget.drink.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Appcohols'),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Image.network(widget.drink.imageUrl),
          Container(
              padding: EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: _DrinkDetails(drink: widget.drink),
                    ),
                    FutureBuilder<List<Ingredient>>(
                        future: futureIngredients,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return _IngredientsInfo(
                                ingredientsInfo: snapshot.data!);
                          }
                          // print(futureDrinks.toString());
                          return Text("Sorry, could not fetch ingredients.");
                        })
                  ]))
        ])));
  }
}

class _DrinkDetails extends StatelessWidget {
  const _DrinkDetails({super.key, required this.drink});

  final Drink drink;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        drink.name,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      Text(
        'Drink Category: ${drink.category}',
      ),
      Text(
        'Glass: ${drink.glass}',
      ),
      Padding(
        padding: EdgeInsets.only(top: 5),
        child: Text(
          'Instructions',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      Text(
        drink.instructions,
        textAlign: TextAlign.justify,
      ),
      Padding(
        padding: EdgeInsets.only(top: 5),
        child: Text(
          'Ingredients',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    ]);
  }
}

class _IngredientsInfo extends StatelessWidget {
  const _IngredientsInfo({super.key, required this.ingredientsInfo});

  final List<Ingredient> ingredientsInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ingredientsInfo.map((ingredient) {
        return Text(ingredient.name);
      }).toList(),
    );
  }
}
