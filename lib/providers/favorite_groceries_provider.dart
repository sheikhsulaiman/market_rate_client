import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoriteGroceriesNotifier extends StateNotifier<Map<String, String>> {
  FavoriteGroceriesNotifier() : super({});

  var favoriteGroceriesBox = Hive.openBox('favorite_groceries_box');

  Future<void> addFavorite(String id, String name) async {
    state[id] = name;
    await favoriteGroceriesBox.then((value) => value.put(id, name));
  }

  void removeFavorite(String id) {
    state.remove(id);
    favoriteGroceriesBox.then((value) => value.delete(id));
  }
}

final favoriteGroceriesProvider =
    StateNotifierProvider<FavoriteGroceriesNotifier, Map<String, String>>(
        (ref) {
  return FavoriteGroceriesNotifier();
});
