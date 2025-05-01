import 'dart:core';

import 'package:clothstore_admin_pannel/model/user/cartProductModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../backend/provider/cart/cart-provider.dart';
import '../../navigation/orderCostData.dart';

class CartProductList extends StatefulWidget {
  static const routeName = '/CartProductList';

  const CartProductList({super.key});

  @override
  State<CartProductList> createState() => _CartProductListState();
}

class _CartProductListState extends State<CartProductList> {
  // List<CartProductModel> cartProduct = CartProductModelList.cartProductsList;
  OrderCostData orderCostData = OrderCostData(0, 5, 10, 0);
  late CartProvider cartProvider;
  late List<CartProductModel> cartProduct;
  late List<CartProductModel> storedCartProduct; // Independent stored list

  @override
  void initState() {
    super.initState();

    cartProvider = context.read<CartProvider>();

    print("Cart Products Length:${cartProvider.cartProductsList.length}");

    cartProduct = cartProvider.cartProductsList;
    storedCartProduct = List.from(cartProduct);
  }

  double calculateSumOfCartProducts() {
    orderCostData.productTotal = 0;
    orderCostData.orderTotal = 0;
    for (var product in cartProduct) {
      orderCostData.productTotal += product.cartProductPrice * product.cartProductQuantity;
    }
    orderCostData.orderTotal += orderCostData.productTotal + orderCostData.shippingCost + orderCostData.tax;
    return orderCostData.productTotal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            getHeaderWidget(),
            removeProducts(),
            getCartProducts(),
            getPurchaseSummarySWidget(),
            getCouponCode(),
            checkOutButton(),
          ],
        ),
      ),
    );
  }

  Widget removeProducts() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: InkWell(
            onTap: () {
              setState(() {
                cartProduct.removeRange(0, cartProduct.length);
              });
            },
            child: Text(
              'Remove All',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget getCartProducts() {
    return Flexible(
      child: ListView.builder(
        itemCount: cartProduct.length,
        itemBuilder: (context, index) {
          final _model = cartProduct[index];
          return Container(
            height: 70,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    _model.cartProductImage,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 0, 10),
                      child: Text(_model.cartProductName),
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
                                  text: _model.cartProductSize,
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
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color(
                                int.parse(
                                  _model.cartProductColor,
                                ),
                              ),
                            ),
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
                      '₹${_model.cartProductPrice * _model.cartProductQuantity}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _model.cartProductQuantity++;
                              calculateSumOfCartProducts();
                            });
                          },
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Colors.deepPurpleAccent,
                            ),
                            child: Image.asset(
                              'asset/icons/quantityIncrease.png',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          _model.cartProductQuantity.toString(),
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            if (_model.cartProductQuantity > 1) {
                              setState(() {
                                _model.cartProductQuantity--;
                                calculateSumOfCartProducts();
                              });
                            } else {
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Product Delete'),
                                    content: const Text(
                                      'Are you sure want to delete this product',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('No'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Yes'),
                                        onPressed: () {
                                          cartProvider.cartProductsList.removeWhere((item) {
                                            return _model.cartProductId == item.cartProductId;
                                          });
                                          setState(() {});
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Colors.deepPurpleAccent,
                            ),
                            child: Image.asset(
                              'asset/icons/quantityDecrease.png',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget getPurchaseSummarySWidget() {
    return Column(
      children: [
        getProductSummaryItemWidget(
          title: "Product Total",
          value: '₹${calculateSumOfCartProducts()}',
        ),
        getProductSummaryItemWidget(
          title: "Shipping Cost",
          value: '₹${orderCostData.shippingCost}',
        ),
        getProductSummaryItemWidget(
          title: "Tax",
          value: '₹${orderCostData.tax}',
        ),
        getProductSummaryItemWidget(
          title: "Order Total",
          value: '₹${orderCostData.orderTotal}',
        ),
      ],
    );
  }

  Widget getProductSummaryItemWidget({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.black38, fontSize: 18),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget getHeaderWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
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
                Size.fromRadius(25),
              ),
            ),
            icon: Image.asset(
              'asset/icons/arrowleftBlack.png',
              height: 25,
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.sizeOf(context).width / 4,
        ),
        Text(
          'Cart',
          style: TextStyle(fontSize: 25),
        ),
      ],
    );
  }

  Widget getCouponCode() {
    return Container(
      height: 50,
      margin: EdgeInsets.fromLTRB(15, 15, 15, 10),
      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              'asset/icons/discountShape.png',
              height: 35,
            ),
          ),
          Expanded(
            child: Text(
              'Enter Coupon Code',
              style: TextStyle(
                color: Colors.black38,
              ),
            ),
          ),
          Container(
            height: 40,
            width: 40,
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              color: Colors.deepPurpleAccent,
            ),
            child: Image.asset('asset/icons/arrowrightwhite.png'),
          ),
        ],
      ),
    );
  }

  Widget checkOutButton() {
    return InkWell(
      onTap: () {
        if (cartProduct.length == 0) {
          const snackBar = SnackBar(content: Text('Please Add a Product'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          Navigator.pushNamed(context, '/CheckoutScreen', arguments: <String, dynamic>{
            "orderCostData": OrderCostData(
              calculateSumOfCartProducts(),
              orderCostData.shippingCost,
              orderCostData.tax,
              orderCostData.orderTotal,
            ),
            "cartProductModelList": storedCartProduct,
            'totalAmount': orderCostData.orderTotal
          });
        }
      },
      child: Container(
        height: 50,
        margin: EdgeInsets.fromLTRB(15, 15, 15, 10),
        decoration: BoxDecoration(
          color: Colors.deepPurpleAccent,
          borderRadius: BorderRadius.circular(35),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CheckOut',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
