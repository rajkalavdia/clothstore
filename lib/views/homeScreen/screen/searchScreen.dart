import 'package:clotstoreapp/config/constant.dart';
import 'package:clotstoreapp/model/searchProductModel.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = "/SearchScreen";

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<SearchProductsModel> _searchProducts = SearchProductsModelList.searchProductDetails;

 final FocusNode myFocusNode = FocusNode();
  @override
  void initState() {
    myFocusNode.requestFocus();
    super.initState();
  }
  @override
  void dispose() {
    myFocusNode;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 55,
                  width: 55,
                  padding: EdgeInsets.all(7),
                  margin: EdgeInsets.fromLTRB(10, 2, 5, 15),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Image.asset('asset/icons/arrowleftBlack.png'),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 2, 5, 15),
                    child: TextField(
                      focusNode: myFocusNode,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Image.asset(
                            'asset/icons/searchButton.png',
                          ),
                        ),
                        prefixIconConstraints: BoxConstraints(maxHeight: 25),
                        hintText: 'Search',
                        contentPadding: EdgeInsets.fromLTRB(5, 15, 0, 10),
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                        filled: true,
                        fillColor: Colors.grey[300],
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 35,
                    width: 50,
                    margin: EdgeInsets.fromLTRB(18, 2, 0, 15),
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'asset/icons/filter.png',
                          height: 20,
                        ),
                        Text(
                          '2',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 35,
                    width: 85,
                    margin: EdgeInsets.fromLTRB(5, 2, 0, 15),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Text(
                      'On Sale',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  Container(
                    height: 35,
                    width: 75,
                    margin: EdgeInsets.fromLTRB(5, 2, 0, 15),
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Price',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Image.asset(
                          'asset/icons/arrowdownWhite.png',
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 35,
                    width: 100,
                    margin: EdgeInsets.fromLTRB(5, 2, 0, 15),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Sort By',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        Image.asset(
                          'asset/icons/arrowdownBlack.png',
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 35,
                    width: 75,
                    margin: EdgeInsets.fromLTRB(5, 2, 0, 15),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Men',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Image.asset(
                          'asset/icons/arrowdownWhite.png',
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text('56 Result Found'),
            ),
            Flexible(
              child: GridView.builder(
                  itemCount: _searchProducts.length,
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 5, mainAxisExtent: 300),
                  itemBuilder: (context, index) {
                    final _model = _searchProducts[index];
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 7),
                      // height: 150,
                      // width: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                child: Image.asset(
                                  _model.searchProductImage,
                                  height: 220,
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _model.isSearchProductFavorite = !_model.isSearchProductFavorite;
                                    });
                                  },
                                  icon: (_model.isSearchProductFavorite == false)
                                      ? Image.asset(
                                          'asset/icons/default_like_button.png',
                                          height: 35,
                                        )
                                      : Image.asset(
                                          'asset/icons/liked_product_button.png',
                                          height: 35,
                                        ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            _model.searchProductName,
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            _model.searchProductPrice,
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
