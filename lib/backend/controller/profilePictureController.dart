import 'dart:io';

import 'package:clothstore_admin_pannel/model/user/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../provider/userProvider/userProvider.dart';

Future<void> uploadProfilePicture(UserProviderInUserApp userProvider) async {
  User? user = FirebaseAuth.instance.currentUser;
  final picker = ImagePicker();
  XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
  if (pickedImage != null) {
    File imageFile = File(pickedImage.path);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance.ref().child('user/${user!.uid}/$fileName');
    await ref.putFile(imageFile);
    String downloadURL = await ref.getDownloadURL();

    // Update Firestore with the new image URL
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'imageUrl': downloadURL,
      });

      // Update the user model in the provider
      UserModel? userModel = userProvider.user;
      if (userModel != null) {
        userModel.imageUrl = downloadURL;
        userProvider.setUser(userModel);
      }
    } else {
      throw Exception('User not logged in');
    }
  } else {
    throw Exception('No image selected');
  }
}

Future<void> updateProfilePicture(String downloadURL, UserProviderInUserApp userProvider) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    // Update Firestore with the new image URL
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'imageUrl': downloadURL,
    });

    // Update the user model in the provider
    UserModel? userModel = userProvider.user;
    if (userModel != null) {
      userModel.imageUrl = downloadURL;
      userProvider.setUser(userModel);
    }
  } else {
    throw Exception('User not logged in');
  }
}

// Future<void> deleteProfilePicture(UserProvider userProvider) async {
//   User? user = FirebaseAuth.instance.currentUser;
//   if (user != null) {
//     UserModel? userModel = userProvider.user;
//     if (userModel != null && userModel.imageUrl != null) {
//       // Delete the image from Firebase Storage
//       Reference ref = FirebaseStorage.instance.refFromURL(userModel.imageUrl!);
//       await ref.delete();
//
//       // Update Firestore with the new image URL (set to null)
//       await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
//         'imageUrl': null,
//       });
//
//       // Update the user model in the provider
//       userModel.imageUrl = null;
//       userProvider.setUser(userModel);
//     }
//   } else {
//     throw Exception('User not logged in');
//   }
// }
