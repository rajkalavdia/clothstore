import 'dart:ui';

import 'package:clotstoreapp/model/cartProductModel.dart';
import 'package:clotstoreapp/model/categoriesModel.dart';
import 'package:clotstoreapp/model/ordersModel.dart';
import 'package:clotstoreapp/model/productsModel.dart';
import 'package:clotstoreapp/model/productReviewModel.dart';
import 'package:clotstoreapp/model/searchProductModel.dart';

class CategoriesModelList {
  static List<CategoriesModel> categories = [
    CategoriesModel(
      categoriesImage: 'asset/images/categories/hoodies.jpeg',
      categoriesName: 'Hoodies',
    ),
    CategoriesModel(
      categoriesImage: 'asset/images/categories/shorts.jpeg',
      categoriesName: 'Shorts',
    ),
    CategoriesModel(
      categoriesImage: 'asset/images/categories/shoes.jpeg',
      categoriesName: 'Shoes',
    ),
    CategoriesModel(
      categoriesImage: 'asset/images/categories/bags.jpeg',
      categoriesName: 'Bags',
    ),
    CategoriesModel(
      categoriesImage: 'asset/images/categories/accessories.jpeg',
      categoriesName: 'Accessories',
    ),
    CategoriesModel(
      categoriesImage: 'asset/images/categories/hoodies.jpeg',
      categoriesName: 'Hoodies',
    ),
    CategoriesModel(
      categoriesImage: 'asset/images/categories/shorts.jpeg',
      categoriesName: 'Shorts',
    ),
    CategoriesModel(
      categoriesImage: 'asset/images/categories/shoes.jpeg',
      categoriesName: 'Shoes',
    ),
    CategoriesModel(
      categoriesImage: 'asset/images/categories/bags.jpeg',
      categoriesName: 'Bags',
    ),
    CategoriesModel(
      categoriesImage: 'asset/images/categories/accessories.jpeg',
      categoriesName: 'Accessories',
    ),
    CategoriesModel(
      categoriesImage: 'asset/images/categories/hoodies.jpeg',
      categoriesName: 'Hoodies',
    ),
    CategoriesModel(
      categoriesImage: 'asset/images/categories/shorts.jpeg',
      categoriesName: 'Shorts',
    ),
    CategoriesModel(
      categoriesImage: 'asset/images/categories/shoes.jpeg',
      categoriesName: 'Shoes',
    ),
    CategoriesModel(
      categoriesImage: 'asset/images/categories/bags.jpeg',
      categoriesName: 'Bags',
    ),
    CategoriesModel(
      categoriesImage: 'asset/images/categories/accessories.jpeg',
      categoriesName: 'Accessories',
    ),
  ];
}

