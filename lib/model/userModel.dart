import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? email;
  final String? password;
  String? name;
  String? phoneNumber;
  String? signInMethod; // "email", "google", or "phone"
  String? imageUrl;
  bool profileComplete; // New field to track profile completion
  DateTime createdAt; // New field to track account creation time
  DateTime lastLogin; // New field to track last login time

  UserModel({
    this.uid,
    this.email,
    this.password,
    this.name,
    this.phoneNumber,
    this.signInMethod,
    this.imageUrl,
    this.profileComplete = false, // Default to false for new users
    DateTime? createdAt,
    DateTime? lastLogin,
  })  : this.createdAt = createdAt ?? DateTime.now(),
        this.lastLogin = lastLogin ?? DateTime.now();

  // Convert UserModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'password': password,
      'name': name,
      'phoneNumber': phoneNumber,
      'signInMethod': signInMethod,
      'imageUrl': imageUrl,
      'profileComplete': profileComplete,
      'createdAt': createdAt,
      'lastLogin': lastLogin,
    };
  }

  // Create UserModel from Firestore data
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      signInMethod: map['signInMethod'],
      imageUrl: map['imageUrl'],
      profileComplete: map['profileComplete'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastLogin: (map['lastLogin'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
