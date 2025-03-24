import 'package:clotstoreapp/model/cartProductModel.dart';
import 'package:flutter/foundation.dart';

class CartProvider extends ChangeNotifier {
  List<CartProductModel> cartProductsList = <CartProductModel>[];

  void addToCart(CartProductModel product) {
    cartProductsList.add(product);
    notifyListeners();
  }

  void updateCart() {
    notifyListeners();
  }
}