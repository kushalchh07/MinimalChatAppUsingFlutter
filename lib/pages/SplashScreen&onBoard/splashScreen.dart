import 'dart:async';

import 'package:chat_app/constants/colors/colors.dart';
import 'package:chat_app/pages/Chat/chat_screen.dart';
import 'package:chat_app/pages/Login&signUp/sign_inpage.dart';
import 'package:chat_app/pages/screen/base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Bloc/internetBloc/internet_bloc.dart';
import '../screen/internet_lost_screen.dart';

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
    return BlocListener<InternetBloc, InternetState>(
     listener: (context, state) {
          if (state is InternetDisconnected) {
            // Navigate to no internet screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InternetLostScreen()),
            );
          } else if (state is InternetConnected) {
            // Pop the NoInternetScreen if the internet is restored
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          }
        },
      child: Scaffold(
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
      ),
    );
  }
}
