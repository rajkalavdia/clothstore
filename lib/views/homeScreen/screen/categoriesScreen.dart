import 'package:clotstoreapp/config/constant.dart';
import 'package:clotstoreapp/model/categoriesModel.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  static const String routeName = "/CategoriesScreen";
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<CategoriesModel> _categories = CategoriesModelList.categories;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  margin: EdgeInsets.fromLTRB(30, 50, 0, 20),
                  decoration:BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(40)
                  ) ,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Image.asset('asset/icons/arrowleftBlack.png'),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Shop by Categories',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _categories.length ,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  CategoriesModel model = _categories[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                          borderRadius:BorderRadius.circular(20)
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 10,),
                          CircleAvatar(
                            radius: 30,
                            child: ClipOval(
                              child: Image.asset(
                                model.categoriesImage,
                                height: 80,
                                width: 80,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Text(model.categoriesName , style: TextStyle(fontSize: 25),),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
