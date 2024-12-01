import 'package:chat_app/Bloc/userBloc/user_bloc.dart';
import 'package:chat_app/Bloc/userBloc/user_event.dart';
import 'package:chat_app/constants/colors/colors.dart';
import 'package:chat_app/pages/Drawer/user_password.dart';
import 'package:chat_app/pages/Login&signUp/sign_inpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:chat_app/pages/screen/profile_image_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Bloc/userBloc/user_state.dart';
import '../../constants/Sharedpreferences/sharedpreferences.dart';
import '../../services/auth_services.dart';
import '../../utils/customWidgets/alert_dialog_box.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => SettingState();
}

void signOut() {
  AuthService.logout();
  saveStatus(false);
  Get.offAll(() => SignIn());
}

class SettingState extends State<Setting> {
  TextEditingController _passwordController = TextEditingController();
  void onTapPassword() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      bool isGoogleSignIn = false;
      for (UserInfo userInfo in user.providerData) {
        if (userInfo.providerId == 'google.com') {
          isGoogleSignIn = true;
          break;
        }
      }

      if (isGoogleSignIn) {
        // Google Sign-In
        Fluttertoast.showToast(
            msg: "Only User from email can change password.",
            timeInSecForIosWeb: 2);
      } else {
        // Email/Password Sign-In
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => UserPassword()));
      }
    }
  }

  void onTapDeleteAccount() async {
    // customAlertBox(
    //   context,
    //   'Do you really want to Delete your Account?',
    //   'Yes',
    //   () {
    //     BlocProvider.of<UserBloc>(context)
    //         .add(DeleteMyProfile(_passwordController.text));
    //   },
    //   'No',
    //   () {
    //     Navigator.pop(context);
    //   },
    // );
    _deleteAccount(context);
  }

  Future<void> _deleteAccount(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      bool isGoogleSignIn = false;
      for (UserInfo userInfo in user.providerData) {
        if (userInfo.providerId == 'google.com') {
          isGoogleSignIn = true;
          break;
        }
      }

      if (isGoogleSignIn) {
        // Google Sign-In
        _showLogoutDialog(context);
      } else {
        // Email/Password Sign-In
        _showPasswordDialog(context);
      }
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Account'),
          content: Text('Do you want to delete your account?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                BlocProvider.of<UserBloc>(context)
                    .add(DeleteMyProfileWithGoogle());
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showPasswordDialog(BuildContext context) {
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Password To Delete Your Account.'),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(hintText: 'Password'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                BlocProvider.of<UserBloc>(context)
                    .add(DeleteMyProfileWithEmail(passwordController.text));
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is DeleteProfileSuccess) {
          Fluttertoast.showToast(
              msg: "Account Deleted Successfully",
              backgroundColor: successColor);
          Get.offAll(() => SignIn());
        }
        if (state is DeleteProfileFailed) {
          Fluttertoast.showToast(msg: "Account Deletion Failed");
        }
      },
      child: Scaffold(
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
