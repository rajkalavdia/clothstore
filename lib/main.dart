import 'package:clotstoreapp/backend/provider/favoriteButton/favoriteButtonProvider.dart';
import 'package:clotstoreapp/backend/provider/ordersList/addOrderProvider.dart';
import 'package:clotstoreapp/views/cart/cartProductList.dart';
import 'package:clotstoreapp/views/cart/checkoutScreen.dart';
import 'package:clotstoreapp/views/cart/placedOrder.dart';
import 'package:clotstoreapp/views/homeScreen/screen/categoriesScreen.dart';
import 'package:clotstoreapp/views/homeScreen/screen/home_screen.dart';
import 'package:clotstoreapp/views/homeScreen/screen/main_screen.dart';
import 'package:clotstoreapp/views/homeScreen/screen/searchScreen.dart';
import 'package:clotstoreapp/views/onBoarding/splashScreen.dart';
import 'package:clotstoreapp/views/orderScreen/orderDetailsScreen.dart';
import 'package:clotstoreapp/views/orderScreen/ordersShowScreen.dart';
import 'package:clotstoreapp/views/profile-Screen/editProfileScreen.dart';
import 'package:clotstoreapp/views/profile-Screen/newUserDetailsScreen.dart';
import 'package:clotstoreapp/views/profile-Screen/profileScreen.dart';
import 'package:clotstoreapp/views/signIn/otpVerification.dart';
import 'package:clotstoreapp/views/signIn/signInScreen.dart';
import 'package:clotstoreapp/views/signIn/signUpScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'backend/provider/bottomNavBar/BottomNavBarProvider.dart';
import 'backend/provider/cart/cart-provider.dart';
import 'backend/provider/userProvider/userProvider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'orbital-signal-369106',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if(kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyAj-76toIhMmXSz74B7CcoAruUmyQzB4gc",
          authDomain: "orbital-signal-369106.firebaseapp.com",
          databaseURL: "https://orbital-signal-369106-default-rtdb.asia-southeast1.firebasedatabase.app",
          projectId: "orbital-signal-369106",
          storageBucket: "orbital-signal-369106.firebasestorage.app",
          messagingSenderId: "831777599075",
          appId: "1:831777599075:web:b59d5488474e1e2e0d1256"),
    );
  }else{
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CartProvider>(create: (context) => CartProvider()),
        ChangeNotifierProvider<BottomNavBarProvider>(create: (context) => BottomNavBarProvider()),
        ChangeNotifierProvider<FavoriteButtonProvider>(create: (context) => FavoriteButtonProvider()),
        ChangeNotifierProvider<OrderProvider>(create: (context) => OrderProvider()),
        ChangeNotifierProvider<UserProvider>(create: (context) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'circularStd'),
        // home: AuthenticationScreen(),
        initialRoute: SplashScreen.routeName, // Make sure the route name matches
        routes: {
          SplashScreen.routeName: (context) => SplashScreen(), // Use the same name as initialRoute
          SignInScreen.routeName: (context) => SignInScreen(),
          SignUpScreen.routeName: (context) => SignUpScreen(),
          NewProfileScreen.routeName: (context) => NewProfileScreen(),
          OtpVerification.routeName: (context) => OtpVerification(),
          HomeScreen.routeName: (context) => HomeScreen(),
          MainScreen.routeName: (context) => MainScreen(),
          CategoriesScreen.routeName: (context) => CategoriesScreen(),
          SearchScreen.routeName: (context) => SearchScreen(),
          OrderDetailsScreen.routeName: (context) => OrderDetailsScreen(),
          OrdersShowScreen.routeName: (context) => OrdersShowScreen(),
          CartProductList.routeName: (context) => CartProductList(),
          CheckoutScreen.routeName: (context) => CheckoutScreen(),
          PlaceOrderScreen.routeName: (context) => PlaceOrderScreen(),
          ProfileScreen.routeName: (context) => ProfileScreen(),
          EditProfileScreen.routeName: (context) => EditProfileScreen(),
        },
      ),
    );
  }
}
