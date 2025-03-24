import 'dart:ui';

class ProductsModel{
  final int productId;
  final String productImage;
  final String productName ;
  final double productPrice;
  final List<String> productImageList;
  final List<String> productSize;
  final List<Color> productColor;
  final String description;

  ProductsModel({
    required this.productId,
    required this.productImage,
    required this.productName,
    required this.productPrice,
    required this.productImageList,
    required this.productSize,
    required this.productColor,
    required this.description,
});
}
