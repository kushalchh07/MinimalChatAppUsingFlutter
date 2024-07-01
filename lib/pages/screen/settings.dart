import 'package:chat_app/constants/colors/colors.dart';
import 'package:chat_app/pages/Login&signUp/sign_inpage.dart';
import 'package:chat_app/pages/screen/profile_image_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../constants/Sharedpreferences/sharedpreferences.dart';
import '../../services/auth_services.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => SettingsState();
}

void signOut() {
  AuthService.logout();
  saveStatus(false);
  Get.offAll(() => SignIn());
}

class SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        color: appBackgroundColor,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Settings"),
              ElevatedButton(onPressed: signOut, child: Text("SignOut")),
              ElevatedButton(
                  onPressed: () {
                    Get.to(() => ProfileImageScreen());
                  },
                  child: Text("Profile Image")),
            ],
          ),
        ),
      ),
    );
  }
}
