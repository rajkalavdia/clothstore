import 'package:clotstoreapp/backend/provider/userProvider/userProvider.dart';
import 'package:clotstoreapp/views/profile-Screen/editProfileScreen.dart';
import 'package:clotstoreapp/views/signIn/signInScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/ProfileScreen';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final user = FirebaseAuth.instance.currentUser;
  GoogleSignIn _googleSignIn = GoogleSignIn();


  void signout() async{
    await _googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
  }

  late UserProvider userProvider;


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
    userProvider = context.watch<UserProvider>();
    final editName = (userProvider.profileModel.name.isEmpty)
        ? "Riddhi patel"
        : userProvider.profileModel.name;

    final editEmail = (userProvider.profileModel.email.isEmpty)
        ? "${user?.email}"
        : userProvider.profileModel.email;

    final editNumber = (userProvider.profileModel.phoneNumber.isEmpty)
        ? "+91 9544435648"
        : userProvider.profileModel.phoneNumber;
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
            onTap: (){
              Navigator.pushNamed(context, EditProfileScreen.routeName,
                arguments: <String , String>{
                  "EditName": editName,
                  "EditEmail": editEmail,
                  "EditNumber": editNumber,
                }
              );
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
            // SharedPreferences prefs = await SharedPreferences.getInstance();
            // await prefs.setBool('isSignedIn', false);
            signout();
            Navigator.pushNamed(context, SignInScreen.routeName);
            Navigator.popUntil(context, (route) => route.settings.name == SignInScreen.routeName);
          },
          child: Text(
            'Sign Out',
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ],
    );
  }
}
