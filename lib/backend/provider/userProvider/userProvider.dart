import 'package:clotstoreapp/model/userModel.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _userModel;

  UserModel? get user => _userModel;

  void setUser(UserModel user) {
    if (_userModel != user) {
      _userModel = user;
      notifyListeners();
    }
  }
// void clearUser() {
//   _userModel = null;
//   notifyListeners();
// }
}