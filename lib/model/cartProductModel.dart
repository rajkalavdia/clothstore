import 'dart:ui';

class CartProductModel {
  int? cartProductId;
  String cartProductImage = "";
  String cartProductName = "";
  String cartProductSize = "";
  Color? cartProductColor;
  int cartProductQuantity = 0;
  double cartProductPrice = 0;

  CartProductModel({
    this.cartProductId,
    this.cartProductImage = "",
    this.cartProductName = "",
    this.cartProductSize = "",
    this.cartProductColor,
    this.cartProductQuantity = 0,
    this.cartProductPrice = 0,
  });

  @override
  String toString() {
    return 'CartProductModel(cartProductId: $cartProductId, cartProductImage: "$cartProductImage", cartProductName: "$cartProductName", cartProductSize: "$cartProductSize", cartProductColor: $cartProductColor, cartProductQuantity: $cartProductQuantity, cartProductPrice: $cartProductPrice)';
  }
}
