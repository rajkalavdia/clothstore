import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:clotstoreapp/backend/controller/signInController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pinput/pinput.dart';

import '../../model/userModel.dart';

class OtpVerification extends StatefulWidget {
  static const String routeName = '/OtpVerification';

  OtpVerification({super.key});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  TextEditingController otpController = TextEditingController();
  CountDownController otpCounterController = CountDownController();
  bool? isCounterRestart;
  bool isLoading = false;

  String? number;
  String _verificationId = "";
  bool _codeSent = false;

  Future<void> _verifyOTP() async {
    if (otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the verification code')),
      );
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      UserModel? user = await UserController().signInWithPhone(
        number!,
        _verificationId,
        otpController.text.toString(),
        context,
      );
      print('widget.number : $number');
      print('widget.verificationID:$_verificationId');
      print('otpController.text:${otpController.text}');
      setState(() {
        isLoading = false;
      });
      print('object');
      print(" otp verification  user  : $user");
      if (user != null) {
        // Check if this user's profile is complete
        print('raj');
        if (UserController().isProfileComplete(user)) {
          // User has a complete profile, go directly to home
          print('hiiii');
          Navigator.of(context).pushReplacementNamed('/MainScreen');
        } else {
          // User needs to complete their profile
          Navigator.of(context).pushReplacementNamed('/NewProfileScreen');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Authentication failed. Please try again.')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification failed: $e')),
      );
    }
  }

  Future<void> _verifyPhone() async {
    if (number == null || number!.isEmpty) {
      return;
    }

    isLoading = true;
    if (mounted) setState(() {});

    print('isLoading : $isLoading');
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification on some Android devices
          await _auth.signInWithCredential(credential);
          print('Verification completed automatically');
        },
        verificationFailed: (FirebaseAuthException e) {
          isLoading = false;
          print("Verification failed: ${e.message}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed: ${e.message}')),
          );
        },
        codeSent: (String verificationId, int? resendToken) async {
          _verificationId = verificationId;
          _codeSent = true;
          isLoading = false;
          if (mounted) setState(() {});

          print('Verification ID: $verificationId');
          print("isLoading : $isLoading");
          await ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification code sent')),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-retrieval timeout
          _verificationId = verificationId;
          print('Auto-retrieval timeout: $verificationId');
        },
        timeout: const Duration(seconds: 120),
      );
    } catch (e) {
      isLoading = false;
      print("Error sending code: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending code: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      dynamic arguments = ModalRoute.of(context)?.settings.arguments;
      print("arguments:$arguments");

      final numberArgs = arguments as Map<String, String>;
      number = numberArgs["number"]!;
      _verifyPhone();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: CircularProgressIndicator(
        backgroundColor: Colors.transparent,
        color: Colors.black,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                getTitle(),
                getDescription(),
                buildPinPut(),
                getNotRecieveCodeText(),
                if (!isLoading) getOTPTimeCounter(),
                getSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: Text(
            'OTP Verification',
            style: TextStyle(
              color: Colors.black,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget getDescription() {
    return Column(
      children: [
        Text("We have sent OTP on ", style: TextStyle(fontSize: 20, color: Colors.black38)),
        Text("${number}. Enter OTP to", style: TextStyle(fontSize: 20, color: Colors.black38)),
        Text("complete verification.", style: TextStyle(fontSize: 20, color: Colors.black38)),
      ],
    );
  }

  Widget buildPinPut() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
      child: SizedBox(
        height: 60,
        child: Pinput(
          onCompleted: (pin) => print(pin),
          keyboardType: TextInputType.number,
          autofocus: true,
          controller: otpController,
          length: 6,
          smsRetriever: null,
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
          pinAnimationType: PinAnimationType.rotation,
          showCursor: true,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          closeKeyboardWhenCompleted: true,
          enabled: (isLoading == false) ? true : false,
        ),
      ),
    );
  }

  Widget getNotRecieveCodeText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("If you don't receive Code!", style: TextStyle(fontSize: 15, color: Colors.black38)),
        Padding(
          padding: const EdgeInsets.all(0),
          child: TextButton(
            onPressed: () {
              setState(() {});
              showDialog(context: context, builder: (context) => getOtpResentDailoge());
            },
            child: Text("Resend Otp", style: TextStyle(fontSize: 15, color: Colors.black)),
          ),
        ),
      ],
    );
  }

  Widget getOtpResentDailoge() {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green),
            padding: EdgeInsets.all(20),
            child: Icon(Icons.check_rounded, color: Colors.white, size: 40),
          ),
          SizedBox(height: 20),
          Text("OTP Resent Successfully!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("OK", style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }

  Widget getOTPTimeCounter() {
    return CircularCountDownTimer(
      key: UniqueKey(),
      duration: 120,
      initialDuration: 0,
      controller: otpCounterController,
      width: 80,
      height: 80,
      ringColor: Colors.transparent,
      fillColor: Colors.grey[300]!,
      backgroundColor: Colors.black,
      strokeWidth: 10.0,
      strokeCap: StrokeCap.round,
      textStyle: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
      textFormat: CountdownTextFormat.MM_SS,
      isReverse: true,
      isReverseAnimation: true,
      isTimerTextShown: true,
      autoStart: true,
      onStart: () {
        if (isCounterRestart == true) {
          otpCounterController.restart();
          print("isCounterRestart: $isCounterRestart");
        }
      },
    );
  }

  Widget getSubmitButton() {
    return Container(
      height: 80,
      margin: EdgeInsets.fromLTRB(18, 10, 18, 0),
      padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _verifyOTP(),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent, elevation: 0),
        child: Text('Submit', style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
    );
  }
}
