import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: TabBarView(
        children: [
          Center(
            child: Text('Markets'),
          ),
          Center(
            child: Text('Groceries'),
          ),
        ],
      ),
    );
  }
}
