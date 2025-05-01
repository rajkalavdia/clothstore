import 'package:clothstore_admin_pannel/model/user/userModel.dart';
import 'package:clotstoreapp/backend/provider/userProvider/userProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  static const String routeName = '/EditProfileScreen';

  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  late UserProviderInUserApp userProvider;

  Future<String?> validateUserDetails({String? name}) async {
    final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

    try {
      // Check for existing name (optional)
      if (name != null && name.isNotEmpty) {
        QuerySnapshot nameQuery = await usersCollection.where('name', isEqualTo: name).get();
        if (nameQuery.docs.isNotEmpty) {
          return "This name is already taken. Please choose a different one.";
        }
      }
    } catch (e) {
      return "Error checking user details: $e";
    }

    return null;
  }

  Future<UserModel?> userProfileModel(BuildContext context) async {
    String newName = _nameController.text.trim();

    String? validationError = await validateUserDetails(name: newName);

    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(validationError)));
      return null;
    }
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    UserModel? user = userProvider.user;
    print(" User model in user uid  : ${user!.uid}");
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        user = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
        user.name = newName;
        user.lastLogin = DateTime.now();

        await _firestore.collection('users').doc(user.uid).update({
          'lastLogin': user.lastLogin,
          'name': newName,
        });

        userProvider.setUser(user);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Profile updated successfully!"),
          ),
        );

        if (mounted) {
          Navigator.pop(context);
        }
        return user;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("User document does not exist"),
          ),
        );
      }
    } catch (e) {
      print("Error checking user in Firestore: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update profile: $e"),
        ),
      );
    }
    return null;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement initState
    super.didChangeDependencies();
    final preFillValueArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final preFillName = preFillValueArgs["EditName"];
    final preFillEmail = preFillValueArgs["EditEmail"];
    final preFillNumber = preFillValueArgs["EditNumber"];

    _nameController.text = preFillName!;
    _emailController.text = preFillEmail!;
    _numberController.text = preFillNumber!;

    userProvider = Provider.of<UserProviderInUserApp>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            getHeader(),
            getTextFieldForEdit(),
            Expanded(child: SizedBox()),
            getSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget getHeader() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 50,
            width: 50,
            padding: EdgeInsets.all(11),
            margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Colors.black12,
            ),
            child: Image.asset('asset/icons/arrowleftBlack.png'),
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 14, 0, 0),
          child: Text(
            'Edit Profile',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Spacer(),
      ],
    );
  }

  Widget getTextFieldForEdit() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.black12,
          ),
          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Name",
              hintText: "Enter Name",
              labelStyle: TextStyle(color: Colors.black38),
              border: InputBorder.none,
              // fillColor: Colors.black12,
              // filled: true,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.black12,
          ),
          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: TextFormField(
            enabled: false,
            controller: _emailController,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: "Email",
              hintText: "example1234@gmail.com",
              labelStyle: TextStyle(color: Colors.black38),
              border: InputBorder.none,
              // fillColor: Colors.black12,
              // filled: true,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.black12,
          ),
          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: TextFormField(
            enabled: false,
            controller: _numberController,
            keyboardType: TextInputType.number,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: "Number",
              labelStyle: TextStyle(color: Colors.black38),
              border: InputBorder.none,
              // fillColor: Colors.black12,
              // filled: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget getSaveButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async {
            await userProfileModel(context);
          },
          child: Container(
            height: 50,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Colors.deepPurpleAccent,
            ),
            child: Center(
              child: Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
