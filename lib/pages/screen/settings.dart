import 'package:chat_app/constants/colors/colors.dart';
import 'package:chat_app/pages/Drawer/user_password.dart';
import 'package:chat_app/pages/Login&signUp/sign_inpage.dart';
// import 'package:chat_app/pages/screen/profile_image_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  void onTapPassword() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => UserPassword()));
  }

  void onTapDeleteAccount() {
    Fluttertoast.showToast(msg: "Work In progress");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBackgroundColor,
        title: const Text("Settings"),
      ),
      body: Container(
        height: Get.height,
        width: Get.width,
        color: appBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildListItem("Change Password", onTapPassword),
            buildListItem("Delete Account", onTapDeleteAccount)
          ],
        ),
      ),
    );
  }

  Widget buildListItem(String title, void Function() onTap) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, right: 10, left: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],

          // border: Border.all(color: Colors.black), // Border color
          borderRadius: BorderRadius.circular(20.0),
          // Border radius
        ),
        child: ListTile(
          minLeadingWidth: Checkbox.width,
          title: Text(
            title,
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          onTap: onTap,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          dense: true,
          selected: true,
          selectedTileColor: Colors.blue.withOpacity(0.5),
          tileColor: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    );
  }
}
