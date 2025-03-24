import 'package:clotstoreapp/model/profileModel.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier{
  ProfileModel _profileModel = ProfileModel();

  ProfileModel get profileModel => _profileModel;

  void profileModelUpdate(ProfileModel updateProfilemodel){
    _profileModel = updateProfilemodel;
   notifyListeners();
  }
}