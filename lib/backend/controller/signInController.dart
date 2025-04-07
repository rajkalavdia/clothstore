import 'package:clotstoreapp/backend/provider/userProvider/userProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../model/userModel.dart';

class UserController {
  UserProvider? userProvider;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Try this version of getUserProvider for additional safety
  UserProvider getUserProvider(BuildContext context) {
    try {
      final provider = Provider.of<UserProvider>(context, listen: false);
      print("Successfully got UserProvider: $provider");
      return provider;
    } catch (e) {
      print("Error getting UserProvider: $e");
      // Fallback - create a new provider if needed
      return UserProvider();
    }
  }

  // Sign up with email and password
  Future<UserModel?> signUpWithEmail(context, String email, String password) async {
    try {
      // Create user in Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Create UserModel with the Firebase Auth UID
        UserModel newUser = UserModel(
          email: email,
          uid: user.uid,
          // Using Firebase's unique ID
          signInMethod: 'email',
          password: password,
          profileComplete: false,
          // New user = incomplete profile
          createdAt: DateTime.now(),
          lastLogin: DateTime.now(),
        );

        // Save to Firestore
        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());

        userProvider = getUserProvider(context);
        userProvider?.setUser(newUser);

        return newUser;
      }
      return null;
    } catch (e) {
      print('Error in signUpWithEmail: $e');
      return null;
    }
  }

  // Sign in with Google
  Future<UserModel?> signInWithGoogle(context) async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User canceled sign-in

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        // Check if user already exists in Firestore
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          // User exists, load their data
          UserModel userModel = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
          UserProvider userProvider = getUserProvider(context);
          userProvider.setUser(userModel);

          return userModel;
        } else {
          // New user, create record in Firestore
          UserModel newUser = UserModel(
            email: user.email ?? '',
            name: user.displayName!,
            uid: user.uid,
            signInMethod: 'google',
          );

          await _firestore.collection('users').doc(user.uid).set(newUser.toMap());

          userProvider = getUserProvider(context);
          userProvider?.setUser(newUser);
          return newUser;
        }
      }
      return null;
    } catch (e) {
      print('Error in signInWithGoogle: $e');
      return null;
    }
  }

  // Sign in with phone number
  Future<UserModel?> signInWithPhone(String phoneNumber, String verificationId, String smsCode, context) async {
    try {
      print("Starting phone authentication...");

      // Create PhoneAuthCredential
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      print('Created credential with Verification ID: $verificationId and SMS Code: $smsCode');

      // Sign in with credential
      print("Attempting to sign in with credential...");
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      print("Sign in completed. UserCredential: $userCredential");

      User? user = userCredential.user;
      print("User object: $user");
      print("User UID: ${user?.uid}");
      print("User phone: ${user?.phoneNumber}");

      if (user != null) {
        print("User is not null, checking if exists in Firestore...");
        // Check if user already exists
        try {
          DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
          print("Firestore lookup completed");
          print("Document exists: ${userDoc.exists}");
          print("Document data: ${userDoc.data()}");

          if (userDoc.exists) {
            // User exists, load their data
            print("User exists in Firestore, loading data...");
            UserModel userModel = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
            print("User model created from Firestore: $userModel");

            await _firestore.collection('users').doc(user.uid).update({
              'lastLogin': DateTime.now(),
            });
            print("Updated last login time");

            userProvider = getUserProvider(context);
            print("UserProvider: $userProvider");
            userProvider?.setUser(userModel);
            print("User set in provider");
            return userModel;
          } else {
            // New user, create record
            print("User doesn't exist in Firestore, creating new record...");
            UserModel newUser = UserModel(
              email: '',
              uid: user.uid,
              phoneNumber: user.phoneNumber,
              signInMethod: 'phone',
              profileComplete: false,
              createdAt: DateTime.now(),
              lastLogin: DateTime.now(),
            );
            print("Created new user model: $newUser");
            print("New user UID: ${newUser.uid}");

            print("Saving to Firestore...");
            try {
              await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
              print("Successfully saved to Firestore");
            } catch (e) {
              print("Error saving to Firestore: $e");
            }

            try {
              userProvider = getUserProvider(context);
              print("Got UserProvider: $userProvider");
              userProvider?.setUser(newUser);
              print("Set user in provider");
            } catch (e) {
              print("Error setting user in provider: $e");
            }

            return newUser;
          }
        } catch (e) {
          print("Error checking user in Firestore: $e");
          return null;
        }
      } else {
        print("User is null after authentication");
        return null;
      }
    } catch (e) {
      print('Error in signInWithPhone: $e');
      return null;
    }
  }

  // Update user profile
  Future<bool> updateUserProfile({String? name, String? email, String? phoneNumber, required BuildContext context}) async {
    UserModel? userModel = getUserProvider(context).user;

    try {
      if (_auth.currentUser == null) return false;

      String uid = _auth.currentUser!.uid;
      Map<String, dynamic> updateData = {};

      if (name != null && name.isNotEmpty) {
        updateData['name'] = name;
      }

      if (email != null && email.isNotEmpty) {
        updateData['email'] = email;
      }

      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        updateData['phoneNumber'] = phoneNumber;
      }

      if (userModel != null && isProfileComplete(userModel)) {
        updateData['profileComplete'] = true;
      }

      print("updateData : $updateData");

      await _firestore.collection('users').doc(uid).update(updateData);

      if (name != null && name.isNotEmpty) {
        userModel?.name = name;
      }

      if (email != null && email.isNotEmpty) {
        userModel?.email = email;
      }

      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        userModel?.phoneNumber = phoneNumber;
      }

      if (userModel != null && isProfileComplete(userModel)) {
        userModel.profileComplete = true;
      }

      print('usermodel name : ${userModel?.name}');
      print('usermodel email : ${userModel?.email}');
      print('usermodel phoneNumber : ${userModel?.phoneNumber}');
      print('usermodel profileComplete : ${userModel?.profileComplete}');

      return true;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }

  // Check if profile is complete based on sign-in method
  bool isProfileComplete(userModel) {
    // If already marked as complete, return true
    if (userModel.profileComplete == true) {
      return true;
    }

    // Otherwise check based on authentication method
    switch (userModel.signInMethod) {
      case 'email':
        return userModel.name != null && userModel.phoneNumber != null;
      case 'google':
        return userModel.phoneNumber != null;
      case 'phone':
        return userModel.name != null && userModel.email.isNotEmpty;
      default:
        return false;
    }
  }

  // Sign in existing user with email/password
  Future<UserModel?> signInUser(String email, String password, context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          UserModel userModel = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

          DateTime lastLogin = DateTime.now();
          await _firestore.collection('users').doc(user.uid).update({
            'lastLogin': lastLogin,
          });
          userModel.lastLogin = lastLogin;
          userProvider = getUserProvider(context);
          userProvider?.setUser(userModel);
          return userModel;
        } else if (user.displayName == null || user.email == null || user.phoneNumber == null) {
          UserModel newUser = UserModel(
            email: user.email,
            name: user.displayName,
            phoneNumber: user.phoneNumber,
            uid: user.uid,
            signInMethod: 'email',
            profileComplete: false,
          );

          try {
            await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
            userProvider = getUserProvider(context);
            userProvider?.setUser(newUser);
          } catch (e) {
            print("Error saving to Firestore: $e");
          }
          return newUser;
        }
      }
      return null;
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  // Load user data on app start (for SplashScreen)
  Future<UserModel?> loadUserData(context) async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();

        if (userDoc.exists) {
          UserModel userModel = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

          // Update last login time
          DateTime lastLogin = DateTime.now();

          await _firestore.collection('users').doc(userModel.uid).update({
            'lastLogin': lastLogin,
          });
          userModel.lastLogin = lastLogin;
          userProvider = getUserProvider(context);
          userProvider?.setUser(userModel);
          print("user Model for get data : ${userModel.uid}");
          return userModel;
        }
      }
      return null;
    } catch (e) {
      print('Error loading user data: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
