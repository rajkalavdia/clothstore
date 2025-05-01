import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:clothstore_admin_pannel/model/user/userModel.dart';
import 'package:clotstoreapp/backend/controller/signInController.dart';
import 'package:flutter/material.dart';

import '../../config/styles.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/SplashScreen';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Check if user is already logged in
    checkUserStatus();
  }

  Future<void> checkUserStatus() async {
    await Future.delayed(const Duration(seconds: 4));

    // Try to load user data from Firebase
    UserModel? userModel = await signUpController().loadUserData(context);
    print("User no data avyo ${userModel?.name}");

    // Navigate based on result
    if (userModel != null) {
      Navigator.of(context).pushReplacementNamed('/MainScreen');
    } else {
      // No user logged in, go to login screen
      Navigator.of(context).pushReplacementNamed('/SignInScreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: splashScreenBackGoundColor,
        child: Center(
          child: AnimatedTextKit(
            animatedTexts: [
              WavyAnimatedText(
                'cloth',
                textStyle: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: splashScreenTextColors),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
