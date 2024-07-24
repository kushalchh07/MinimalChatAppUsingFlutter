// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:chat_app/constants/colors/colors.dart';
import 'package:chat_app/pages/Drawer/profileImage.dart';
import 'package:chat_app/pages/Drawer/user_password.dart';
import 'package:chat_app/pages/Drawer/user_profile.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

int selectedTab = 0;

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBackgroundColor,
        title: const Text("My Information"),
      ),
      backgroundColor: appBackgroundColor,
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          selectedTab = 0;
                        });
                      },
                      child: Text(
                        'Profile',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                (selectedTab == 0) ? primaryColor : blackColor),
                      ))),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      selectedTab = 2;
                    });
                  },
                  child: Text(
                    'Image',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: (selectedTab == 2) ? primaryColor : blackColor),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (selectedTab == 0) const UserProfile(),
                  if (selectedTab == 2) const ProfileImage(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
