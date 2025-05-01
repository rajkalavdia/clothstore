import 'package:clothstore_admin_pannel/model/user/ordersModel.dart';
import 'package:clotstoreapp/backend/provider/ordersList/addOrderProvider.dart';
import 'package:clotstoreapp/backend/provider/userProvider/userProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserControllerInUserApp {
  FirebaseFirestore _firebase = FirebaseFirestore.instance;

  Future<void> setOrdersIdOnUserFirebase(String orderId, UserProviderInUserApp UserProvider) async {
    final userDocRef = await _firebase.collection('users').doc(UserProvider.user!.uid);

    final userDocument = await userDocRef.get();

    if (userDocument.exists) {
      List<String> userOrderList = userDocument.data()?['orderList'] ?? [];

      await userDocRef.update({
        'ordersList': FieldValue.arrayUnion([orderId])
      });
    }
  }

  Future<void> getOrderFromFirebase(UserProviderInUserApp userProvider, OrderProvider orderProvider) async {
    QuerySnapshot<Map<String, dynamic>> query = await _firebase.collection('orders').where('purchasedBY', isEqualTo: userProvider.user!.uid).get();

    List<OrdersModel> tempList = [];
    if (query.docs.isNotEmpty) {
      for (var model in query.docs) {
        OrdersModel ordersModel = OrdersModel.fromMap(model.data());
        tempList.add(ordersModel);
        // print(" order model in controller : ${ordersModel.productList}");
      }
      orderProvider.ordersList = tempList;
    }
  }
}
