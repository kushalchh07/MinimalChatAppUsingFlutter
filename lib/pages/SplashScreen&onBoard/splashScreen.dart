import 'dart:async';

import 'package:chat_app/constants/colors/colors.dart';
import 'package:chat_app/pages/Chat/chat_screen.dart';
import 'package:chat_app/pages/Login&signUp/sign_inpage.dart';
import 'package:chat_app/pages/screen/base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static String KEYLOGIN = "login";

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToHome();
  }

  void navigateToHome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedin = prefs.getBool(SplashScreen.KEYLOGIN);

    Future.delayed(Duration(seconds: 2), () {
      if (isLoggedin != null && isLoggedin) {
        Get.offAll(() => Base());
      } else {
        Get.offAll(() => SignIn());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: SizedBox(
                width: Get.width * 0.50,
                child: Image.asset(
                  "assets/icons/appicon.png",
                  fit: BoxFit.fitWidth,
                  scale: 2,
                  height: 200,
                  width: 200,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
