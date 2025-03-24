import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:clotstoreapp/views/homeScreen/screen/home_screen.dart';
import 'package:clotstoreapp/views/homeScreen/screen/main_screen.dart';
import 'package:clotstoreapp/views/signIn/signInScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    navigateOfSplashScreen();
  }

  final user = FirebaseAuth.instance.currentUser;


  void navigateOfSplashScreen() {
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushNamed(context, (user == null) ? SignInScreen.routeName : MainScreen.routeName);
    });
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
                'clot',
                textStyle: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: splashScreenTextColors),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
