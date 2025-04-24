import 'package:clothstore_admin_pannel/model/productModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../provider/product/productProvider.dart';

class ProductController {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  final int _limit = 10;

  Future<void> getProductFromFirebase(ProductProvider provider) async {
    if (provider.isLoading || !provider.hashMore) return;
    provider.startLoading();
    try {
      List<ProductModel> productList = <ProductModel>[];

      print("productProvider.startLoading() : ${provider.isLoading}");

      Query<Map<String, dynamic>> query = _firebase.collection('products').limit(_limit);
      print("query : $query");
      if (provider.lastDocument != null) {
        query = query.startAfterDocument(provider.lastDocument!);
        print("query : $query");
      }

      QuerySnapshot<Map<String, dynamic>> productDoc = await query.get();
      print(" productDoc : $productDoc");
      if (productDoc.docs.isNotEmpty) {
        provider.updateLastDocument(productDoc.docs.last);
        print(" productDoc.docs.last : ${productDoc.docs.last}");
        for (var model in productDoc.docs) {
          List<String> productImagesUrlList = <String>[];

          final data = model.data();

          print("data : $data");

          if (data['productImages'] != null) {
            if (data['productImages'] is List) {
              // Explicitly cast each element to String
              productImagesUrlList = List<String>.from((data['productImages'] as List).map((item) => item?.toString() ?? ''));
            } else if (data['productImages'] is String) {
              // If it's a single string for some reason
              productImagesUrlList = [data['productImages']];
            }
          }
          final product = ProductModel.fromMap(data);
          product.productImages = productImagesUrlList;
          productList.add(product);
        }
        provider.setProductList(productList: productList);

        print("product list in product Controller : $productList");

        productList.clear();

        print('product provider list length Controller : ${provider.productModelList.length}');
      } else {
        provider.setHasMore(false);
      }
    } catch (e, s) {
      return print("Error of product model get In firebase: $e, $s");
    }
    provider.stopLoading();
  }
}
