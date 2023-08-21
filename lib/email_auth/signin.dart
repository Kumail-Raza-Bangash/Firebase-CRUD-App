import 'package:firebase002/email_auth/signup.dart';
import 'package:firebase002/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../phone_auth/login.dart';
//import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
//import 'package:animated_text_kit/animated_text_kit.dart';

class Signin extends StatefulWidget {
  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

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

  void login() async {
    String emailAddress = emailController.text.trim();
    String password = passwordController.text.trim();

    if (emailAddress.isEmpty || password.isEmpty) {
      showErrorSnackbar("Please fill all the details");
      return;
    } else {
      setState(() {
        isLoading = true; // Show progress bar
      });

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailAddress, password: password);
        if (userCredential.user != null) {
          setState(() {
            isLoading = false; // Hide progress bar
          });

          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false; // Hide progress bar
        });
        if (e.code == 'user-not-found') {
          showErrorSnackbar('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          showErrorSnackbar('Wrong password provided for that user.');
        } else {
          showErrorSnackbar('Error: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                const Icon(
                  Icons.lock_outline,
                  size: 80,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed:
                      isLoading ? null : login, // Disable button during loading
                  child: isLoading
                      ? CircularProgressIndicator() // Show progress indicator
                      : Text('Signin'),
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Text('Does not have account?'),
                    TextButton(
                      child: Text(
                        'Sign up',
                        style: TextStyle(fontSize: 14),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => Signup()));
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                Row(
                  children: <Widget>[
                    TextButton(
                      child: Text(
                        'Login with Phone',
                        style: TextStyle(fontSize: 14),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => SignInWithPhone()));
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
