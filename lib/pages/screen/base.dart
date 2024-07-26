// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:chat_app/Api/firebase_api.dart';
import 'package:chat_app/pages/Chat/chat_screen.dart';
import 'package:chat_app/pages/Drawer/customDrawer.dart';
import 'package:chat_app/pages/screen/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';

import '../../constants/colors/colors.dart';

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
    final screens = [ChatScreen(), CustomDrawer()];
    setState(() {});
    return Scaffold(
      backgroundColor: appBackgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex!,
        selectedItemColor: greenColor,
        selectedFontSize: Get.height * 0.015,
        unselectedItemColor: Colors.black,
        backgroundColor: appBackgroundColor,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      body: screens[_selectedIndex],
    );
  }
}
