import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../config/styles.dart';
import '../homeScreen/screen/main_screen.dart';

class SignInScreen extends StatefulWidget {
  static const String routeName = '/SignInScreen';

  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isValidationEnabled = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void sighin() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  void setAuthData() async {
    CollectionReference authData = FirebaseFirestore.instance.collection('authentication');
    final data1 = <String, dynamic>{
      'email': _emailController.text,
      'password': _passwordController.text,
    };
    await authData.doc().set(data1);
    // print('object created: ${authData.id}');
    sighin();
  }

  void getAuthData() async {
    String email =_emailController.text.trim();

    final CollectionReference docRef = FirebaseFirestore.instance.collection('authentication');
    try {
      QuerySnapshot querySnapshot = await docRef.where('email' ,isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        print("data exists:");
        DocumentSnapshot doc = querySnapshot.docs.first;
        Map<String , dynamic> data = doc.data() as Map<String ,dynamic>;
        sighin();
      } else {
        setAuthData();
      }
      Navigator.pushReplacementNamed(context, MainScreen.routeName);
    } catch (e) {
      print("Error getting document: $e");
    }
  }


  void _handleGoogleSignIn() async {
    try {
      User? user = await _authService.signInWithGoogle();
      if (user != null) {
        print("Google Sign-In Success: ${user.displayName}");
        Navigator.pushReplacementNamed(context, MainScreen.routeName);
      } else {
        print("Google Sign-In failed: User is null.");
      }
    } catch (e) {
      print("Google Sign-In Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Sign-In failed. Please try again.")),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getTitle(),
              getEmailTextFieldWidget(),
              getPasswordTextFieldWidget(),
              getForgotPassword(),
              getContinueButton(),
              getCreateNewAccount(),
              getSignUpWithApple(),
              getSignUpWithGoogle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Sign in',
          style: TextStyle(
            color: signInTextColor,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget getEmailTextFieldWidget() {
    return Form(
      key: _formKey,
      child: Container(
        height: 80,
        margin: EdgeInsets.fromLTRB(18, 30, 18, 0),
        decoration: BoxDecoration(
          color: Colors.grey[350],
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          controller: _emailController,
          autovalidateMode: _isValidationEnabled ? AutovalidateMode.always : AutovalidateMode.disabled,
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the email';
            }
            if (!value.contains('@') || !value.endsWith('gmail.com')) {
              return 'Please enter a valid Gmail address';
            }
            return null;
          },
          focusNode: _focusNode,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
          decoration: InputDecoration(
            hintText: 'example@gmail.com',
            labelText: 'Email Address',
            contentPadding: EdgeInsets.fromLTRB(5, 18, 0, 0),
            hintStyle: TextStyle(
              color: Colors.black38,
              fontSize: 20,
            ),
            labelStyle: TextStyle(color: Colors.black38),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget getPasswordTextFieldWidget() {
    return Container(
      height: 80,
      margin: EdgeInsets.fromLTRB(18, 30, 18, 0),
      decoration: BoxDecoration(
        color: Colors.grey[350],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: _passwordController,
        obscureText: true,
        // Hides the password input
        keyboardType: TextInputType.number,
        // Allows only numbers
        autovalidateMode: _isValidationEnabled ? AutovalidateMode.always : AutovalidateMode.disabled,
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          if (value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          return null;
        },
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
        decoration: InputDecoration(
          hintText: 'Enter your password',
          labelText: 'Password',
          contentPadding: EdgeInsets.fromLTRB(5, 18, 0, 0),
          hintStyle: TextStyle(
            color: Colors.black38,
            fontSize: 20,
          ),
          labelStyle: TextStyle(color: Colors.black38),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget getForgotPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 10,
      ),
      child: Row(
        children: [
          Text('Forget Password? '),
          Text(
            'Reset',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }

  Widget getContinueButton() {
    return Container(
      height: 80,
      padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          setState(() {
            _isValidationEnabled = true;
          });
          getAuthData();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurpleAccent,
          elevation: 0,
        ),
        child: Text(
          'Continue',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  Widget getCreateNewAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account? "),
        Text(
          'Create One',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget getSignUpWithApple() {
    return Container(
      height: 60,
      margin: EdgeInsets.fromLTRB(15, 50, 15, 0),
      decoration: BoxDecoration(color: Colors.grey[350], borderRadius: BorderRadius.circular(40)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.apple,
            color: Colors.black,
            size: 45,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 0, 0, 0),
            child: Text(
              'Continue With Apple',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getSignUpWithGoogle() {
    return InkWell(
      onTap: _handleGoogleSignIn,
      child: Container(
        height: 60,
        margin: EdgeInsets.fromLTRB(15, 18, 15, 0),
        decoration: BoxDecoration(color: Colors.grey[350], borderRadius: BorderRadius.circular(40)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 33,
              width: 33,
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Image.asset('asset/icons/googleLogo.png'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
              child: Text(
                'Continue With Google',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection("users").doc(user.uid).set({
          "name": user.displayName,
          "email": user.email,
          "profilePic": user.photoURL,
          "uid": user.uid,
        }, SetOptions(merge: true));
      }

      return user;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }
}
