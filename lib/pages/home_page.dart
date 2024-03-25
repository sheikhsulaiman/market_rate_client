import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:market_rate/pages/favorites_page.dart';
import 'package:market_rate/pages/groceries_page.dart';
import 'package:market_rate/pages/markets_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const List<String> _titles = ["Markets", "Groceries", "Favorites"];
  static const List<Widget> _widgetOption = [
    MarketsPage(),
    GroceriesPage(),
    FavoritePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_titles.elementAt(_selectedIndex)),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color:
                  Theme.of(context).colorScheme.inversePrimary.withOpacity(.5),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor:
                  Theme.of(context).colorScheme.primary.withOpacity(.1),
              hoverColor: Theme.of(context).colorScheme.primary.withOpacity(.1),
              gap: 8,
              activeColor: Theme.of(context).colorScheme.primary,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor:
                  Theme.of(context).colorScheme.primary.withOpacity(.1),
              color: Colors.black,
              tabs: [
                GButton(
                  icon: Icons.storefront_outlined,
                  text: 'Markets',
                  iconColor: Theme.of(context).colorScheme.secondary,
                ),
                GButton(
                  icon: Icons.shopping_bag_outlined,
                  text: 'Groceries',
                  iconColor: Theme.of(context).colorScheme.secondary,
                ),
                GButton(
                  icon: Icons.favorite_border_outlined,
                  text: 'Favorites',
                  iconColor: Theme.of(context).colorScheme.secondary,
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
      body: _widgetOption.elementAt(_selectedIndex),
    );
  }
}
