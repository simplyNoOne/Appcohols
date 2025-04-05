import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:appcohols/data/drink_fetcher.dart';

class TopRibbon extends StatelessWidget {
  const TopRibbon({
    super.key,
    required this.searchController,
    required this.sortedAlphabetically,
    required this.filterDrinks,
    required this.sortDrinks,
    required this.filterByCategory
  });

  final TextEditingController searchController;
  final bool sortedAlphabetically;
  final ValueChanged<String> filterDrinks;
  final VoidCallback sortDrinks;
  final ValueChanged<String> filterByCategory;

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
          FilterDropdown(
              onChanged: filterByCategory),
          IconButton(
              icon: sortedAlphabetically
                  ? Icon(FontAwesomeIcons.arrowDownAZ)
                  : Icon(FontAwesomeIcons.arrowUpAZ),
              onPressed: sortDrinks)
        ]));
  }
}


class FilterDropdown extends StatefulWidget {

  final ValueChanged<String> onChanged;

  FilterDropdown({
    required this.onChanged
  });
  @override
  _FilterDropdownState createState() => _FilterDropdownState();
}

class _FilterDropdownState extends State<FilterDropdown> {
  String _selectedValue = '';
  late Future<List<String>> _options;

  @override
  void initState() {
    super.initState();
    _options = DrinkFetcher().fetchCategories();
  }


  @override
  Widget build(BuildContext context) {
    return  FutureBuilder<List<String>>(
      future: _options, // Use the future passed in
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while waiting for the future to resolve
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return SizedBox();
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox();
        } else {
          // Successfully fetched the data, build the dropdown
          List<String> options = [''];
          options.addAll(snapshot.data!);

          return DropdownButton<String>(
            value: _selectedValue,
            onChanged: (newValue) {
              setState(() {
                _selectedValue = newValue!;
              });
              widget.onChanged(newValue!);
            },
            items: options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          );
        }
      },
    );
  }
}
