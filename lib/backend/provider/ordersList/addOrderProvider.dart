
import 'package:clotstoreapp/model/ordersModel.dart';
import 'package:flutter/cupertino.dart';

class OrderProvider extends ChangeNotifier{
  List<OrdersModel> ordersList = <OrdersModel>[];

  void addToOrder(OrdersModel orders){
    ordersList.add(orders);
    notifyListeners();
  }


}