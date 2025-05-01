import 'package:clothstore_admin_pannel/model/user/cartProductModel.dart';
import 'package:clothstore_admin_pannel/model/user/ordersModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> setOrdersOnFirebase(OrdersModel orderModel, List<CartProductModel> listOFCartModel) async {
    print("ordersModel in order controller : $orderModel");
    try {
      await _firestore.collection('orders').doc(orderModel.orderId).set(orderModel.toMap(cartProductModelList: listOFCartModel));
    } catch (e) {
      return print("Error in orders set on firebase : $e");
    }
  }
}
