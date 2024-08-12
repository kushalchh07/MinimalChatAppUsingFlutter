import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/pages/Chat/groupchat.dart/add_new_members.dart';
import 'package:chat_app/pages/Chat/groupchat.dart/group_image_pick.dart';
import 'package:chat_app/pages/Chat/groupchat.dart/see_members.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../../constants/colors/colors.dart';
import '../../../constants/constants.dart';

class GroupInfo extends StatefulWidget {
  GroupInfo(
      {super.key,
      required this.groupName,
      required this.groupImageUrl,
      required this.groupId,
      required this.adminId});
  final String groupName;
  final String groupImageUrl;
  final String groupId;
  final String adminId;
  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  late String groupName;
  late String groupImageUrl;

  @override
  void initState() {
    super.initState();
    groupName = widget.groupName;
    groupImageUrl = widget.groupImageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBackgroundColor,
        centerTitle: true,
        elevation: 2.0,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: _buildRightDrawerContent(
          groupName, groupImageUrl, widget.groupId, widget.adminId),
    );
  }

  Widget _buildRightDrawerContent(
      String groupName, String groupImageUrl, String groupId, String adminId) {
    return Container(
      height: Get.height,
      color: appBackgroundColor,
      child: Center(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.transparent,
                        ),
                      ),
                      child: groupImageUrl.isEmpty ?? true
                          ? Container(
                              decoration: BoxDecoration(
                                  color: primaryColor, shape: BoxShape.circle),
                              child: Center(
                                child: Text(
                                  getFirstandLastNameInitals(
                                      groupName.toUpperCase()),
                                  style: TextStyle(
                                      color: whiteColor, fontSize: 20),
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
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: whiteColor, width: 2),
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: () async {
                              final result = await Get.to(() => GroupImagePick(
                                    groupName: groupName,
                                    groupId: groupId,
                                  ));
                              if (result == true) {
                                // Refresh the group details
                                setState(() {
                                  groupName = widget.groupName;
                                  groupImageUrl = widget.groupImageUrl;
                                });
                              }
                            },
                            icon: Icon(
                              Icons.mode_edit_rounded,
                              color: whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  groupName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            SizedBox(height: 50.0),
            ListTile(
              leading: Icon(CupertinoIcons.person_add),
              title: Text('Add Members'),
              onTap: () {
                String userId = FirebaseAuth.instance.currentUser!.uid;
                if (adminId != userId) {
                  Get.snackbar("Error", "You are not an admin");
                } else {
                  log("Tapped On Add New Memebers");
                  Get.to(() => AddNewMembers(
                        groupId: groupId,
                      ));
                }
              },
            ),
            ListTile(
              leading: Icon(CupertinoIcons.person_3),
              title: Text('See Members'),
              onTap: () {
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
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
