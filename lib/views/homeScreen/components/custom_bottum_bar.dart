import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../backend/provider/bottomNavBar/BottomNavBarProvider.dart';


class CustomBottomBar extends StatelessWidget {
  final int selectedIndex;

  const CustomBottomBar({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    BottomNavBarProvider bottomNavBarProvider = context.watch<BottomNavBarProvider>();
    // BottomNavBarProvider bottomNavBarProvider = Provider.of<BottomNavBarProvider>(context);
    return SafeArea(
      child: BottomNavigationBar(
        iconSize: 30,
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (int index){
          bottomNavBarProvider.screenIndex = index;
        },
        items: [
          BottomNavigationBarItem(
            icon: selectedIndex == 0
                ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'asset/icons/bottomNavBar/home_colored.png',
                height: 20,
              ),
            )
                : Image.asset(
              'asset/icons/bottomNavBar/home.png',
              height: 30,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: selectedIndex == 1
                ? Image.asset(
              'asset/icons/bottomNavBar/order_colored.png',
              height: 30,
            )
                : Image.asset(
              'asset/icons/bottomNavBar/order.png',
              height: 30,
            ),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: selectedIndex == 2
                ? Image.asset(
              'asset/icons/bottomNavBar/profile_colored.png',
              height: 30,
            )
                : Image.asset(
              'asset/icons/bottomNavBar/profile.png',
              height: 25,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
