import 'dart:math';

import 'package:clotstoreapp/backend/provider/ordersList/addOrderProvider.dart';
import 'package:clotstoreapp/model/ordersModel.dart';
import 'package:clotstoreapp/navigation/orderCostData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../backend/provider/cart/cart-provider.dart';
import '../../model/cartProductModel.dart';

class CheckoutScreen extends StatefulWidget {
  static const routeName = '/CheckoutScreen';

  const CheckoutScreen({
    super.key,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late CartProvider cartProvider;
  late OrderProvider orderProvider;
  late List<CartProductModel> cartProduct;

  String? selectedPaymentMethod;
  bool isDropdownOpen = false;
  TextEditingController shippingAddressController = TextEditingController();

  final List<String> paymentMethods = [
    'Credit Card',
    'Debit Card',
    'UPI Id',
    'UPI Apps',
    'Cash on Delivery',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cartProvider = context.read<CartProvider>();
    cartProduct = cartProvider.cartProductsList;
    orderProvider = context.read<OrderProvider>();
  }

  Future<void> addToOrder({required List<CartProductModel> listOfModel}) async {
    final _random = Random();
    int next(int min, int max) => min + _random.nextInt(max - min);

    print("cartProduct in checkoutscreen from provider : $cartProduct:");
    print("cartProduct passed from another screen : $listOfModel:");

    OrdersModel ordersModel = OrdersModel(
      itemsCount: cartProduct.length,
      orderId: next(1000, 9999),
      cartProductModelList: listOfModel,
      shippingAddress:shippingAddressController.text,
      paymentMethod: selectedPaymentMethod!,
    );
    orderProvider.addToOrder(ordersModel);

    Navigator.pushNamed(context, '/PlaceOrderScreen');

    cartProduct.removeRange(0, cartProduct.length);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(), // Smooth scrolling
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              getHeaderWidget(),
              getSomePurchaseDataWidget(),
              getPurchaseSummaryWidget(),
              checkOutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getHeaderWidget() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 50,
            width: 50,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Colors.grey[300]),
            child: Image.asset(
              'asset/icons/arrowleftBlack.png',
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.sizeOf(context).width / 5.5,
        ),
        Text(
          'Checkout',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget getSomePurchaseDataWidget() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Shipping Address',
              labelStyle: TextStyle(color: Colors.black38),
              hintText: 'Add Shipping Address',
              hintStyle: TextStyle(fontSize: 20, color: Colors.black38),
              filled: true,
              fillColor: Colors.grey[300],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              suffixIcon: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Image.asset(
                  'asset/icons/arrowrightBlack.png',
                  height: 20,
                ),
              ),
            ),
            controller: shippingAddressController,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 330),
          child: DropdownButtonFormField<String>(
            value: selectedPaymentMethod,
            dropdownColor: Colors.white,
            decoration: InputDecoration(
              labelText: 'Payment Method',
              labelStyle: TextStyle(color: Colors.black),
              filled: true,
              fillColor: Colors.grey[300],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              suffixIcon: Image.asset(
                'asset/icons/arrowrightBlack.png',
                height: 20,
              ),
            ),
            isExpanded: true,
            hint: Text('Add Payment Method', style: TextStyle(fontSize: 20)),
            onChanged: (String? newValue) {
              setState(() {
                selectedPaymentMethod = newValue;
              });
            },
            onTap: () {
              setState(() {
                isDropdownOpen = !isDropdownOpen;
              });
            },
            items: paymentMethods.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(fontSize: 18)),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget getPurchaseSummaryWidget() {
    final cartProductListArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final cartSummery = cartProductListArgs["orderCostData"];
    return Column(
      children: [
        getProductSummaryWidget(title: "Product Total", value: '\$${cartSummery.productTotal}'
            // '\$$productTotal',
            ),
        getProductSummaryWidget(title: "Shipping Cost", value: '\$${cartSummery.shippingCost}'
            // '\$$shippingCost',
            ),
        getProductSummaryWidget(title: "Tax", value: '\$${cartSummery.tax}'
            // '\$$tax',
            ),
        getProductSummaryWidget(title: "Order Total", value: '\$${cartSummery.orderTotal}'
            // '\$$orderTotal',
            ),
      ],
    );
  }

  Widget getProductSummaryWidget({required String title, required String value}) {
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

  Widget checkOutButton() {
    final cartProductListArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    List<CartProductModel> cartProductModels = cartProductListArgs["cartProductModelList"];
    return InkWell(
      onTap: () {
        addToOrder(listOfModel: cartProductModels);
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
