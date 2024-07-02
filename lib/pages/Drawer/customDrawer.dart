// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:chat_app/constants/Sharedpreferences/sharedpreferences.dart';
import 'package:chat_app/pages/Drawer/profile.dart';
import 'package:chat_app/pages/Login&signUp/sign_inpage.dart';
import 'package:chat_app/pages/screen/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../Bloc/loginbloc/login_bloc.dart';
import '../../constants/colors/colors.dart';
import '../../constants/constants.dart';
import '../../utils/customWidgets/alert_dialog_box.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String? contact;
  int? isEmailVerified;
  bool? isRememberme;
  String? password;
  int? boardingCount;
  int googleLogin = 0;
  dynamic fullName;
  // dynamic email;

  // UserRepository user = UserRepository();

  @override
  void initState() {
    // loadContact();
    // log('email splash bata aako $email');
    super.initState();
    isGoogleLogIn();
  }

  isGoogleLogIn() async {
    // var res = await user.fecthUserDetails();
    setState(() {
      // googleLogin = res.user![0].googlelogin!;
    });
  }

  @override
  void dispose() {
    super.dispose();
    googleLogin;
  }

  final email = getEmail();
  Future<void> clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email =
        prefs.getString('email_address'); // Get the current contact value
    bool? isRememberme = prefs.getBool('rememberMe');
    String? password = prefs.getString('password');
    int? boardingCount = prefs.getInt('boardingCount');
    isRememberme = isRememberme;
    email = email;
    password = password;
    boardingCount = boardingCount;
    log('email mathi $email');
    log('password mathi $password');
    log('isRememberme mathi $isRememberme');
    log('boarding count mathi $boardingCount');

    await prefs.clear(); // Clear all data
    await GoogleSignIn().signOut();
    // await GoogleSignIn().disconnect();

    prefs.setBool('rememberMe', isRememberme ?? false);
    prefs.setString('email_address', email ?? '');
    prefs.setString('password', password ?? '');
    prefs.setInt('boardingCount', boardingCount ?? 0);
    log('boarding count $boardingCount');
    log('email tala $email');
    log("${isRememberme}isRememberme clear data bara aako value");
    // log("$email email clear data bara aako value");
    // log("$password password clear data bara aako value");

    // log(email.toString() + "email");

    // print("Data cleared, contact and remember me retained.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBackgroundColor,
        surfaceTintColor: whiteColor,
        titleSpacing: 0,
        title: Text("Settings"),
      ),
      backgroundColor: appBackgroundColor.withOpacity(0.5),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: Get.height * 0.1,
              ),
              Stack(
                children: [
                  Container(
                    width: Get.width * 0.9,
                    padding: const EdgeInsets.only(
                      top: 10,
                      // bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: Get.height * 0.1),
                        Text(
                          fullName ?? 'Loading',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          (email ?? 'N/A').toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            // Navigate to the Learning Dashboard
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Profile()));
                          },
                          title: const Text('My Information'),
                          leading: Icon(
                            Icons.person,
                            color: secondaryColor,
                          ), // Customize the icon
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: secondaryColor,
                          ),
                        ),
                        const Divider(
                          height: 0,
                        ),
                        ListTile(
                          onTap: () {
                            // Navigate to the Learning Dashboard
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Settings()));
                          },
                          title: const Text('Settings'),
                          leading: Icon(
                            Icons.settings,
                            color: secondaryColor,
                          ), // Customize the icon
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: secondaryColor,
                          ),
                        ),
                        const Divider(
                          height: 0,
                        ),
                        ListTile(
                          onTap: () async {
                            // final prefs =
                            //     await SharedPreferences.getInstance();
                            Platform.isAndroid
                                ? customAlertBox(
                                    context,
                                    'Do you really want to Logout?',
                                    'Yes',
                                    () async {
                                      // BlocProvider.of<LoginBloc>(context)
                                      //     .add(LoginInitialEvent());
                                      // googleLogin == 1
                                      //     ? await signout()
                                      //     : await clearData();

                                      Get.offAll(() => const SignIn());
                                    },
                                    'No',
                                    () async {
                                      Navigator.pop(context);
                                    },
                                  )
                                : showCupertinoDialog(
                                    context: context,
                                    builder: (context) => CupertinoAlertDialog(
                                      title: const Text(
                                        'Logout',
                                        style: TextStyle(
                                            fontFamily: 'inter',
                                            fontWeight: FontWeight.w500),
                                      ),
                                      content: const Text(
                                          'Do you really want to Logout?'),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            CupertinoButton(
                                              onPressed: () async {
                                                // Navigator.pop(context);
                                                // clearData();
                                                // await LoginApi.signOut;
                                                // log("${isEmailVerified}email verify");
                                                // log("${contact}contact");

                                                // BlocProvider.of<LoginBloc>(
                                                //         context)
                                                //     .add(LoginInitialEvent());
                                                // Get.offAll(() => const Login());
                                              },
                                              child: const Text('Yes'),
                                            ),
                                            CupertinoButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('No'),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                          },
                          title: const Text(
                            'Logout',
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'inter',
                                fontWeight: FontWeight.w500),
                          ),
                          leading: Icon(
                            Icons.power_settings_new_sharp,
                            color: primaryColor,
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: primaryColor,
                          ), // Customize the icon
                          // Customize the icon
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  // Positioned(
                  //   top: 0,
                  //   left: 0,
                  //   right: 0,
                  //   child: Transform.translate(
                  //     offset: const Offset(0, -70),
                  //     child: Container(
                  //       height: 150,
                  //       width: 150,
                  //       decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         border: Border.all(
                  //           color: Colors.transparent,
                  //           width: 2,
                  //         ),
                  //       ),
                  //       child: image == null || image == ''
                  //           ? Container(
                  //               height: 60,
                  //               width: 60,
                  //               decoration: BoxDecoration(
                  //                   color: primaryColor,
                  //                   shape: BoxShape.circle),
                  //               child: Center(
                  //                 child: Text(
                  //                   getFirstandLastNameInitals(
                  //                       fullName.toString().toUpperCase()),
                  //                   style: TextStyle(
                  //                       color: whiteColor, fontSize: 76),
                  //                 ),
                  //               ),
                  //             )
                  //           : CachedNetworkImage(
                  //               imageBuilder: (context, imageProvider) {
                  //                 return Container(
                  //                   decoration: BoxDecoration(
                  //                     shape: BoxShape.circle,
                  //                     image: DecorationImage(
                  //                       image: imageProvider,
                  //                       fit: BoxFit.cover,
                  //                     ),
                  //                   ),
                  //                 );
                  //               },
                  //               imageUrl: profileImageBaseUrl + '/' + image,
                  //               placeholder: (context, url) => Image.asset(
                  //                 'assets/others/no-image.png',
                  //                 fit: BoxFit.cover,
                  //               ),
                  //               errorWidget: (context, url, error) =>
                  //                   Image.asset(
                  //                 'assets/others/no-image.png',
                  //                 fit: BoxFit.cover,
                  //               ),
                  //               fit: BoxFit.cover,
                  //             ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
