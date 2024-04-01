import 'package:flutter_riverpod/flutter_riverpod.dart';

class DivisionsNotifier extends StateNotifier<List<String>> {
  DivisionsNotifier() : super(['dhaka']);

  void setDivisions(List<String> divisions) {
    state = divisions;
  }
}

final divisionsProvider =
    StateNotifierProvider<DivisionsNotifier, List<String>>((ref) {
  return DivisionsNotifier();
});
