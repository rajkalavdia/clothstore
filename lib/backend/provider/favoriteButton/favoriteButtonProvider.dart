import 'package:flutter/cupertino.dart';

class FavoriteButtonProvider extends ChangeNotifier {
  final Map<int, bool> _favorites = {}; // Track favorites using a map

  bool isFavorite(int productId) => _favorites[productId] ?? true;

  void toggleFavorite(int productId) {
    _favorites[productId] = !isFavorite(productId);
    notifyListeners();
  }
}
