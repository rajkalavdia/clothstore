import 'package:clotstoreapp/config/constant.dart';
import 'package:clotstoreapp/model/cartProductModel.dart';
import 'package:clotstoreapp/model/productReviewModel.dart';
import 'package:clotstoreapp/views/cart/cartProductList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../backend/provider/cart/cart-provider.dart';
import '../../backend/provider/favoriteButton/favoriteButtonProvider.dart';
import '../../model/productsModel.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const String routeName = '/ProductDetailsScreen';
  final ProductsModel productDetails;

  const ProductDetailsScreen({super.key, required this.productDetails});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late ProductsModel productDetails;

  String? dropDownValueSize;
  Color? dropDownValueColor;
  int _currentQuantity = 0;

  List<ProductReviewModel> productReviews = ProductReviewModelList.productReview;

  Future<void> addToCart() async {

    CartProvider cartProvider = context.read<CartProvider>();
    final _items = cartProvider.cartProductsList;
    List<CartProductModel> exist = _items.where((item) {
      return productDetails.productId == item.cartProductId && dropDownValueSize == item.cartProductSize && dropDownValueColor == item.cartProductColor;
    }).toList();

    print('exist list lenght : ${exist.length}');

    if (exist.length == 1) {
      exist[0].cartProductQuantity += _currentQuantity;
      print('current Quantity: ${exist[0].cartProductQuantity}');
    } else {
      CartProductModel cartProductModel = CartProductModel(
        cartProductId: productDetails.productId,
        cartProductImage: productDetails.productImage,
        cartProductName: productDetails.productName,
        cartProductPrice: productDetails.productPrice,
        cartProductSize: dropDownValueSize!,
        cartProductColor: dropDownValueColor,
        cartProductQuantity: _currentQuantity,
      );
      cartProvider.addToCart(cartProductModel);
    }

    _currentQuantity = 0;
    setState(() {});

    Navigator.pushNamed(context, CartProductList.routeName);
  }

  @override
  void initState() {
    super.initState();

    productDetails = widget.productDetails;
    dropDownValueSize = productDetails.productSize.firstOrNull;
    dropDownValueColor = productDetails.productColor.firstOrNull;
  }

  late FavoriteButtonProvider favoriteButtonProvider;

  @override
  Widget build(BuildContext context) {
    favoriteButtonProvider = context.watch<FavoriteButtonProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getHeader(),
                  getListOfImages(),
                  getProductName(),
                  getProductPrice(),
                  getProductSizeWidget(),
                  getProductColorWidget(),
                  getProductQuantityWidget(),
                  getProductDescription(),
                  getProductReturnDetails(),
                  getProductReviews(),
                ],
              ),
            ),
            getAddedtoCartButton(),
          ],
        ),
      ),
    );
  }

  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 50,
          width: 50,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(40),
          ),
          child: IconButton(
            onPressed: () {
              print('raj');
              Navigator.pop(context);
            },
            icon: Image.asset('asset/icons/arrowleftBlack.png'),
          ),
        ),
        Expanded(child: SizedBox()),
        Container(
          height: 50,
          width: 50,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(40),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/CartProductList');
            },
            icon: Image.asset('asset/icons/bag2.png'),
          ),
        ),
        Container(
          height: 50,
          width: 50,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(40),
          ),
          child: IconButton(
            onPressed: () {
              favoriteButtonProvider.toggleFavorite(productDetails.productId);
            },
            icon: (favoriteButtonProvider.isFavorite(productDetails.productId))
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
    );
  }

  Widget getListOfImages() {
    return SizedBox(
      height: 250,
      child: ListView.builder(
          itemCount: productDetails.productImageList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (contex, index) {
            final _model = productDetails.productImageList[index];
            return Container(
              color: Colors.grey,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Image.asset(
                _model,
                fit: BoxFit.fill,
              ),
            );
          }),
    );
  }

  Widget getProductName() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
      child: Text(
        productDetails.productName,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget getProductPrice() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
      child: Text(
        '\$${productDetails.productPrice}',
        style: TextStyle(
          fontSize: 22,
          color: Colors.deepPurpleAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget getProductSizeWidget() {
    return Container(
      height: 60,
      margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Size',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          DropdownButton(
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
            icon: Image.asset(
              'asset/icons/arrowdownBlack.png',
              height: 30,
            ),
            onChanged: (String? value) {
              print("value:$value");

              setState(() {
                dropDownValueSize = value!;
              });
            },
            isDense: true,
            underline: SizedBox(),
            items: productDetails.productSize.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                child: Text(value),
                value: value,
              );
            }).toList(),
            value: dropDownValueSize,
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }

  Widget getProductColorWidget() {
    return Container(
      height: 60,
      margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(
          30,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Text(
                'Color',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          DropdownButton(
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
            icon: Image.asset(
              'asset/icons/arrowdownBlack.png',
              height: 30,
            ),
            onChanged: (Color? value) {
              print("value:$value");
              setState(() {
                dropDownValueColor = value!;
              });
            },
            isDense: true,
            underline: SizedBox(),
            items: productDetails.productColor.map<DropdownMenuItem<Color>>((Color value) {
              return DropdownMenuItem<Color>(
                child: Container(
                  height: 25,
                  width: 25,
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: value,
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                value: value,
              );
            }).toList(),
            value: dropDownValueColor,
          ),
          SizedBox(
            width: 15,
          )
        ],
      ),
    );
  }

  Widget getProductQuantityWidget() {
    return Container(
      height: 60,
      margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Text(
                'Quantity',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                _currentQuantity++;
              });
            },
            child: Container(
              height: 40,
              width: 40,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.deepPurpleAccent,
              ),
              child: Image.asset(
                'asset/icons/quantityIncrease.png',
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            _currentQuantity.toString(),
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          InkWell(
            onTap: () {
              setState(() {
                if (_currentQuantity > 0) {
                  _currentQuantity--;
                }
              });
            },
            child: Container(
              height: 40,
              width: 40,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.deepPurpleAccent,
              ),
              child: Image.asset(
                'asset/icons/quantityDecrease.png',
              ),
            ),
          ),
          SizedBox(
            width: 15,
          )
        ],
      ),
    );
  }

  Widget getProductDescription() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
      child: Text(
        productDetails.description,
        style: TextStyle(
          color: Colors.black38,
        ),
      ),
    );
  }

  Widget getAddedtoCartButton() {
    CartProductModel cartProductModel = CartProductModel();
    return Stack(
      alignment: Alignment.center,
      children: [
        if (_currentQuantity > 0)
          Positioned(
            bottom: 0,
            child: InkWell(
              onTap: () {
                addToCart();
              },
              child: Container(
                height: 65,
                margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(color: Colors.deepPurpleAccent, borderRadius: BorderRadius.circular(40)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      // padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '\$${productDetails.productPrice * _currentQuantity}',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      'Add To Bag',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
      ],
    );
  }

  Widget getProductReturnDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
          child: Text(
            'Shipping & Returns',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: Text(
            'Free standard shipping and free 60-day returns',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black38,
            ),
          ),
        ),
      ],
    );
  }

  Widget getProductReviews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
          child: Text(
            'Reviews',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: Text(
            '213 Reviews',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black38,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: productReviews.length,
          itemBuilder: (context, index) {
            final _model = productReviews[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                      child: CircleAvatar(
                        radius: 30,
                        child: Image.asset(_model.userProfile),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _model.userName,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    RatingBar.builder(
                      initialRating: productReviews[index].userRating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 25,
                      itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                      itemBuilder: (context, _) => Image.asset('asset/images/productScreen/productReview/productRating.png'),
                      onRatingUpdate: (rating) {},
                      ignoreGestures: true,
                      unratedColor: Color(0xffF4F4F4),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                  child: Text(
                    _model.userReview,
                    style: TextStyle(fontSize: 15, color: Colors.black38),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 3, 0, 6),
                  child: Text(
                    '12 days Ago ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ],
    );
  }
}
