import 'package:appcohols/ui/views/drink_details_view.dart';
import 'package:flutter/material.dart';
import 'package:appcohols/ui/components/drink_tile.dart';
import 'package:appcohols/data/drink.dart';
import 'package:appcohols/data/drink_fetcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:appcohols/ui/components/errors.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';

class DrinksListView extends StatefulWidget {
  const DrinksListView({super.key});

  @override
  State<DrinksListView> createState() => _DrinksListViewState();
}

class _DrinksListViewState extends State<DrinksListView> {
  List<Drink> allDrinks = [];
  List<Drink> filteredDrinks = [];
  late TextEditingController _searchController;
  bool successFetching = true;
  bool sortedAlphabetically = true;
  String _searchPhrase = '';
  late final _pagingController = PagingController<int, Drink>(
      fetchPage: (pageKey) => DrinkFetcher()
          .fetchDrinks(pageKey, _searchPhrase, sortedAlphabetically),
      getNextPageKey: (state) {
        return state.hasNextPage ? (state.keys?.last ?? 0) + 1 : null;
      });
  final Debouncer _debouncer = Debouncer();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  void filterDrinks(String query) {
    const duration = Duration(milliseconds: 500);
    _debouncer.debounce(
      duration: duration,
      onDebounce: () {
        setState(() {
          _searchPhrase = query;
          _pagingController.refresh();
        });
      },
    );
  }

  void sortDrinks() {
    setState(() {
      sortedAlphabetically = !sortedAlphabetically;
      _pagingController.refresh();
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
            _TopRibbon(
                searchController: _searchController,
                sortedAlphabetically: sortedAlphabetically,
                filterDrinks: filterDrinks,
                sortDrinks: sortDrinks),
            Expanded(
              child: PagingListener(
                  controller: _pagingController,
                  builder: (context, state, fetchNextPage) => _DrinkPagedList(
                      state: state,
                      fetchNextPage: fetchNextPage,
                      itemAction: goToDrink,
                      pagingController: _pagingController)),
            ),
          ],
        ));
  }
}

class _DrinkPagedList extends StatelessWidget {
  const _DrinkPagedList(
      {required this.state,
      required this.fetchNextPage,
      required this.itemAction,
      required this.pagingController});

  final PagingState<int, Drink> state;
  final VoidCallback fetchNextPage;
  final void Function(Drink) itemAction;
  final PagingController<Object, Object> pagingController;

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Drink>.separated(
      state: state,
      fetchNextPage: fetchNextPage,
      builderDelegate: PagedChildBuilderDelegate(
        animateTransitions: true,
        itemBuilder: (context, item, index) => Padding(
            padding: EdgeInsets.all(10),
            child: DrinkTile(
              key: ValueKey(item.id),
              name: item.name,
              imageUrl: item.imageUrl,
              onTap: () => itemAction(item),
            )),
        firstPageErrorIndicatorBuilder: (context) =>
            CustomFirstPageError(pagingController: pagingController),
        newPageErrorIndicatorBuilder: (context) =>
            CustomNewPageError(pagingController: pagingController),
      ),
      separatorBuilder: (context, index) => const SizedBox(),
    );
  }
}

class _TopRibbon extends StatelessWidget {
  const _TopRibbon({
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
