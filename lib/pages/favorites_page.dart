import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:market_rate/providers/favorite_groceries_provider.dart';
import 'package:market_rate/providers/favorite_market_provider.dart';

class FavoritePage extends ConsumerStatefulWidget {
  const FavoritePage({super.key});

  @override
  ConsumerState<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends ConsumerState<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    final favoriteGroceries = ref.watch(favoriteGroceriesProvider);
    final favoriteGroceriesList = favoriteGroceries.values.toList();

    print(favoriteGroceriesList);

    final favoriteMarkets = ref.watch(favoriteMarketsProvider);
    final favoriteMarketsList = favoriteMarkets.values.toList();

    print(favoriteMarketsList);

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(
                child: Text('Markets'),
              ),
              Tab(
                child: Text('Groceries'),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                const Center(
                  child: Text('Markets'),
                ),
                const Center(
                  child: Text('Groceries'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
