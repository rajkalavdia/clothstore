import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../config/styles.dart';
import '../homeScreen/screen/main_screen.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/SignUpScreen';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignUpScreen> {
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isValidationEnabled = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void setAuthData() async {
    CollectionReference authData = FirebaseFirestore.instance.collection('authentication');
    final data1 = <String, dynamic>{
      'email': _emailController.text,
      'password': _passwordController.text,
    };
    await authData.doc().set(data1);
    // print('object created: ${authData.id}');
  }

  void getAuthData() async {
    String email = _emailController.text.trim();

    final CollectionReference docRef = FirebaseFirestore.instance.collection('authentication');
    try {
      QuerySnapshot querySnapshot = await docRef.where('email', isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        print("data exists:");
        DocumentSnapshot doc = querySnapshot.docs.first;
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      } else {
        setAuthData();
      }
      Navigator.pushReplacementNamed(context, MainScreen.routeName);
    } catch (e) {
      print("Error getting document: $e");
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
              getConfirmPasswordTextFieldWidget(),
              getConfirmButton(),
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
          'Sign Up',
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

  Widget getConfirmPasswordTextFieldWidget() {
    return Container(
      height: 80,
      margin: EdgeInsets.fromLTRB(18, 30, 18, 0),
      decoration: BoxDecoration(
        color: Colors.grey[350],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: _confirmPasswordController,
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
          hintText: 'Enter your Confirm password',
          labelText: 'Confirm Password',
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

  Widget getConfirmButton() {
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
}
