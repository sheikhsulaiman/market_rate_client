import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoriteMarketsNotifier extends StateNotifier<List<int>> {
  var favoriteMarketBox = Hive.box('favorite_markets_box');
  FavoriteMarketsNotifier() : super([]) {
    for (var key in favoriteMarketBox.keys) {
      state.add(key);
    }
  }

  Future<void> addFavorite(int id, String name) async {
    state.add(id);
    favoriteMarketBox.put(id, name);
  }

  void removeFavorite(int id) {
    state.remove(id);
    favoriteMarketBox.delete(id);
  }
}

final favoriteMarketsProvider =
    StateNotifierProvider<FavoriteMarketsNotifier, List<int>>((ref) {
  return FavoriteMarketsNotifier();
});
