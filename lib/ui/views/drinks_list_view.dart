import 'package:appcohols/ui/views/drink_details_view.dart';
import 'package:flutter/material.dart';
import 'package:appcohols/ui/components/drink_tile.dart';
import 'package:appcohols/data/drink.dart';
import 'package:appcohols/data/drink_fetcher.dart';

class DrinksListView extends StatefulWidget {
  const DrinksListView({super.key});

  @override
  State<DrinksListView> createState() => _DrinksListViewState();
}

class _DrinksListViewState extends State<DrinksListView> {
  late Future<List<Drink>> futureDrinks;

  @override
  void initState() {
    super.initState();
    futureDrinks = DrinkFetcher().fetchDrinks(1, 25);
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
        appBar: AppBar(
          title: const Text('Appcohols'),
        ),
        body: FutureBuilder<List<Drink>>(
            future: futureDrinks,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final drink = snapshot.data![index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: DrinkTile(
                            name: drink.name,
                            imageUrl: drink.imageUrl,
                            onTap: () => goToDrink(drink)),
                      );
                    });
              }
            }));
  }
}
