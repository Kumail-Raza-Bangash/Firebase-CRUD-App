import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'email_auth/signin.dart';
import 'firebase_options.dart';
import 'homePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: myTheme,
      home:
          (FirebaseAuth.instance.currentUser != null) ? HomeScreen() : Signin(),
    );
  }
}

ColorScheme myColorScheme = ColorScheme(
  primary: Colors.black, // Replace with your desired primary color
  //primaryVariant: Colors.black[700], // Replace with a slightly darker shade
  secondary: Colors.black12, // Replace with your desired secondary color
  //secondaryVariant: Colors.black12, // Replace with a slightly darker shade
  surface: Colors.white, // Replace with your desired surface color
  background: Colors.white, // Replace with your desired background color
  error: Colors.red, // Replace with your desired error color
  onPrimary: Colors.white,
  onSecondary: Colors.black,
  onSurface: Colors.black,
  onBackground: Colors.black,
  onError: Colors.white,
  brightness: Brightness.light,
);

ThemeData myTheme = ThemeData.from(
  colorScheme: myColorScheme,
);
