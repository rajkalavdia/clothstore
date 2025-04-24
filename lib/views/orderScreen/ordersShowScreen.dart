import 'package:clotstoreapp/backend/provider/ordersList/addOrderProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class OrdersShowScreen extends StatefulWidget {
  static const String routeName = '/OrdersShowScreen';
  const OrdersShowScreen({super.key});

  @override
  State<OrdersShowScreen> createState() => _OrdersShowScreenState();
}

class _OrdersShowScreenState extends State<OrdersShowScreen> {
  static List<String> orderStatusType = [
    'Processing',
    'Shipped',
    'Delivered',
    'Returned',
    'Cancelled',
  ];

  late OrderProvider addOrderProvider;

  @override
  Widget build(BuildContext context) {
    addOrderProvider = context.watch<OrderProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            getHeader(),
            getAllOrdersList(),
          ],
        ),
      ),
    );
  }
  Widget getHeader(){
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Orders',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Widget getOrderStatusTyped(){
  //   return Container(
  //     height: 46,
  //     padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
  //     child: ListView.builder(
  //       itemCount: orderStatusType.length,
  //       scrollDirection: Axis.horizontal,
  //       itemBuilder: (context, index) {
  //         return Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 1.5),
  //           child: ElevatedButton(
  //             onPressed: () {},
  //             style: ButtonStyle(
  //               foregroundColor: WidgetStateProperty.all(Colors.black),
  //               backgroundColor: WidgetStateProperty.all(Colors.grey[300]),
  //             ),
  //             child: Text(orderStatusType[index]),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget getAllOrdersList(){
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: addOrderProvider.ordersList.length,
        itemBuilder: (context, index) {
          final _model = addOrderProvider.ordersList[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: (){
                  Navigator.pushNamed(context, '/OrderDetailsScreen',
                    arguments: _model
                  );
                },
                child: Container(
                  height: 80,
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      Image.asset(
                        'asset/icons/orderIcon.png',
                        height: 45,
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Order #' + '${_model.orderId}',
                              style: TextStyle(
                                  fontSize: 20
                              ),
                            ),
                            Text('${_model.itemsCount}' + 'items'),
                          ],
                        ),
                      ),
                      Image.asset('asset/icons/arrowrightBlack.png' , height: 35,),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget orderEmptyScreen(){
    return Column(
      children: [
        Image.asset(
          'asset/images/cart/shoppingcart.png',
          height: 100,
          width: 100,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'No Orders Yet',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: 60,
          width: 200,
          child: ElevatedButton(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(Colors.white),
              backgroundColor: WidgetStateProperty.all(Colors.deepPurpleAccent),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/CategoriesScreen');
            },
            child: Text(
              'Explore Catagories',
              style: TextStyle(
                  fontSize: 15
              ),
            ),
          ),
        )
      ],
    );
  }
}
