// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Bloc/profileImagebloc/profile_image_bloc.dart';
import 'package:chat_app/Bloc/profileImagebloc/profile_image_event.dart';
import 'package:chat_app/Bloc/userBloc/user_bloc.dart';
import 'package:chat_app/pages/Drawer/blocked_users.dart';
import 'package:chat_app/pages/Drawer/profile.dart';
import 'package:chat_app/pages/Login&signUp/sign_inpage.dart';
import 'package:chat_app/pages/screen/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get/get.dart';

import '../../Bloc/profileImagebloc/profile_image_state.dart';
import '../../Bloc/userBloc/user_event.dart';
import '../../Bloc/userBloc/user_state.dart';
import '../../constants/Sharedpreferences/sharedpreferences.dart';
import '../../constants/colors/colors.dart';

import '../../constants/constants.dart';
import '../../services/auth_services.dart';
import '../../utils/customWidgets/alert_dialog_box.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBackgroundColor,
        surfaceTintColor: whiteColor,
        titleSpacing: 0,
        title: Text("Settings"),
        centerTitle: true,
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
                      top: 50,
                    ),
                    decoration: BoxDecoration(
                      color: appSecondary,
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
                            color: secondaryColor,
                          ),
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
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const Settings()),
                            );
                          },
                          title: const Text('Settings'),
                          leading: Icon(
                            Icons.settings,
                            color: secondaryColor,
                          ),
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
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                        create: (context) => UserBloc(),
                                        child: const BlockedUsers(),
                                      )),
                            );
                          },
                          title: const Text('Blocked Users'),
                          leading: Icon(
                            Icons.block_flipped,
                            color: secondaryColor,
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: secondaryColor,
                          ),
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
                            color: primaryColor,
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: primaryColor,
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
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Icon(Icons.error);
                          } else {
                            final profileInfo = snapshot.data!;
                            final fullName =
                                profileInfo['fullName'] ?? 'Unknown';
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
                                      color: Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: imageUrl.isEmpty
                                      ? Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                              color: primaryColor,
                                              shape: BoxShape.circle),
                                          child: Center(
                                            child: Text(
                                              getFirstandLastNameInitals(
                                                  fullName.toUpperCase()),
                                              style: TextStyle(
                                                  color: whiteColor,
                                                  fontSize: 76),
                                            ),
                                          ),
                                        )
                                      : CachedNetworkImage(
                                          imageBuilder:
                                              (context, imageProvider) {
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
                                  fullName,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  email,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
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
      ),
    );
  }
}
