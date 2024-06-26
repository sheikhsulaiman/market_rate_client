import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:market_rate/providers/favorite_groceries_provider.dart';
import 'package:market_rate/providers/favorite_market_provider.dart';
import 'package:market_rate/widgets/grocery_tile.dart';
import 'package:market_rate/widgets/market_tile.dart';
import 'package:market_rate/widgets/skeletons/grocery_tile_skeleton.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoritePage extends ConsumerStatefulWidget {
  const FavoritePage({super.key});

  @override
  ConsumerState<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends ConsumerState<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    final favoriteGroceries = ref.watch(favoriteGroceriesProvider);
    final favoriteGroceriesList = favoriteGroceries.toList();
    final favoriteMarkets = ref.watch(favoriteMarketsProvider);
    final favoriteMarketsList = favoriteMarkets.toList();
    final futureMarkets =
        Supabase.instance.client.from('bigmarkets').select("id,name,division");

    final futureGroceries = Supabase.instance.client
        .from('groceries')
        .select("id, name, unit, image_url");

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
                Center(
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: FutureBuilder(
                            future: futureMarkets,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return ListView.builder(
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    return const GroceryTileSkeleton();
                                  },
                                );
                              }

                              if (snapshot.hasError) {
                                return const Text(
                                    'Network error! Please try again later.');
                              }

                              final data = snapshot.data as List<dynamic>;

                              final filteredData = data
                                  .where((element) => favoriteMarketsList
                                      .contains(element['id']))
                                  .toList();

                              if (filteredData.isEmpty) {
                                return const Center(
                                    child: Text('No favorite markets yet'));
                              }

                              return ListView.builder(
                                itemCount: filteredData.length,
                                itemBuilder: (context, index) {
                                  return MarketTile(
                                    id: filteredData[index]['id'],
                                    marketName: filteredData[index]['name'],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: FutureBuilder(
                    future: futureGroceries,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return const GroceryTileSkeleton();
                          },
                        );
                      }

                      if (snapshot.hasError) {
                        return const Text(
                            'Network error! Please try again later.');
                      }

                      final data = snapshot.data as List<dynamic>;

                      final filteredData = data
                          .where((element) =>
                              favoriteGroceriesList.contains(element['id']))
                          .toList();

                      if (filteredData.isEmpty) {
                        return const Center(
                            child: Text('No favorite groceries yet'));
                      }

                      return ListView.builder(
                        itemCount: filteredData.length,
                        itemBuilder: (context, index) {
                          final item = filteredData[index];
                          return GroceryTile(
                            id: item['id'],
                            groceryName: item['name'],
                            unit: item['unit'],
                            groceryImageUrl: item['image_url'],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
