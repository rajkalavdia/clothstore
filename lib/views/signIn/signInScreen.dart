import 'package:clothstore_admin_pannel/model/user/userModel.dart';
import 'package:clotstoreapp/backend/controller/signInController.dart';
import 'package:clotstoreapp/views/profile-Screen/completeProfileScreen.dart';
import 'package:clotstoreapp/views/signIn/otpVerification.dart';
import 'package:clotstoreapp/views/signIn/signUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../config/styles.dart';

class SignInScreen extends StatefulWidget {
  static const String routeName = '/SignInScreen';

  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  final GlobalKey<FormState> _numberFrmKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isValidationEnabled = false;
  bool _isNumberValidationEnabled = false;

  bool isLoading = false;

  // @override
  // void dispose() {
  //   _focusNode.dispose();
  //   _emailController.dispose();
  //   _passwordController.dispose();
  //   _numberController.dispose();
  //   super.dispose();
  // }

  // void getAuthData() async {
  //   String email = _emailController.text.trim();
  //   String password = _passwordController.text.trim();
  //
  //   final CollectionReference docRef = FirebaseFirestore.instance.collection('users');
  //
  //   try {
  //     QuerySnapshot querySnapshotEmail = await docRef.where('email', isEqualTo: email).get();
  //     QuerySnapshot querySnapshotPassword = await docRef.where('password', isEqualTo: password).get();
  //
  //     if (querySnapshotEmail.docs.isEmpty) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Incorrect Email"), backgroundColor: Colors.red),
  //       );
  //       return;
  //     }
  //
  //     if (querySnapshotPassword.docs.isEmpty) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Incorrect Password"), backgroundColor: Colors.red),
  //       );
  //       return;
  //     }
  //
  //     // Successful login
  //     await await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: _emailController.text.trim(),
  //       password: _passwordController.text.trim(),
  //     );
  //     if (!context.mounted) return;
  //     Navigator.pushReplacementNamed(
  //       context,
  //       MainScreen.routeName,
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
  //     );
  //     print("exception error : $e");
  //   }
  // }

  void _handleGoogleSignIn() async {
    setState(() {
      isLoading = true;
    });
    print('Loader Start : $isLoading');
    UserModel? user = await UserController().signInWithGoogle(context);

    if (user != null) {
      // If new user (no phone number), navigate to complete profile
      if (user.phoneNumber == null) {
        Navigator.of(context).pushReplacementNamed('/NewProfileScreen');
      } else {
        // Existing user, go to home
        Navigator.of(context).pushReplacementNamed('/MainScreen');
      }
    } else {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google sign in failed. Please try again.')));
    }
    setState(() {
      isLoading = false;
    });
    print('Loader End : $isLoading');
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: CircularProgressIndicator(
        backgroundColor: Colors.transparent,
        color: Colors.black,
      ),
      child: Scaffold(
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
                getPhoneNumberTextField(),
                getOTPButton(),
                getSignUpWithApple(),
                getSignUpWithGoogle(),
              ],
            ),
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
          // getAuthData();
          UserModel? user = await UserController().signInUser(_emailController.text, _passwordController.text, context);
          print("user12345678 : ${user?.email}");
          print("user12345678 : ${user?.name}");
          print("user12345678 : ${user?.phoneNumber}");
          if (user != null) {
            if (user.phoneNumber == null || user.name == null || user.email == null) {
              Navigator.pushNamed(context, CompleteProfileScreen.routeName);
              UserModel? user = await UserController().signInUser(_emailController.text, _passwordController.text, context);
            } else {
              Navigator.of(context).pushReplacementNamed('/MainScreen');
            }
          } else {
            // Show error
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign in failed. Please check your credentials.')));
          }
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
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, SignUpScreen.routeName);
          },
          child: Text(
            'Create One',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget getPhoneNumberTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(18, 30, 18, 0),
          child: Text('Phone Number'),
        ),
        Container(
          height: 80,
          margin: EdgeInsets.fromLTRB(18, 2, 18, 0),
          decoration: BoxDecoration(
            color: Colors.grey[350],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Form(
                  key: _numberFrmKey,
                  child: TextFormField(
                    controller: _numberController,
                    keyboardType: TextInputType.number,
                    autovalidateMode: _isNumberValidationEnabled ? AutovalidateMode.always : AutovalidateMode.disabled,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a mobile number';
                      }
                      if (!value.startsWith("+")) {
                        return 'Number must start with + followed by country code';
                      }
                      String pattern = r'^\+[0-9]+$';
                      if (!RegExp(pattern).hasMatch(value)) {
                        return 'Only digits allowed after "+"';
                      }
                      if (value.length < 11 || value.length > 14) {
                        return 'Enter a valid phone number';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your Number',
                      // labelText: 'Phone Number',
                      // contentPadding: EdgeInsets.fromLTRB(5, 18, 0, 0),
                      hintStyle: TextStyle(
                        color: Colors.black38,
                        fontSize: 20,
                      ),
                      labelStyle: TextStyle(color: Colors.black38),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getOTPButton() {
    return Container(
      height: 80,
      margin: EdgeInsets.fromLTRB(18, 10, 18, 0),
      padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          setState(() {
            _isNumberValidationEnabled = true;
          });
          if (_numberFrmKey.currentState!.validate()) {
            await Navigator.pushNamed(context, OtpVerification.routeName, arguments: {
              "number": _numberController.text.trim(),
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurpleAccent,
          elevation: 0,
        ),
        child: Text(
          'Get OTP',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
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
              'SignUP With Apple',
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
                'SignUp With Google',
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