class ProductsModelList {
  static List<ProductsModel> productDetails = [
    ProductsModel(
        productId: 0,
        productImage: 'asset/images/product/hoodie.jpeg',
        productName: 'Tommy hilfiger black hoodie',
        productPrice: 60,
        productImageList: [
          'asset/images/product/hoodie.jpeg',
          'asset/images/product/hoodie.jpeg',
          'asset/images/product/hoodie.jpeg',
          'asset/images/product/hoodie.jpeg',
        ],
        productSize: ['S', 'M', 'L', 'XL', 'XXL'],
        productColor: [Color(0xffB3B68B), Color(0xff272727), Color(0xff323448)],
        description: 'Built for life and made to last, this full-zip corduroy jacket is part of our Nike Life collection. The spacious fit gives'
            ' you plenty of room to layer underneath, while the soft corduroy keeps it casual and timeless.'),
    ProductsModel(
        productId: 1,
        productImage: 'asset/images/product/short.jpeg',
        productName: 'Puma black short ',
        productPrice: 10,
        productImageList: [
          'asset/images/product/short.jpeg',
          'asset/images/product/short.jpeg',
          'asset/images/product/short.jpeg',
          'asset/images/product/short.jpeg',
          'asset/images/product/short.jpeg',
        ],
        productSize: ['S', 'M', 'L', 'XL', 'XXL'],
        productColor: [Color(0xffB3B68B), Color(0xff272727), Color(0xff323448)],
        description: 'Built for life and made to last, this full-zip corduroy jacket is part of our Nike Life collection. The spacious fit gives'
            ' you plenty of room to layer underneath, while the soft corduroy keeps it casual and timeless.'),
    ProductsModel(
        productId: 2,
        productImage: 'asset/images/product/shoe.jpeg',
        productName: 'Nike very Comfortable shoe',
        productPrice: 120,
        productImageList: [
          'asset/images/product/shoe.jpeg',
          'asset/images/product/shoe.jpeg',
          'asset/images/product/shoe.jpeg',
        ],
        productSize: ['S', 'M', 'L', 'XL', 'XXL'],
        productColor: [Color(0xffB3B68B), Color(0xff272727), Color(0xff323448)],
        description: 'Built for life and made to last, this full-zip corduroy jacket is part of our Nike Life collection. The spacious fit gives'
            ' you plenty of room to layer underneath, while the soft corduroy keeps it casual and timeless.'),
    ProductsModel(
        productId: 3,
        productImage: 'asset/images/product/bag.jpeg',
        productName: 'Kenneth Cole Faux Leather Bag',
        productPrice: 70,
        productImageList: [
          'asset/images/product/bag.jpeg',
          'asset/images/product/bag.jpeg',
          'asset/images/product/bag.jpeg',
          'asset/images/product/bag.jpeg',
        ],
        productSize: ['S', 'M', 'L', 'XL', 'XXL'],
        productColor: [Color(0xffB3B68B), Color(0xff272727), Color(0xff323448)],
        description: 'Built for life and made to last, this full-zip corduroy jacket is part of our Nike Life collection. The spacious fit gives'
            ' you plenty of room to layer underneath, while the soft corduroy keeps it casual and timeless.'),
    ProductsModel(
        productId: 4,
        productImage: 'asset/images/product/watch.jpeg',
        productName: 'Titan luxurious watch',
        productPrice: 100,
        productImageList: [
          'asset/images/product/watch.jpeg',
          'asset/images/product/watch.jpeg',
          'asset/images/product/watch.jpeg',
          'asset/images/product/watch.jpeg',
          'asset/images/product/watch.jpeg',
        ],
        productSize: ['S', 'M', 'L', 'XL', 'XXL'],
        productColor: [Color(0xffB3B68B), Color(0xff272727), Color(0xff323448)],
        description: 'Built for life and made to last, this full-zip corduroy jacket is part of our Nike Life collection. The spacious fit gives'
            ' you plenty of room to layer underneath, while the soft corduroy keeps it casual and timeless.'),
    ProductsModel(
      productId: 5,
      productImage: 'asset/images/new_product/new_jacket.jpeg',
      productName: 'Nike sport jacket',
      productPrice: 56.88,
      productImageList: [
        'asset/images/new_product/new_jacket.jpeg',
        'asset/images/new_product/new_jacket.jpeg',
        'asset/images/new_product/new_jacket.jpeg',
      ],
      productSize: ['S', 'M', 'L', 'XL', 'XXL'],
      productColor: [Color(0xffB3B68B), Color(0xff272727), Color(0xff323448)],
      description: 'Built for life and made to last, this full-zip corduroy jacket is part of our Nike Life collection. The spacious fit gives'
          ' you plenty of room to layer underneath, while the soft corduroy keeps it casual and timeless.',
    ),
    ProductsModel(
      productId: 6,
      productImage: 'asset/images/new_product/new_track_pent.jpeg',
      productName: 'Nike sport track pent',
      productPrice: 50,
      productImageList: [
        'asset/images/new_product/new_track_pent.jpeg',
        'asset/images/new_product/new_track_pent.jpeg',
        'asset/images/new_product/new_track_pent.jpeg',
        'asset/images/new_product/new_track_pent.jpeg',
      ],
      productSize: ['S', 'M', 'L', 'XL', 'XXL'],
      productColor: [Color(0xffB3B68B), Color(0xff272727), Color(0xff323448)],
      description: 'Built for life and made to last, this full-zip corduroy jacket is part of our Nike Life collection. The spacious fit gives'
          ' you plenty of room to layer underneath, while the soft corduroy keeps it casual and timeless.',
    ),
    ProductsModel(
      productId: 7,
      productImage: 'asset/images/new_product/new_shoe.jpeg',
      productName: 'Air jorden high ankle shoes ',
      productPrice: 150,
      productImageList: [
        'asset/images/new_product/new_shoe.jpeg',
        'asset/images/new_product/new_shoe.jpeg',
        'asset/images/new_product/new_shoe.jpeg',
        'asset/images/new_product/new_shoe.jpeg',
        'asset/images/new_product/new_shoe.jpeg',
      ],
      productSize: ['S', 'M', 'L', 'XL', 'XXL'],
      productColor: [Color(0xffB3B68B), Color(0xff272727), Color(0xff323448)],
      description: 'Built for life and made to last, this full-zip corduroy jacket is part of our Nike Life collection. The spacious fit gives'
          ' you plenty of room to layer underneath, while the soft corduroy keeps it casual and timeless.',
    ),
    ProductsModel(
      productId: 8,
      productImage: 'asset/images/new_product/new_bag.jpeg',
      productName: 'Gucci leather bag',
      productPrice: 100,
      productImageList: [
        'asset/images/new_product/new_bag.jpeg',
        'asset/images/new_product/new_bag.jpeg',
        'asset/images/new_product/new_bag.jpeg',
      ],
      productSize: ['S', 'M', 'L', 'XL', 'XXL'],
      productColor: [Color(0xffB3B68B), Color(0xff272727), Color(0xff323448)],
      description: 'Built for life and made to last, this full-zip corduroy jacket is part of our Nike Life collection. The spacious fit gives'
          ' you plenty of room to layer underneath, while the soft corduroy keeps it casual and timeless.',
    ),
    ProductsModel(
      productId: 9,
      productImage: 'asset/images/new_product/new_watch.jpeg',
      productName: 'Jacob & Co. luxurious watch ',
      productPrice: 80000,
      productImageList: [
        'asset/images/new_product/new_watch.jpeg',
        'asset/images/new_product/new_watch.jpeg',
        'asset/images/new_product/new_watch.jpeg',
        'asset/images/new_product/new_watch.jpeg',
      ],
      productSize: ['S', 'M', 'L', 'XL', 'XXL'],
      productColor: [Color(0xffB3B68B), Color(0xff272727), Color(0xff323448)],
      description: 'Built for life and made to last, this full-zip corduroy jacket is part of our Nike Life collection. The spacious fit gives'
          ' you plenty of room to layer underneath, while the soft corduroy keeps it casual and timeless.',
    ),
  ];
}

