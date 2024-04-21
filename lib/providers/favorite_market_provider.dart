import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoriteMarketsNotifier extends StateNotifier<Map<int, String>> {
  FavoriteMarketsNotifier() : super({});

  var favoriteMarketBox = Hive.openBox('favorite_markets_box');

  Future<void> addFavorite(int id, String name) async {
    state[id] = name;
    await favoriteMarketBox.then((value) => value.put(id, name));
  }

  void removeFavorite(int id) {
    state.remove(id);
    favoriteMarketBox.then((value) => value.delete(id));
  }
}

final favoriteMarketsProvider =
    StateNotifierProvider<FavoriteMarketsNotifier, Map<int, String>>((ref) {
  return FavoriteMarketsNotifier();
});
