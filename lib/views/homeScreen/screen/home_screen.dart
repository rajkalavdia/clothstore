import 'package:clotstoreapp/backend/provider/category/categoryProvider.dart';
import 'package:clotstoreapp/backend/provider/userProvider/userProvider.dart';
import 'package:clotstoreapp/views/ProductScreen/ProductDetailsScreen.dart';
import 'package:clotstoreapp/views/homeScreen/components/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../../backend/controller/categoryController.dart';
import '../../../backend/controller/productController.dart';
import '../../../backend/provider/product/productProvider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/HomeScreen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();

  ProductProvider productProvider = ProductProvider();
  CategoryProvider categoryProvider = CategoryProvider();
  late UserProviderInUserApp userProvider;

  List<String> favouriteProducts = [];

  Future<void> getControllers() async {
    await CategoryController().getCategoryFirebase(categoryProvider);
    await ProductController().getProductFromFirebase(productProvider);
  }

  @override
  void initState() {
    super.initState();
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    userProvider = Provider.of<UserProviderInUserApp>(context, listen: false);
    getControllers();

    favouriteProducts = userProvider.user!.favouriteProductIDs;

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent && !productProvider.isLoading && productProvider.hashMore) {
        ProductController().getProductFromFirebase(productProvider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("productProvider.isLoading:${productProvider.isLoading}");
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: productProvider.isLoading,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(preferredSize: Size(0, 80), child: CustomAppBar()),
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                getSearchFieldWidget(),
                getCategories(),
                getTopSellingWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getSearchFieldWidget() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/SearchScreen");
      },
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Image.asset(
              'asset/icons/searchButton.png',
              height: 25,
              width: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Search',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getCategories() {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SizedBox(
            height: 80,
            child: ListView.builder(
              itemCount: categoryProvider.categoryList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final model = categoryProvider.categoryList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  child: Column(
                    children: [
                      ClipOval(
                        child: Image.network(
                          model.categoryImageUrl,
                          height: 60,
                          width: 60,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Text(model.categoryName),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
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
        Consumer<ProductProvider>(builder: (context, productProvider, _) {
          return productProvider.productModelList.isEmpty && productProvider.isLoading
              ? Center(child: CircularProgressIndicator())
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    childAspectRatio: 0.5,
                  ),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: productProvider.productModelList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, int index) {
                    if (index < productProvider.productModelList.length) {
                      final _model = productProvider.productModelList[index];
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
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          width: 200,
                          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                    child: Image.network(
                                      _model.productImages[0],
                                      // height:150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: IconButton(
                                        onPressed: () async {
                                          await ProductController().setFavouriteProducts(_model.productId);
                                          setState(() {
                                            if (favouriteProducts.contains(_model.productId)) {
                                              favouriteProducts.remove(_model.productId);
                                            } else {
                                              favouriteProducts.add(_model.productId);
                                            }
                                          });
                                        },
                                        icon: (favouriteProducts.contains(_model.productId))
                                            ? Image.asset(
                                                'asset/icons/liked_product_button.png',
                                                height: 35,
                                              )
                                            : Image.asset(
                                                'asset/icons/default_like_button.png',
                                                height: 35,
                                              )),
                                  ),
                                ],
                              ),
                              Text(
                                _model.brandName,
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                _model.productCategory,
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                '₹${_model.productPrice.toInt()}',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                );
        }),
      ],
    );
  }
}
