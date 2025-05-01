import 'package:clothstore_admin_pannel/model/categoryModel.dart';
import 'package:flutter/cupertino.dart';

class CategoryProvider extends ChangeNotifier {
  CategoryModel? categoryModel;

  List<CategoryModel> categoryList = [];

  void setCategoriesList({required List<CategoryModel> categoryList}) {
    this.categoryList = categoryList;
    print("Category list set with ${categoryList.length} items");
    notifyListeners();
  }
}
