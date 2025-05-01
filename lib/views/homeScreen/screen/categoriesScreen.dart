import 'package:clotstoreapp/backend/provider/category/categoryProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../backend/controller/categoryController.dart';

class CategoriesScreen extends StatefulWidget {
  static const String routeName = "/CategoriesScreen";

  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  CategoryProvider categoryProvider = CategoryProvider();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      await CategoryController().getCategoryFirebase(categoryProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            getHeader(),
            getCategories(),
          ],
        ),
      ),
    );
  }

  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 50,
            width: 50,
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Colors.black12),
            child: Image.asset(
              "asset/icons/arrowleftBlack.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Categories',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ],
    );
  }

  Widget getCategories() {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        return Expanded(
          child: ListView.builder(
              itemCount: categoryProvider.categoryList.length,
              itemBuilder: (context, int index) {
                final _model = categoryProvider.categoryList[index];
                print("Category Name: ${_model.categoryName}"); // This line prints the category name
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            _model.categoryImageUrl,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          _model.categoryName,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              }),
        );
      },
    );
  }
}
