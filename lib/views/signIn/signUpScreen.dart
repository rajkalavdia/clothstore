import 'package:clothstore_admin_pannel/model/user/userModel.dart';
import 'package:clotstoreapp/backend/controller/signInController.dart';
import 'package:clotstoreapp/views/profile-Screen/completeProfileScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../backend/provider/userProvider/userProvider.dart';
import '../../config/styles.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/SignUpScreen';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Added form key
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<String?> validateEmail() async {
    String email = _emailController.text.trim();
    final CollectionReference docRef = FirebaseFirestore.instance.collection('users');
    try {
      QuerySnapshot querySnapshot = await docRef.where('email', isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        return "This email already exists";
      }
    } catch (e) {
      return "Error checking email: $e";
    }
    return null;
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      String? emailError = await validateEmail();
      if (emailError != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(emailError)));
        return;
      }

      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Passwords do not match")));
        return;
      }

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      // userProvider.clearUser(); // Clear previous user data

      UserModel? user = await UserController().signUpWithEmail(
        context,
        _emailController.text,
        _passwordController.text,
      );

      if (user != null) {
        userProvider.setUser(user); // Set new user data

        // Navigate to the next screen with pre-filled email
        Navigator.of(context).pushReplacementNamed(CompleteProfileScreen.routeName);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign up failed. Please try again.')));
      }
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
          keyboardType: TextInputType.emailAddress,
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
        autovalidateMode: AutovalidateMode.onUserInteraction,
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
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          if (_passwordController.text != _confirmPasswordController.text) {
            return "Passwords don't match";
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
        onPressed: _handleSignUp,
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

// class SignUpScreen extends StatefulWidget {
//   static const String routeName = '/SignUpScreen';
//
//   const SignUpScreen({super.key});
//
//   @override
//   State<SignUpScreen> createState() => _SignInScreenState();
// }
//
// class _SignInScreenState extends State<SignUpScreen> {
//   final FocusNode _focusNode = FocusNode();
//   final GlobalKey<FormState> _eMailFormKey = GlobalKey<FormState>();
//   final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
//   final GlobalKey<FormState> _confirmPasswordFormKey = GlobalKey<FormState>();
//   bool _isValidationEnabled = false;
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();
//
//   Future<String?> validateEmail() async {
//     String email = _emailController.text.trim();
//     final CollectionReference docRef = FirebaseFirestore.instance.collection('users');
//     try {
//       QuerySnapshot querySnapshot = await docRef.where('email', isEqualTo: email).get();
//       if (querySnapshot.docs.isNotEmpty) {
//         DocumentSnapshot doc = querySnapshot.docs.first;
//         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//         return "This email already exists";
//       } else {
//         Navigator.popAndPushNamed(context, NewProfileScreen.routeName, arguments: <String, String>{
//           "email" : _emailController.text.trim(),
//           "password": _passwordController.text.trim(),
//         },);
//       }
//       return null;
//     } catch (e) {
//       return "Error checking email: $e";
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context , snapshot){
//         return Scaffold(
//           body: SafeArea(
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   getTitle(),
//                   getEmailTextFieldWidget(),
//                   getPasswordTextFieldWidget(),
//                   getConfirmPasswordTextFieldWidget(),
//                   getConfirmButton(),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget getTitle() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           'Sign Up',
//           style: TextStyle(
//             color: signInTextColor,
//             fontSize: 40,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget getEmailTextFieldWidget() {
//     return Form(
//       key: _eMailFormKey,
//       child: Container(
//         height: 80,
//         margin: EdgeInsets.fromLTRB(18, 30, 18, 0),
//         decoration: BoxDecoration(
//           color: Colors.grey[350],
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: TextFormField(
//           controller: _emailController,
//           keyboardType: TextInputType.emailAddress,
//           autovalidateMode: _isValidationEnabled ? AutovalidateMode.always : AutovalidateMode.disabled,
//           validator: (String? value) {
//             if (value == null || value.isEmpty) {
//               return 'Please enter the email';
//             }
//             if (!value.contains('@') || !value.endsWith('gmail.com')) {
//               return 'Please enter a valid Gmail address';
//             }
//             validateEmail();
//           },
//           focusNode: _focusNode,
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 20,
//           ),
//           decoration: InputDecoration(
//             hintText: 'example@gmail.com',
//             labelText: 'Email Address',
//             contentPadding: EdgeInsets.fromLTRB(5, 18, 0, 0),
//             hintStyle: TextStyle(
//               color: Colors.black38,
//               fontSize: 20,
//             ),
//             labelStyle: TextStyle(color: Colors.black38),
//             border: InputBorder.none,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget getPasswordTextFieldWidget() {
//     return Form(
//       key: _passwordFormKey,
//       child: Container(
//         height: 80,
//         margin: EdgeInsets.fromLTRB(18, 30, 18, 0),
//         decoration: BoxDecoration(
//           color: Colors.grey[350],
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: TextFormField(
//           controller: _passwordController,
//           obscureText: true,
//           // Hides the password input
//           keyboardType: TextInputType.number,
//           // Allows only numbers
//           autovalidateMode: _isValidationEnabled ? AutovalidateMode.always : AutovalidateMode.disabled,
//           validator: (String? value) {
//             if (value == null || value.isEmpty) {
//               return 'Please enter your password';
//             }
//             if (value.length < 6) {
//               return 'Password must be at least 6 characters';
//             }
//             return null;
//           },
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 20,
//           ),
//           decoration: InputDecoration(
//             hintText: 'Enter your password',
//             labelText: 'Password',
//             contentPadding: EdgeInsets.fromLTRB(5, 18, 0, 0),
//             hintStyle: TextStyle(
//               color: Colors.black38,
//               fontSize: 20,
//             ),
//             labelStyle: TextStyle(color: Colors.black38),
//             border: InputBorder.none,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget getConfirmPasswordTextFieldWidget() {
//     return Form(
//       key: _confirmPasswordFormKey,
//       child: Container(
//         height: 80,
//         margin: EdgeInsets.fromLTRB(18, 30, 18, 0),
//         decoration: BoxDecoration(
//           color: Colors.grey[350],
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: TextFormField(
//           controller: _confirmPasswordController,
//           obscureText: true,
//           // Hides the password input
//           keyboardType: TextInputType.number,
//           // Allows only numbers
//           autovalidateMode: _isValidationEnabled ? AutovalidateMode.always : AutovalidateMode.disabled,
//           validator: (String? value) {
//             if (value == null || value.isEmpty) {
//               return 'Please enter your password';
//             }
//             if (_passwordController.text != _confirmPasswordController.text) {
//               return "Password doesn't match";
//             }
//           },
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 20,
//           ),
//           decoration: InputDecoration(
//             hintText: 'Enter your Confirm password',
//             labelText: 'Confirm Password',
//             contentPadding: EdgeInsets.fromLTRB(5, 18, 0, 0),
//             hintStyle: TextStyle(
//               color: Colors.black38,
//               fontSize: 20,
//             ),
//             labelStyle: TextStyle(color: Colors.black38),
//             border: InputBorder.none,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget getConfirmButton() {
//     final userProvider = Provider.of<UserProvider>(context);
//     return Container(
//       height: 80,
//       padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: () async {
//           setState(() {
//             _isValidationEnabled = true;
//           });
//           validateEmail();
//           UserModel? user = await UserController().signUpWithEmail(
//             _emailController.text,
//             _passwordController.text,
//             context as String,
//           );
//
//           if (!mounted) return;
//
//           if (user != null) {
//             if (_passwordController.text == _confirmPasswordController.text) {
//               // Success - navigate to complete profilex
//               Navigator.of(context).pushReplacementNamed('/NewProfileScreen');
//             }
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Sign up failed. Please try again.'))
//             );
//           }
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.deepPurpleAccent,
//           elevation: 0,
//         ),
//         child: Text(
//           'Continue',
//           style: TextStyle(color: Colors.white, fontSize: 20),
//         ),
//       ),
//     );
//   }
// }