class SearchProductsModelList {
  static List<SearchProductsModel> searchProductDetails = [
    SearchProductsModel(
      searchProductImage: 'asset/images/searchProduct/searchProduct1.jpg',
      searchProductName: ' Danim Jeans Jacket',
      searchProductPrice: '\$20',
      isSearchProductFavorite: false,
    ),
    SearchProductsModel(
      searchProductImage: 'asset/images/searchProduct/searchProduct2.jpg',
      searchProductName: ' Barbour leather Jacket',
      searchProductPrice: '\$30',
      isSearchProductFavorite: false,
    ),
    SearchProductsModel(
      searchProductImage: 'asset/images/searchProduct/searchProduct3.jpg',
      searchProductName: ' Carhartt Polyester Jacket',
      searchProductPrice: '\$100',
      isSearchProductFavorite: false,
    ),
    SearchProductsModel(
      searchProductImage: 'asset/images/searchProduct/searchProduct4.jpg',
      searchProductName: ' USPA High Neck Casual Jacket',
      searchProductPrice: '\$50',
      isSearchProductFavorite: false,
    ),
    SearchProductsModel(
      searchProductImage: 'asset/images/searchProduct/searchProduct5.jpg',
      searchProductName: ' Belstaff Bomber Jacket',
      searchProductPrice: '\$150',
      isSearchProductFavorite: false,
    ),
    SearchProductsModel(
      searchProductImage: 'asset/images/searchProduct/searchProduct6.jpg',
      searchProductName: ' Bike Gear icon upstate canvas national Jacket',
      searchProductPrice: '\$130',
      isSearchProductFavorite: false,
    ),
    SearchProductsModel(
      searchProductImage: 'asset/images/searchProduct/searchProduct7.jpg',
      searchProductName: ' SPJIMR Varsity Jacket',
      searchProductPrice: '\$80',
      isSearchProductFavorite: false,
    ),
    SearchProductsModel(
      searchProductImage: 'asset/images/searchProduct/searchProduct8.jpg',
      searchProductName: ' Crocodile leather Jacket ',
      searchProductPrice: '\$90',
      isSearchProductFavorite: false,
    ),
    SearchProductsModel(
      searchProductImage: 'asset/images/searchProduct/searchProduct9.jpg',
      searchProductName: ' Port Authority Men Core Soft Shell Jacket',
      searchProductPrice: '\$110',
      isSearchProductFavorite: false,
    ),
    SearchProductsModel(
      searchProductImage: 'asset/images/searchProduct/searchProduct10.jpg',
      searchProductName: ' Youth zone lightweight Jacket',
      searchProductPrice: '\$65',
      isSearchProductFavorite: false,
    ),
    SearchProductsModel(
      searchProductImage: 'asset/images/searchProduct/searchProduct11.jpg',
      searchProductName: ' New era varsity Jacket',
      searchProductPrice: '\$80',
      isSearchProductFavorite: false,
    ),
    SearchProductsModel(
      searchProductImage: 'asset/images/searchProduct/searchProduct12.jpg',
      searchProductName: ' Black Padded Storm Jacket',
      searchProductPrice: '\$40',
      isSearchProductFavorite: false,
    ),
    SearchProductsModel(
      searchProductImage: 'asset/images/searchProduct/searchProduct13.jpg',
      searchProductName: ' Alice Murphy Jacket',
      searchProductPrice: '\$50',
      isSearchProductFavorite: false,
    ),
  ];
}


