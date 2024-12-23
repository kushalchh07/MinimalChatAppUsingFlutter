// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Bloc/userBloc/user_bloc.dart';
import 'package:chat_app/pages/Chat/groupchat.dart/groupchat.dart';
import 'package:chat_app/pages/Drawer/biometric.dart';
import 'package:chat_app/pages/Drawer/blocked_users.dart';
import 'package:chat_app/pages/Drawer/profile.dart';
import 'package:chat_app/pages/Login&signUp/sign_inpage.dart';
import 'package:chat_app/pages/screen/settings.dart';
import 'package:chat_app/services/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get/get.dart';

import '../../constants/Sharedpreferences/sharedpreferences.dart';
import '../../constants/colors/colors.dart';

import '../../constants/constants.dart';
import '../../services/auth_services.dart';
import '../../utils/customWidgets/alert_dialog_box.dart';
import 'theme_screen.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  Future<Map<String, String?>> getProfileInfo() async {
    final fullName = await getName();
    final email = await getEmail();
    final imageUrl = await getImage();

    return {'fullName': fullName, 'email': email, 'imageUrl': imageUrl};
  }

  void signOut() {
    AuthService.logout();
    clearData();
    saveStatus(false);
    Get.offAll(() => SignIn());
  }

  bool isPerimum = false;
  @override
  void initState() {
    super.initState();
    getProfileInfo();
    _loadPremiumStatus();
  }

  Future<bool> checkPremiumStatus(String userId) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return snapshot.exists && snapshot['premium_status'] == 'purchased';
  }

  Future<void> _loadPremiumStatus() async {
    isPerimum =
        await checkPremiumStatus(FirebaseAuth.instance.currentUser!.uid);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // backgroundColor: appBackgroundColor.withOpacity(0.5)
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: Get.height * 0.1,
            ),
            Stack(
              children: [
                Container(
                  width: Get.width * 0.9,
                  padding: const EdgeInsets.only(
                    top: 50,
                  ),
                  decoration: BoxDecoration(
                    // color: appSecondary,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: Get.height * 0.14),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const Profile()),
                          );
                        },
                        title: const Text('My Information'),
                        leading: Icon(
                          Icons.person,
                          // color: greenColor,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          // color: greenColor,
                        ),
                      ),
                      Divider(
                        height: 0,
                        // color: greenColor,
                        // color: Colors.black,
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const Setting()),
                          );
                        },
                        title: const Text('Settings'),
                        leading: Icon(
                          Icons.settings,
                          // color: greenColor,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          // color: greenColor,
                        ),
                      ),
                      Divider(
                        height: 0,
                        // color: greenColor,
                        // color: Colors.black,
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                      create: (context) =>
                                          UserBloc(ChatService()),
                                      child: const BlockedUsers(),
                                    )),
                          );
                        },
                        title: const Text('Blocked Users'),
                        leading: Icon(
                          CupertinoIcons.slash_circle_fill,
                          // color: greenColor,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          // color: greenColor,
                        ),
                      ),
                      Divider(
                        height: 0,
                        // color: greenColor,
                        // color: Colors.black,
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ThemeToggleScreen()),
                          );
                        },
                        title: const Text('Dark Mode'),
                        leading: Icon(
                          CupertinoIcons.moon_circle_fill,
                          // color: greenColor,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          // color: greenColor,
                        ),
                      ),
                      Divider(
                        height: 0,
                        // color: greenColor,
                        // color: Colors.black,
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => BiometricAuthScreen()),
                          );
                        },
                        title: const Text('Biometrics'),
                        leading: Icon(
                          CupertinoIcons.person,
                          // color: greenColor,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          // color: greenColor,
                        ),
                      ),
                      Divider(
                        height: 0,
                        // color: greenColor,
                        // color: Colors.black,
                      ),
                      ListTile(
                        onTap: () async {
                          customAlertBox(
                            context,
                            'Do you really want to Logout?',
                            'Yes',
                            () {
                              signOut();
                            },
                            'No',
                            () {
                              Navigator.pop(context);
                            },
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
                          // color: greenColor,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          // color: greenColor,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Transform.translate(
                    offset: const Offset(0, -70),
                    child: FutureBuilder<Map<String, String?>>(
                      future: getProfileInfo(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CupertinoActivityIndicator();
                        } else if (snapshot.hasError) {
                          return Icon(Icons.error);
                        } else {
                          final profileInfo = snapshot.data!;
                          final fullName = profileInfo['fullName'] ?? 'Unknown';
                          final email = profileInfo['email'] ?? 'Unknown';
                          final imageUrl = profileInfo['imageUrl'] ?? '';

                          return Column(
                            children: [
                              Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    // color: Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: imageUrl.isEmpty
                                    ? Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                            color: greenColor,
                                            shape: BoxShape.circle),
                                        child: Center(
                                          child: Text(
                                            capitalize(
                                                getFirstandLastNameInitals(
                                                    fullName.toUpperCase())),
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontSize: 76),
                                          ),
                                        ),
                                      )
                                    : CachedNetworkImage(
                                        imageBuilder: (context, imageProvider) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          );
                                        },
                                        imageUrl: imageUrl,
                                        placeholder: (context, url) =>
                                            Image.asset(
                                          'assets/images/no-image.png',
                                          fit: BoxFit.cover,
                                          height: 60,
                                          width: 60,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          'assets/images/no-image.png',
                                          height: 60,
                                          width: 60,
                                          fit: BoxFit.cover,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              SizedBox(height: 10), // Add some spacing
                              Text(
                                capitalize(fullName),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  // color: Colors.black,
                                ),
                              ),
                              Text(
                                email,
                                style: TextStyle(
                                  fontSize: 16,
                                  // color: Colors.grey[600],
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
