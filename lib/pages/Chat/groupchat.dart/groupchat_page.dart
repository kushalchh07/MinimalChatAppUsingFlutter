// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/constants/colors/colors.dart';
import 'package:chat_app/constants/constants.dart';
import 'package:chat_app/pages/Chat/groupchat.dart/add_new_members.dart';
import 'package:chat_app/pages/Chat/groupchat.dart/see_members.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_side_sheet/modal_side_sheet.dart';

class GroupchatPage extends StatefulWidget {
  final String groupName;
  String groupImage;
  String groupId;
  String adminId;
  GroupchatPage(
      {required this.groupName,
      required this.groupImage,
      required this.groupId,
      required this.adminId});
  @override
  State<GroupchatPage> createState() => _GroupchatPageState();
}

class _GroupchatPageState extends State<GroupchatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
        backgroundColor: appBackgroundColor,
        centerTitle: true,
        elevation: 2.0,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              showModalSideSheet(
                context: context,
                barrierDismissible: true,
                body: _buildRightDrawerContent(widget.groupName,
                    widget.groupImage, widget.groupId, widget.adminId),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Icon(Icons.more_vert),
            ),
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: appBackgroundColor,
      body: Center(
        child: Text('Group Chat Page'),
      ),
    );
  }

  Widget _buildRightDrawerContent(
      String groupName, String groupImageUrl, String groupId, String adminId) {
    return Container(
      height: Get.height,
      width: 600.0, // Adjust the width as needed
      color: appBackgroundColor,
      child: Center(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            SizedBox(height: 50.0),
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.transparent,
                  // width: 2,
                ),
              ),
              child: groupImageUrl.isEmpty ?? true
                  ? Container(
                      // height: 60,
                      // width: 60,
                      decoration: BoxDecoration(
                          color: primaryColor, shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          getFirstandLastNameInitals(
                              groupName ?? ''.toUpperCase()),
                          style: TextStyle(color: whiteColor, fontSize: 20),
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
                      imageUrl: groupImageUrl,
                      placeholder: (context, url) => Image.asset(
                        'assets/images/no-image.png',
                        fit: BoxFit.cover,
                        height: 60,
                        width: 60,
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/no-image.png',
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                      fit: BoxFit.cover,
                    ),
            ),
            ListTile(
              leading: Icon(CupertinoIcons.person_add),
              title: Text('Add Members'),
              onTap: () {
                // Handle Option 1
                //getting current user from firebase
                String userId = FirebaseAuth.instance.currentUser!.uid;
                if (adminId != userId) {
                  Get.snackbar("Error", "You are not an admin");
                } else {
                  log("Tapped On Add New Memebers");
                  Get.to(() => AddNewMembers(
                        // groupName: groupName,
                        groupId: groupId,
                      ));
                }
              },
            ),
            ListTile(
              leading: Icon(CupertinoIcons.person_3),
              title: Text('See Members'),
              onTap: () {
                // Handle Option 2
                log("Tapped On see members");
                Get.to(() => SeeMembers(
                      groupId: groupId,
                    ));
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Leave Group'),
              onTap: () {
                // Handle Option 3
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
