// ignore_for_file: sort_child_properties_last

import 'package:chat_app/pages/Login&signUp/sign_inpage.dart';
import 'package:chat_app/pages/Login&signUp/sign_uppage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GetStart extends StatelessWidget {
  GetStart({super.key});

  void onPressedSignIn() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              height: 45,
              width: 45,
              child: Image.asset(
                'assets/images/chat.jpeg',
              ),
            ),
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Get Started",
                style: GoogleFonts.junge(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold)),
            Text(
              "Start with signing up or sign in.",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 100,
            ),
            Image.asset(
              'assets/icons/appIcon.jpeg',
              width: 300,
            ),
            SizedBox(
              height: 100,
            ),
            Button(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignUp()));
                },
                buttonName: "Sign Up",
                buttonColor: Colors.blue,
                textColor: Colors.white),
            SizedBox(
              height: 20,
            ),
            Button(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignIn()));
                },
                buttonName: "Sign In",
                buttonColor: Colors.white,
                textColor: Colors.black)
          ],
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonName;
  final Color textColor;
  final Color buttonColor;
  const Button(
      {super.key,
      required this.onPressed,
      required this.buttonName,
      required this.buttonColor,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        buttonName,
        style: TextStyle(color: textColor, fontSize: 16),
      ),
      style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor, fixedSize: Size(200, 30)),
    );
  }
}
