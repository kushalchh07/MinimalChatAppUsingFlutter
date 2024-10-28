// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:chat_app/Api/firebase_api.dart';
import 'package:chat_app/Bloc/internetBloc/internet_bloc.dart';
import 'package:chat_app/pages/Chat/chat_screen.dart';
import 'package:chat_app/pages/Drawer/customDrawer.dart';
import 'package:chat_app/pages/screen/settings.dart';
import 'package:chat_app/pages/screen/stories.dart';
import 'package:chat_app/pages/screen/users.dart';
import 'package:chat_app/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';

import '../../constants/colors/colors.dart';
import '../../theme/ThemeCubit/theme_cubit.dart';
import '../../utils/tab/MotionBadgeWidget.dart';
import '../../utils/tab/MotionTabBar.dart';
import '../../utils/tab/MotionTabBarController.dart';
import '../Chat/groupchat.dart/groupchat.dart';
import 'internet_lost_screen.dart';

class Base extends StatefulWidget {
  Base({super.key, this.indexNum});
  int? indexNum;

  @override
  State<Base> createState() => BaseState();
}

class BaseState extends State<Base> with TickerProviderStateMixin {
  MotionTabBarController? _motionTabBarController;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    Api.saveUserToken();
    _selectedIndex = widget.indexNum ?? 0;

    _motionTabBarController = MotionTabBarController(
      initialIndex: _selectedIndex,
      length: 4,
      vsync: this,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _motionTabBarController!.index = index;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _motionTabBarController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int? _selectedIndex = (widget.indexNum == null) ? 0 : widget.indexNum;
    final screens = [
      ChatScreen(),
      GroupChatScreen(),
      Users(),
      // Stories(),
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
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final stateTheme = state;
          return Scaffold(
            bottomNavigationBar: MotionTabBar(
              controller:
                  _motionTabBarController, // Add this controller if you need to change your tab programmatically
              initialSelectedTab: "Chat",
              useSafeArea: true, // default: true, apply safe area wrapper
              labels: const ["Chat", "Groups", "Peoples", "Settings"],
              icons: const [
                CupertinoIcons.chat_bubble_2,
                CupertinoIcons.group,
                CupertinoIcons.globe,
                CupertinoIcons.settings
              ],

              // optional badges, length must be same with labels
              badges: [
                // Default Motion Badge Widget
                // const MotionBadgeWidget(
                //   text: '10+',
                //   textColor: Colors.white, // optional, default to Colors.white
                //   color: Colors.red, // optional, default to Colors.red
                //   size: 18, // optional, default to 18
                // ),
                null,
                // custom badge Widget
                // Container(
                //   color: Colors.black,
                //   padding: const EdgeInsets.all(2),
                //   child: const Text(
                //     '48',
                //     style: TextStyle(
                //       fontSize: 14,
                //       color: Colors.white,
                //     ),
                //   ),
                // ),

                // allow null
                null,
                null,
                // Default Motion Badge Widget with indicator only
                null,
              ],
              tabSize: 50,
              tabBarHeight: 55,
              textStyle: const TextStyle(
                fontSize: 12,
                // color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              tabIconColor: greenColor,
              tabIconSize: 28.0,
              tabIconSelectedSize: 26.0,
              tabSelectedColor: greenColor,
              tabIconSelectedColor: Colors.white,
              tabBarColor: Theme.of(context).navBarColor,
              onTabItemSelected: (int value) {
                _onItemTapped(value);
              },
            ),
            //  BottomNavigationBar(
            //   type: BottomNavigationBarType.fixed,
            //   currentIndex: _selectedIndex!,
            //   selectedItemColor: greenColor,
            //   selectedFontSize: Get.height * 0.015,
            //   unselectedItemColor: Colors.black,
            //   backgroundColor: appBackgroundColor,
            //   onTap: _onItemTapped,
            //   items: [
            //     BottomNavigationBarItem(
            //       icon: Icon(CupertinoIcons.chat_bubble_2),
            //       label: 'Chat',
            //     ),
            //     BottomNavigationBarItem(
            //       icon: Icon(CupertinoIcons.group),
            //       label: 'Groups',
            //     ),
            //     BottomNavigationBarItem(
            //       icon: Icon(CupertinoIcons.globe),
            //       label: 'People',
            //     ),
            //     // BottomNavigationBarItem(
            //     //   icon: Icon(
            //     //     CupertinoIcons.photo_on_rectangle,
            //     //   ),
            //     //   label: 'Stories',
            //     // ),
            //     BottomNavigationBarItem(
            //       icon: Icon(CupertinoIcons.settings),
            //       label: 'Settings',
            //     ),
            //   ],
            // ),
            body: TabBarView(
              physics:
                  const NeverScrollableScrollPhysics(), // swipe navigation handling is not supported
              controller: _motionTabBarController,
              children: <Widget>[
                const ChatScreen(),
                const GroupChatScreen(),
                const Users(),
                const CustomDrawer(),
              ],
            ),
            // screens[_selectedIndex],
          );
        },
      ),
    );
  }
}
