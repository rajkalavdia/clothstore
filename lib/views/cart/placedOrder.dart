import 'package:clotstoreapp/backend/provider/bottomNavBar/BottomNavBarProvider.dart';
import 'package:clotstoreapp/views/homeScreen/screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaceOrderScreen extends StatelessWidget {
  static const routeName = '/PlaceOrderScreen';

  PlaceOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            showImage(),
            showPlacedOrder(context),
          ],
        ),
      ),
    );
  }
  Widget showImage() {
    return Flexible(
      child: Image.asset('asset/images/cart/placed_order.png'),
    );
  }

  Widget showPlacedOrder(BuildContext context) {
    // final BottomNavBarProvider bottomNavBarProvider = Provider.of<BottomNavBarProvider>(context);

    BottomNavBarProvider bottomNavBarProvider = context.watch<BottomNavBarProvider>();

    return Container(
      height: MediaQuery.sizeOf(context).height / 2.2,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
          bottom: Radius.zero,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              SizedBox(
                // height: MediaQuery.sizeOf(context).height/5,
                width: MediaQuery.sizeOf(context).width / 5,
              ),
              Flexible(
                child: Text(
                  'Order Placed Successfully',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Text(
            'You will recieve an email conformation',
            style: TextStyle(fontSize: 15, color: Colors.black38),
          ),
          InkWell(
            onTap: (){
              bottomNavBarProvider.screenIndex = 1;
              Navigator.popUntil(context, ModalRoute.withName(MainScreen.routeName));
            },
            child: Container(
              height: 50,
              width: MediaQuery.sizeOf(context).width,
              margin: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                child: Text(
                  'See Orders',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
