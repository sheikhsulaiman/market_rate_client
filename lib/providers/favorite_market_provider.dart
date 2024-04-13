import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoriteMarketsNotifier extends StateNotifier<Map<String, String>> {
  FavoriteMarketsNotifier() : super({});

  var favoriteMarketBox = Hive.openBox('favorite_markets_box');

  Future<void> addFavorite(String id, String name) async {
    state[id] = name;
    await favoriteMarketBox.then((value) => value.put(id, name));
  }

  void removeFavorite(String id) {
    state.remove(id);
    favoriteMarketBox.then((value) => value.delete(id));
  }
}

final favoriteMarketsProvider =
    StateNotifierProvider<FavoriteMarketsNotifier, Map<String, String>>((ref) {
  return FavoriteMarketsNotifier();
});
