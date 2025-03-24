import 'package:clotstoreapp/model/cartProductModel.dart';
import 'package:flutter/widgets.dart';

class OrdersModel {
   int? orderId;
   int itemsCount = 0;
   String shippingAddress = "";
   String paymentMethod = "";
   List<CartProductModel> checkOutOrdersList;

  OrdersModel({
    this.itemsCount = 0 ,
    this.orderId,
    this.shippingAddress = "",
    this.paymentMethod = "",
    List<CartProductModel>? cartProductModelList, // Nullable parameter
  }) : checkOutOrdersList = cartProductModelList ?? [];

   @override
   String toString() {
     return 'OrdersModel(orderId: $orderId, itemsCount: $itemsCount, shippingAddress: "$shippingAddress", paymentMethod: "$paymentMethod", cartProductModelList: $checkOutOrdersList)';
   }
}
