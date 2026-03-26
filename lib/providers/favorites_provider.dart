import 'package:flutter/foundation.dart';

class FavoritesProvider extends ChangeNotifier {
  final Set<String> _favoriteIds = {};

  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);

  bool isFavorite(String drinkId) => _favoriteIds.contains(drinkId);

  void toggle(String drinkId) {
    if (_favoriteIds.contains(drinkId)) {
      _favoriteIds.remove(drinkId);
    } else {
      _favoriteIds.add(drinkId);
    }
    notifyListeners();
  }
}
