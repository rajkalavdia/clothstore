import 'package:flutter/cupertino.dart';

import '../../../views/Profile-Screen/profileScreen.dart';
import '../../../views/homeScreen/screen/home_screen.dart';
import '../../../views/orderScreen/ordersShowScreen.dart';

class BottomNavBarProvider extends ChangeNotifier {
  int _screenIndex = 0;

  int get screenIndex => _screenIndex;

  set screenIndex(int value){
    _screenIndex = value;
    notifyListeners();
  }
}