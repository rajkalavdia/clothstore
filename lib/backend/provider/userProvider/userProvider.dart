import 'package:clothstore_admin_pannel/model/user/userModel.dart';
import 'package:flutter/cupertino.dart';

class UserProviderInUserApp extends ChangeNotifier {
  UserModel? _userModel;

  UserModel? get user => _userModel;

  void setUser(UserModel user) {
    if (_userModel != user) {
      _userModel = user;
      notifyListeners();
    }
  }

  void clearUser() {
    _userModel = null;
    notifyListeners();
  }
}
