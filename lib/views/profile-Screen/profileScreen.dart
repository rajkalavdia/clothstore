import 'package:clotstoreapp/views/profile-Screen/editProfileScreen.dart';
import 'package:clotstoreapp/views/signIn/signInScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../backend/controller/profilePictureController.dart';
import '../../backend/provider/userProvider/userProvider.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/ProfileScreen';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String editName = " Loading....";
  String editEmail = " Loading....";
  String editNumber = " Loading....";
  UserProviderInUserApp userProvider = UserProviderInUserApp();

  String? image;

  void getUserDetails() async {
    print("getUserDetails");

    if (!context.mounted) return print("context.mounted");

    final userProvider = Provider.of<UserProviderInUserApp>(context, listen: false);
    final user = userProvider.user;
    print('user UId : ${user?.uid}');
    if (user != null) {
      if (mounted) setState(() {});
      editName = user.name ?? "No Name";
      editEmail = user.email ?? "No Email";
      editNumber = user.phoneNumber ?? "No Number";
      print("Edit Name : $editName");
      print("Edit Email : $editEmail");
      print("Edit Number : $editNumber");
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    userProvider.clearUser();
  }

  @override
  void initState() {
    super.initState();
    userProvider = context.read<UserProviderInUserApp>();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              getUserImageWidget(),
              getUserDetailsWidget(context),
              getAddressWidget(),
              getWishlistWidget(),
              getPaymentsWidget(),
              getHeplWidget(),
              getSupportWidget(),
              signOutButtonWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget getUserImageWidget() {
    return Stack(
      children: [
        (userProvider.user?.imageUrl != null)
            ? Container(
                height: 100,
                width: 100,
                margin: EdgeInsets.only(top: 90),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                ),
                child: ClipOval(
                  child: Image.network(
                    userProvider.user!.imageUrl,
                    fit: BoxFit.cover,
                    height: 100,
                  ),
                ),
              )
            : Container(
                height: 100,
                width: 100,
                margin: EdgeInsets.only(top: 90),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
                child: ClipOval(
                  child: Image.asset(
                    'asset/images/profile_picture.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
        Positioned(
          bottom: 1,
          left: 60,
          child: Container(
            height: 35,
            width: 35,
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)),
            child: IconButton(
              onPressed: () async {
                try {
                  await uploadProfilePicture(userProvider);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Profile picture uploaded')),
                  );
                  setState(() {});
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to upload profile picture')),
                  );
                }
              },
              icon: Icon(
                Icons.add_a_photo_outlined,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getUserDetailsWidget(BuildContext context) {
    return Container(
      height: 110,
      margin: EdgeInsets.fromLTRB(15, 20, 15, 15),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                editName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                editEmail,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black38,
                ),
              ),
              Text(
                editNumber,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black38,
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, EditProfileScreen.routeName, arguments: <String, String>{
                "EditName": editName,
                "EditEmail": editEmail,
                "EditNumber": editNumber,
              });
            },
            child: Text(
              'Edit',
              style: TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget getAddressWidget() {
    return Container(
      height: 60,
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Address',
            style: TextStyle(fontSize: 20),
          ),
          Image.asset(
            'asset/icons/arrowrightBlack.png',
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget getWishlistWidget() {
    return Container(
      height: 60,
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'WishList',
            style: TextStyle(fontSize: 20),
          ),
          Image.asset(
            'asset/icons/arrowrightBlack.png',
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget getPaymentsWidget() {
    return Container(
      height: 60,
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Payments',
            style: TextStyle(fontSize: 20),
          ),
          Image.asset(
            'asset/icons/arrowrightBlack.png',
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget getHeplWidget() {
    return Container(
      height: 60,
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Help',
            style: TextStyle(fontSize: 20),
          ),
          Image.asset(
            'asset/icons/arrowrightBlack.png',
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget getSupportWidget() {
    return Container(
      height: 60,
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Support',
            style: TextStyle(fontSize: 20),
          ),
          Image.asset(
            'asset/icons/arrowrightBlack.png',
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget signOutButtonWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async {
            await signOut();
            Navigator.pushNamed(context, SignInScreen.routeName);
            Navigator.popUntil(context, (route) => route.settings.name == SignInScreen.routeName);
          },
          child: Text(
            'Sign Out',
            style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
