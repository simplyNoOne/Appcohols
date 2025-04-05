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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          widget.drink.name,
                          style: Theme.of(context).textTheme.headlineLarge,
                        )),
                    FutureBuilder<List<Ingredient>>(
                        future: futureIngredients,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return _IngredientsInfo(
                                ingredientsInfo: snapshot.data!);
                          }
                          return Text("Sorry, could not fetch ingredients.");
                        }),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: _DrinkDetails(drink: widget.drink),
                    )
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
        '${drink.category}',
      ),
      Text(
        'Served in ${drink.glass.toLowerCase()}.',
      ),
      Padding(
        padding: EdgeInsets.only(top: 15),
        child: Text(
          'Instructions',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      Text(
        drink.instructions,
        textAlign: TextAlign.justify,
      )
    ]);
  }
}

class _IngredientsInfo extends StatelessWidget {
  const _IngredientsInfo({super.key, required this.ingredientsInfo});

  final List<Ingredient> ingredientsInfo;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Enable horizontal scrolling
        child: Row(
          children: ingredientsInfo.map((ingredient) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                // Make it oval by giving a high border radius
                border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 2), // Border color and width
              ),
              child: Text(
                ingredient.name,
              ),
            );
          }).toList(),
        ));
  }
}
