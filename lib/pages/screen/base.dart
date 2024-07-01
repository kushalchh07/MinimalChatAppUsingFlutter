// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:chat_app/pages/Chat/chat_screen.dart';
import 'package:chat_app/pages/screen/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';

import '../../constants/colors/colors.dart';

class Base extends StatefulWidget {
  Base({super.key, this.indexNum});
  int? indexNum;

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.indexNum ?? 0;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      widget.indexNum = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [ChatScreen(), Settings()];

    return Scaffold(
      backgroundColor: whiteColor,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        selectedFontSize: Get.height * 0.015,
        unselectedItemColor: Colors.grey,
        backgroundColor: whiteColor,
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
