// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:chat_app/Api/firebase_api.dart';
import 'package:chat_app/Bloc/internetBloc/internet_bloc.dart';
import 'package:chat_app/pages/Chat/chat_screen.dart';
import 'package:chat_app/pages/Drawer/customDrawer.dart';
import 'package:chat_app/pages/screen/settings.dart';
import 'package:chat_app/pages/screen/stories.dart';
import 'package:chat_app/pages/screen/users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';

import '../../constants/colors/colors.dart';
import '../Chat/groupchat.dart/groupchat.dart';
import 'internet_lost_screen.dart';

class Base extends StatefulWidget {
  Base({super.key, this.indexNum});
  int? indexNum;

  @override
  State<Base> createState() => BaseState();
}

class BaseState extends State<Base> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    Api.saveUserToken();
    _selectedIndex = widget.indexNum ?? 0;
  }

  void _onItemTapped(int index) {
    setState(() {
      widget.indexNum = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    int? _selectedIndex = (widget.indexNum == null) ? 0 : widget.indexNum;
    final screens = [
      ChatScreen(),
      GroupChatScreen(),
      Users(),
      Stories(),
      CustomDrawer()
    ];
    // setState(() {});
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
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex!,
          selectedItemColor: greenColor,
          selectedFontSize: Get.height * 0.015,
          unselectedItemColor: Colors.black,
          backgroundColor: appBackgroundColor,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chat_bubble_2),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.group),
              label: 'Groups',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.globe),
              label: 'People',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.photo_on_rectangle,
              ),
              label: 'Stories',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings),
              label: 'Settings',
            ),
          ],
        ),
        body: screens[_selectedIndex],
      ),
    );
  }
}
