import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:market_rate/providers/favorite_groceries_provider.dart';
import 'package:market_rate/providers/favorite_market_provider.dart';
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
    final favoriteGroceriesList = favoriteGroceries.keys.toList();
    final favoriteMarkets = ref.watch(favoriteMarketsProvider);
    final favoriteMarketsList = favoriteMarkets.keys.toList();
    final future =
        Supabase.instance.client.from('bigmarkets').select("id,name,division");

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
                            future: future,
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
                                return Text('Error: ${snapshot.error}');
                              }

                              final data = snapshot.data as List<dynamic>;

                              final filteredData = data
                                  .where((element) => favoriteMarketsList
                                      .contains(element['id']))
                                  .toList();

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
