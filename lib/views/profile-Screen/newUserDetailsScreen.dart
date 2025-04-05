import 'package:clotstoreapp/backend/controller/signInController.dart';
import 'package:clotstoreapp/backend/provider/userProvider/userProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewProfileScreen extends StatefulWidget {
  static const String routeName = "/NewProfileScreen";

  const NewProfileScreen({super.key});

  @override
  State<NewProfileScreen> createState() => _NewProfileScreenState();
}

class _NewProfileScreenState extends State<NewProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _numberController;
  late TextEditingController _passwordController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _numberFrmKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _emailFrmKey = GlobalKey<FormState>();

  bool _isValidationEnabled = false;
  bool _isNumberValidationEnabled = false;
  bool _isNameValidationEnabled = false;

  bool isEmailEnabled = true;
  bool isNumberEnabled = true;
  bool isNameEnabled = true;

  late UserProvider userProvider;
  bool _dataLoaded = false;

  String? userData;

  bool _isLoading = false;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  Future<void> loadExistingData() async {
    final user = userProvider.user;
    print('User Model : ${user?.uid}');
    if (user != null) {
      setState(() {
        _nameController.text = user.name ?? '';
        _numberController.text = user.phoneNumber ?? '';
        _emailController.text = user.email!;

        switch (user.signInMethod) {
          case 'email':
            isEmailEnabled = false;
            break;
          case 'google':
            isNameEnabled = false;
            isEmailEnabled = false;
            break;
          case 'phone':
            isNumberEnabled = false;
            break;
        }
      });
    }
  }

  Future<String?> validateEmail() async {
    String email = _emailController.text.trim();
    final CollectionReference docRef = FirebaseFirestore.instance.collection('users');
    try {
      QuerySnapshot querySnapshot = await docRef.where('email', isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty && userProvider.user?.email != email) {
        return "This email already exists";
      }
    } catch (e) {
      return "Error checking email: $e";
    }
    return null;
  }

  Future<String?> validateNumberExists() async {
    String number = _numberController.text.trim();
    final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
    try {
      QuerySnapshot querySnapshot = await usersCollection.where('number', isEqualTo: number).get();
      if (querySnapshot.docs.isNotEmpty && userProvider.user?.phoneNumber != number) {
        return "This phone number is already registered. Please use a different number.";
      }
    } catch (e) {
      return "Error checking phone number: $e";
    }
    return null;
  }

  Future<void> _handleSubmit() async {
    setState(() {
      _isNumberValidationEnabled = true;
      _isValidationEnabled = true;
      _isNameValidationEnabled = true;
      _isLoading = true;
    });

    if (!_formKey.currentState!.validate() || !_emailFrmKey.currentState!.validate() || !_numberFrmKey.currentState!.validate()) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    String? emailError;
    String? numberError;

    if (isEmailEnabled && _emailController.text.isNotEmpty) {
      emailError = await validateEmail();
    }

    if (isNumberEnabled && _numberController.text.isNotEmpty) {
      numberError = await validateNumberExists();
    }

    if (emailError != null || numberError != null) {
      _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(emailError ?? numberError ?? '')));
      setState(() {
        _isLoading = false;
      });
      return;
    }

    bool success = await UserController().updateUserProfile(
      name: (isNameEnabled && _nameController.text.isNotEmpty) ? _nameController.text : null,
      phoneNumber: (isNumberEnabled && _numberController.text.isNotEmpty) ? _numberController.text : null,
      email: (isEmailEnabled && _emailController.text.isNotEmpty) ? _emailController.text : null,
    );
    setState(() {
      _isLoading = false;
    });

    print("success : $success");
    if (success) {
      Navigator.of(context).pushReplacementNamed('/MainScreen');
    } else {
      _scaffoldKey.currentState?.showSnackBar(
        const SnackBar(content: Text('Failed to update profile. Please try again.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    print("NewProfileScreen initState called");
    // Initialize controllers if not already initialized
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _numberController = TextEditingController();
    _passwordController = TextEditingController();
    userData;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDependencies called, _dataLoaded = $_dataLoaded");
    if (!_dataLoaded) {
      _dataLoaded = true;
      print("Setting _dataLoaded to true");
      userProvider = Provider.of<UserProvider>(context, listen: false);
      loadExistingData();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("usernUid : $userData");
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        getHeader(),
                        getNameTextField(),
                        getEmailTextField(),
                        getNumberTextField(),
                        getSubmit(),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget getHeader() {
    return Center(
      child: Text(
        'New Profile',
        style: TextStyle(fontSize: 30),
      ),
    );
  }

  Widget getNameTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          TextFormField(
            style: const TextStyle(fontSize: 15, color: Colors.black),
            controller: _nameController,
            enabled: isNameEnabled,
            autovalidateMode: _isNameValidationEnabled ? AutovalidateMode.always : AutovalidateMode.disabled,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the Name';
              }
              String pattern = r'^[A-Za-z0-9\s-/]+$';
              if (!RegExp(pattern).hasMatch(value)) {
                return 'Only Alphabets allowed';
              }
              return null;
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.green.shade50,
              hintText: "Enter Your Name",
              hintStyle: const TextStyle(color: Colors.black38),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
        ],
      ),
    );
  }

  Widget getEmailTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Email", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Form(
            key: _emailFrmKey,
            child: TextFormField(
              style: const TextStyle(fontSize: 15, color: Colors.black),
              controller: _emailController,
              enabled: isEmailEnabled,
              keyboardType: TextInputType.emailAddress,
              autovalidateMode: _isValidationEnabled ? AutovalidateMode.always : AutovalidateMode.disabled,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the email';
                }
                if (!value.contains('@') || !value.endsWith('gmail.com')) {
                  return 'Please enter a valid Gmail address';
                }
                validateEmail();
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.red.shade50,
                hintText: "Enter Your Email",
                hintStyle: const TextStyle(color: Colors.black38),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getNumberTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Number", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Form(
            key: _numberFrmKey,
            child: TextFormField(
              style: const TextStyle(fontSize: 15, color: Colors.black),
              controller: _numberController,
              enabled: isNumberEnabled,
              keyboardType: TextInputType.number,
              autovalidateMode: _isNumberValidationEnabled ? AutovalidateMode.always : AutovalidateMode.disabled,
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
                filled: true,
                fillColor: Colors.purple.shade50,
                hintText: "Enter Your Number",
                hintStyle: const TextStyle(color: Colors.black38),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getSubmit() {
    return Container(
      height: 80,
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurpleAccent,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Submit',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _numberController.dispose();
    super.dispose();
  }
}
