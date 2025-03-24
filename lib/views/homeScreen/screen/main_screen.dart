import 'package:clotstoreapp/backend/provider/bottomNavBar/BottomNavBarProvider.dart';
import 'package:clotstoreapp/views/homeScreen/components/custom_bottum_bar.dart';
import 'package:clotstoreapp/views/homeScreen/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Profile-Screen/profileScreen.dart';
import '../../orderScreen/ordersShowScreen.dart';

class MainScreen extends StatefulWidget {
  static const String routeName = "/MainScreen";

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  List<Widget> _screens = [
    HomeScreen(),
    OrdersShowScreen(),
    ProfileScreen(),
  ];

  late BottomNavBarProvider bottomNavBarProvider;
  @override
  Widget build(BuildContext context) {
    bottomNavBarProvider = context.watch<BottomNavBarProvider>();
    return Scaffold(
      body: _screens[bottomNavBarProvider.screenIndex],
      bottomNavigationBar: CustomBottomBar(
        selectedIndex: bottomNavBarProvider.screenIndex,
      ),
    );
  }
}