class ProductReviewModelList {
  static List<ProductReviewModel> productReview = [
    ProductReviewModel(
      userProfile: 'asset/images/productScreen/productReview/reviewer1ProfilePhoto.png',
      userName: 'Alex Morgan',
      userRating: 3,
      userReview: 'Gucci transcribes its heritage, creativity, and innovation into a plenitude of collections. '
          'From staple items to distinctive accessories.',
      // dateTime: DateTime.now(),
    ),
    ProductReviewModel(
      userProfile: 'asset/images/productScreen/productReview/reviewer1ProfilePhoto.png',
      userName: 'Alex Morgan',
      userRating: 3,
      userReview: 'Gucci transcribes its heritage, creativity, and innovation into a plenitude of collections. '
          'From staple items to distinctive accessories.',
      // dateTime: DateTime.now(),
    ),
    ProductReviewModel(
      userProfile: 'asset/images/productScreen/productReview/reviewer1ProfilePhoto.png',
      userName: 'Alex Morgan',
      userRating: 3,
      userReview: 'Gucci transcribes its heritage, creativity, and innovation into a plenitude of collections. '
          'From staple items to distinctive accessories.',
      // dateTime: DateTime.now(),
    ),
    ProductReviewModel(
      userProfile: 'asset/images/productScreen/productReview/reviewer1ProfilePhoto.png',
      userName: 'Alex Morgan',
      userRating: 3,
      userReview: 'Gucci transcribes its heritage, creativity, and innovation into a plenitude of collections. '
          'From staple items to distinctive accessories.',
      // dateTime: DateTime.now(),
    ),
    ProductReviewModel(
      userProfile: 'asset/images/productScreen/productReview/reviewer2ProfilePhoto.png',
      userName: 'Alex Morgan',
      userRating: 3,
      userReview: 'Gucci transcribes its heritage, creativity, and innovation into a plenitude of collections. '
          'From staple items to distinctive accessories.',
      // dateTime: DateTime.now(),
    ),
    ProductReviewModel(
      userProfile: 'asset/images/productScreen/productReview/reviewer2ProfilePhoto.png',
      userName: 'Alex Morgan',
      userRating: 3,
      userReview: 'Gucci transcribes its heritage, creativity, and innovation into a plenitude of collections. '
          'From staple items to distinctive accessories.',
      // dateTime: DateTime.now(),
    ),
    ProductReviewModel(
      userProfile: 'asset/images/productScreen/productReview/reviewer2ProfilePhoto.png',
      userName: 'Alex Morgan',
      userRating: 3,
      userReview: 'Gucci transcribes its heritage, creativity, and innovation into a plenitude of collections. '
          'From staple items to distinctive accessories.',
      // dateTime: DateTime.now(),
    ),
  ];
}


