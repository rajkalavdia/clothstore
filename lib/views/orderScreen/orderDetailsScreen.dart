import 'package:clothstore_admin_pannel/model/user/ordersModel.dart';
import 'package:clotstoreapp/backend/provider/cart/cart-provider.dart';
import 'package:clotstoreapp/backend/provider/ordersList/addOrderProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';

class OrderDetailsScreen extends StatefulWidget {
  static const String routeName = '/OrderDetailsScreen';

  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  static List<String> step = <String>[
    'Delivered',
    'Shipped',
    'Order Confirmed',
    'Order Placed',
  ];
  static List<String> date = <String>[
    '28 May',
    '29 May',
    '30 May',
    '31 May',
  ];

  late OrderProvider orderProvider;
  late CartProvider cartProvider;

  @override
  Widget build(BuildContext context) {
    orderProvider = context.watch<OrderProvider>();
    cartProvider = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getHeader(),
            _getOrderDetailsTimeline(),
            _orderItems(),
            getShippingAddress(),
            getPaymentMethod(),
          ],
        ),
      ),
    );
  }


  Widget getHeader() {
    final orderIdArgs = ModalRoute.of(context)!.settings.arguments as OrdersModel;
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                Colors.grey[300],
              ),
              fixedSize: WidgetStatePropertyAll(
                Size.fromRadius(30),
              ),
            ),
            icon: Image.asset(
              'asset/icons/arrowleftBlack.png',
              height: 25,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 15,
          ),
          child: Text(
            'Order #' + '${orderIdArgs.orderId}',
            style: TextStyle(fontSize: 25),
          ),
        ),
      ],
    );
  }

  Widget _getOrderDetailsTimeline() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: FixedTimeline.tileBuilder(
        theme: TimelineThemeData(
          nodePosition: 0.1,
          indicatorTheme: IndicatorThemeData(
            color: Colors.deepPurpleAccent,
            size: 20,
          ),
          connectorTheme: ConnectorThemeData(
            color: Colors.deepPurpleAccent,
            thickness: 3,
          ),
        ),
        builder: TimelineTileBuilder(
          indicatorBuilder: (_, index) {
            if (index == 0) {
              return Indicator.dot(
                size: 30,
                child: Container(
                  child: Icon(
                    Icons.done,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              );
            }
            return Indicator.outlined(
              borderWidth: 3,
              size: 30,
              backgroundColor: Colors.white,
            );
          },
          startConnectorBuilder: (_, index) => Connector.solidLine(),
          endConnectorBuilder: (_, index) {
            if (index == (step.length - 1)) {
              return Connector.transparent();
            }
            return Connector.solidLine();
          },
          contentsBuilder: (_, index) {
            return Padding(
              padding: EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      step[index].toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      date[index].toString(),
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            );
          },
          itemExtentBuilder: (_, index) => 100,
          nodeItemOverlapBuilder: (_, index) => true,
          itemCount: step.length,
        ),
      ),
    );
  }

  Widget _orderItems() {
    // final List<OrdersModel> cartProductModelList = orderProvider.ordersList;
    final orderIdArgs = ModalRoute.of(context)!.settings.arguments as OrdersModel;
    return ListView.builder(
      itemCount: orderIdArgs.checkOutOrdersList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
              height: 70,
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Image.asset(orderIdArgs.checkOutOrdersList[index].cartProductImage),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 10),
                        child: Text(orderIdArgs.checkOutOrdersList[index].cartProductName),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Size - ',
                                    style: TextStyle(
                                      color: Colors.black38,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: orderIdArgs.checkOutOrdersList[index].cartProductSize,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Color - ',
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 15,
                              ),
                            ),
                            Container(
                              height: 20,
                              width: 20,
                              child: Text(orderIdArgs.checkOutOrdersList[index].cartProductColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '\$${orderIdArgs.checkOutOrdersList[index].cartProductPrice * orderIdArgs.checkOutOrdersList[index].cartProductQuantity}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        orderIdArgs.checkOutOrdersList[index].cartProductQuantity.toString(),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget getShippingAddress() {
    final orderIdArgs = ModalRoute.of(context)!.settings.arguments as OrdersModel;
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Container(
          child: Row(
            children: [
              Text(
                'Shipping Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
      Container(
        height: 80,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Text(
                orderIdArgs.shippingAddress,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget getPaymentMethod() {
    final orderIdArgs = ModalRoute.of(context)!.settings.arguments as OrdersModel;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Container(
            child: Row(
              children: [
                Text(
                  'Payment Method',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 80,
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              child: Row(
                children: [
                  Text(
                    orderIdArgs.paymentMethod,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
