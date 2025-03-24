import 'package:clotstoreapp/backend/provider/userProvider/userProvider.dart';
import 'package:clotstoreapp/model/profileModel.dart';
import 'package:clotstoreapp/views/Profile-Screen/profileScreen.dart';
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

  late UserProvider userProvider;

  @override
  void didChangeDependencies() {
    // TODO: implement initState
    super.didChangeDependencies();
    final preFillValueArgs = ModalRoute.of(context)!.settings.arguments as Map<String , String>;
    final preFillName = preFillValueArgs["EditName"];
    final preFillEmail = preFillValueArgs["EditEmail"];
    final preFillNumber = preFillValueArgs["EditNumber"];

    _nameController.text = preFillName!;
    _emailController.text = preFillEmail!;
    _numberController.text = preFillNumber!;
  }
   void editProfileModel(){
      ProfileModel updateProfileModel = ProfileModel(
        name: _nameController.text,
        email: _emailController.text,
        phoneNumber: _numberController.text,
      );
      userProvider.profileModelUpdate(updateProfileModel);
    }

  @override
  Widget build(BuildContext context) {
    userProvider = context.watch<UserProvider>();
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
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Colors.black12),
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
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.black12),
          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Name",
              hintText: "Enter Name",
              labelStyle: TextStyle(color: Colors.black),
              hintStyle: TextStyle(color: Colors.black38),
              border: InputBorder.none,
              // fillColor: Colors.black12,
              // filled: true,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.black12),
          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: "Email",
              hintText: "example1234@gmail.com",
              labelStyle: TextStyle(color: Colors.black),
              hintStyle: TextStyle(color: Colors.black38),
              border: InputBorder.none,
              // fillColor: Colors.black12,
              // filled: true,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.black12),
          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: TextFormField(
            controller: _numberController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Number",
              hintText: "Enter Number",
              labelStyle: TextStyle(color: Colors.black),
              hintStyle: TextStyle(color: Colors.black38),
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
          onTap: () {
            editProfileModel();
            Navigator.pop(context);
          },
          child: Container(
            height: 50,
            width: 80,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Colors.deepPurpleAccent),
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
