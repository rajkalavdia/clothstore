import 'package:clotstoreapp/views/profile-Screen/editProfileScreen.dart';
import 'package:clotstoreapp/views/signIn/signInScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../backend/provider/userProvider/userProvider.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/ProfileScreen';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String editName = " Loading....";
  String editEmail = " Loading....";
  String editNumber = " Loading....";
  UserProvider? userProvider;

  void getUserDetails() async {
    print("getUserDetails");

    if (!context.mounted) return print("context.mounted");

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;
    print('user UId : ${user?.uid}');
    if (user != null) {
      setState(() {
        editName = user.name ?? "No Name";
        editEmail = user.email ?? "No Email";
        editNumber = user.phoneNumber ?? "No Number";
      });
      print("Edit Name : $editName");
      print("Edit Email : $editEmail");
      print("Edit Number : $editNumber");
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    userProvider = context.read<UserProvider>();
    getUserDetails();
  }

  Future<void> signout() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 110,
          width: 110,
          margin: EdgeInsets.only(top: 90),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
          child: ClipOval(
            child: Image.asset(
              'asset/images/profile_picture.jpg',
              fit: BoxFit.fill,
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
            await signout();
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
