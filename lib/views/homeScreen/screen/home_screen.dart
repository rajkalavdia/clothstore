import 'package:clotstoreapp/backend/provider/favoriteButton/favoriteButtonProvider.dart';
import 'package:clotstoreapp/config/constant.dart';
import 'package:clotstoreapp/model/categoriesModel.dart';
import 'package:clotstoreapp/model/productsModel.dart';
import 'package:clotstoreapp/views/ProductScreen/ProductDetailsScreen.dart';
import 'package:clotstoreapp/views/homeScreen/components/custom_app_bar.dart';
import 'package:clotstoreapp/views/homeScreen/components/custom_bottum_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/HomeScreen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<CategoriesModel> _categories = CategoriesModelList.categories;
  List<ProductsModel> _productDetails = ProductsModelList.productDetails;

  late FavoriteButtonProvider favoriteButtonProvider;



  @override
  Widget build(BuildContext context) {
    favoriteButtonProvider = context.watch<FavoriteButtonProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(170),
        child: CustomAppBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            getCategoriesWidget(),
            getTopSellingWidget(),
            getNewInWidget(),
          ],
        ),
      ),
    );
  }

  Widget getCategoriesWidget() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/CategoriesScreen');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Categories',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  onTap: () {

                    Navigator.pushNamed(context, '/CategoriesScreen');
                  },
                  child: Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SizedBox(
            height: 80,
            child: ListView.builder(
              itemCount: _categories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                CategoriesModel model = _categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  child: Column(
                    children: [
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
                      Text(model.categoriesName),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget getTopSellingWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Top Selling',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'See All',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: SizedBox(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _productDetails.length,
              itemBuilder: (context, index) {
                ProductsModel _model = _productDetails[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(
                          productDetails: _model,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 7),
                    height: 150,
                    width: 200,
                    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              child: Image.asset(
                                _model.productImage,
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
                                  favoriteButtonProvider.toggleFavorite(_model.productId);
                                },
                                icon: (favoriteButtonProvider.isFavorite(_model.productId))
                                    ? Image.asset(
                                        'asset/icons/default_like_button.png',
                                        height: 35,
                                      )
                                    : Image.asset('asset/icons/liked_product_button.png',height: 35,),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          _model.productName,
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          '\$' + (_model.productPrice.toString()),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget getNewInWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'New In',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'See All',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: SizedBox(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _productDetails.length,
              itemBuilder: (context, index) {
                final _model = _productDetails[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(
                          productDetails: _model,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 7),
                    height: 150,
                    width: 200,
                    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              child: Image.asset(
                                _model.productImage,
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
                                    favoriteButtonProvider.toggleFavorite(_model.productId);
                                  });
                                },
                                icon: (favoriteButtonProvider.isFavorite(_model.productId))
                                    ? Image.asset(
                                        'asset/icons/default_like_button.png',
                                        height: 35,
                                      )
                                    : Image.asset('asset/icons/liked_product_button.png',height: 35,),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          _model.productName,
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          '\$' + (_model.productPrice.toString()),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
