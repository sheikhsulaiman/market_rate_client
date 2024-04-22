import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoriteGroceriesNotifier extends StateNotifier<List<String>> {
  final Box favoriteGroceriesBox = Hive.box('favorite_groceries_box');

  // set initial state to favoriteGroceriesBox's keys

  FavoriteGroceriesNotifier() : super([]) {
    for (var key in favoriteGroceriesBox.keys) {
      state.add(key);
    }
  }

  addFavorite(String id, String name) async {
    state.add(id);
    favoriteGroceriesBox.put(id, name);
  }

  void removeFavorite(String id) {
    state.remove(id);
    favoriteGroceriesBox.delete(id);
  }
}

final favoriteGroceriesProvider =
    StateNotifierProvider<FavoriteGroceriesNotifier, List<String>>((ref) {
  return FavoriteGroceriesNotifier();
});
