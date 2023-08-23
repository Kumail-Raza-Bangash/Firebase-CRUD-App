import 'package:firebase002/phone_auth/phoneOtp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

import '../email_auth/signin.dart';

class SignInWithPhone extends StatefulWidget {
  const SignInWithPhone({Key? key}) : super(key: key);

  @override
  State<SignInWithPhone> createState() => _SignInWithPhoneState();
}

class _SignInWithPhoneState extends State<SignInWithPhone> {
  TextEditingController phoneController = TextEditingController();
  bool isOTPSent = false;

  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  void sendOTP() async {
    setState(() {
      isOTPSent = true; // Mark OTP as sent when sendOTP is called
    });

    String phone = "+92" + phoneController.text.trim();

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      codeSent: (verificationId, resendToken) {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => VerifyOtpScreen(
              verificationId: verificationId,
            ),
          ),
        );
      },
      verificationCompleted: (credential) {},
      verificationFailed: (ex) {
        setState(() {
          isOTPSent = false; // Hide the progress bar
        });
        showErrorSnackbar(ex.code.toString());
      },
      codeAutoRetrievalTimeout: (verificationId) {
        setState(() {
          isOTPSent = false; // Hide the progress bar
        });
      },
      timeout: Duration(seconds: 30),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Sign In with Phone"),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  if (isOTPSent)
                    FAProgressBar(
                      currentValue:
                          100, // Use null for an indeterminate progress bar
                      progressColor: Colors.green, // Change color to black
                      size: 5, // Adjust size to small
                    )
                  else
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        icon: const Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: const Icon(Icons.phone),
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  CupertinoButton(
                    onPressed: () {
                      sendOTP();
                    },
                    color: Colors.green,
                    child: Text("Sign In"),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      TextButton(
                        child: Text(
                          'Login with Email',
                          style: TextStyle(fontSize: 14),
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => Signin()));
                        },
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
