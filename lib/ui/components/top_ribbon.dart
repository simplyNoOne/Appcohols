import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TopRibbon extends StatelessWidget {
  const TopRibbon({
    super.key,
    required this.searchController,
    required this.sortedAlphabetically,
    required this.filterDrinks,
    required this.sortDrinks,
  });

  final TextEditingController searchController;
  final bool sortedAlphabetically;
  final ValueChanged<String> filterDrinks;
  final VoidCallback sortDrinks;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Expanded(
              child: SearchBar(
                controller: searchController,
                onChanged: filterDrinks,
                hintText: 'Search for drink',
              )),
          IconButton(
              icon: sortedAlphabetically
                  ? Icon(FontAwesomeIcons.arrowDownAZ)
                  : Icon(FontAwesomeIcons.arrowUpAZ),
              onPressed: sortDrinks)
        ]));
  }
}
