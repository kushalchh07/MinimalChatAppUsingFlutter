// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Bloc/chatBloc/chat_bloc.dart';
import 'package:chat_app/Bloc/chatBloc/chat_event.dart';
import 'package:chat_app/Bloc/chatBloc/chat_state.dart';
import 'package:chat_app/constants/colors/colors.dart';
import 'package:chat_app/constants/constants.dart';
import 'package:chat_app/model/message.dart';
import 'package:chat_app/pages/Chat/groupchat.dart/add_new_members.dart';
import 'package:chat_app/pages/Chat/groupchat.dart/group_info.dart';
import 'package:chat_app/pages/Chat/groupchat.dart/see_members.dart';
import 'package:chat_app/pages/Login&signUp/sign_uppage.dart';
import 'package:chat_app/utils/customWidgets/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:modal_side_sheet/modal_side_sheet.dart';

import '../../../services/chat_services.dart';

class GroupchatPage extends StatefulWidget {
  final String groupName;
  String groupImage;
  String groupId;
  String adminId;
  bool isImage;
  GroupchatPage({
    required this.groupName,
    required this.groupImage,
    required this.groupId,
    required this.adminId,
    required this.isImage,
  });
  @override
  State<GroupchatPage> createState() => _GroupchatPageState();
}

final TextEditingController _messageController = TextEditingController();
final ChatService _chatService = ChatService();
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final ScrollController _scrollController = ScrollController();
final FocusNode myFocusNode = FocusNode();

class _GroupchatPageState extends State<GroupchatPage> {
  void sendChatMessage() {
    if (_messageController.text.isNotEmpty) {
      _chatService.sendGroupMessage(
          widget.groupId, _messageController.text, widget.isImage);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
            onTap: () {
              Get.to(GroupInfo(
                groupName: widget.groupName,
                groupImageUrl: widget.groupImage,
                groupId: widget.groupId,
                adminId: widget.adminId,
              ));
            },
            child: Text(widget.groupName)),
        backgroundColor: appBackgroundColor,
        centerTitle: true,
        elevation: 2.0,
        // actions: <Widget>[
        //   GestureDetector(
        //     onTap: () {
        //       showModalSideSheet(
        //         context: context,
        //         barrierDismissible: true,
        //         body: _buildRightDrawerContent(widget.groupName,
        //             widget.groupImage, widget.groupId, widget.adminId),
        //       );
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.only(right: 15.0),
        //       child: Icon(Icons.more_vert),
        //     ),
        //   ),
        // ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: appBackgroundColor,
      body: Container(
        decoration: BoxDecoration(color: appBackgroundColor),
        child: Column(
          children: [
            Expanded(
              child: _buildMessageList(widget.groupId),
            ),
            _buildMessageInput(),
            const SizedBox(height: 25),
          ],
        ),
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
                  Get.snackbar("Error", "You are not an admin",
                      colorText: Colors.white, backgroundColor: Colors.red);
                } else {
                  log("Tapped On Add New Memebers");
                  Get.to(() => GroupInfo(
                        // groupName: groupName,
                        groupId: groupId,
                        adminId: adminId,
                        groupImageUrl: groupImageUrl,
                        groupName: groupName,
                      ));
                }
              },
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

  Widget _buildMessageInput() {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              focusNode: myFocusNode,
              cursorColor: greenColor,
              controller: _messageController,
              textInputAction: TextInputAction.next,
              // keyboardType: TextInputType.text,
              decoration: InputDecoration(
                floatingLabelStyle: floatingLabelTextStyle(),
                prefixIcon: Icon(
                  Icons.email,
                  color: greyColor,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                focusedBorder: customFocusBorder(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
                labelStyle: TextStyle(color: greyColor, fontSize: 13),
                hintText: 'Write a message',
              ),
            ),
          ),
          IconButton(
            onPressed: sendChatMessage,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}

Widget _buildMessageList(String groupId) {
  return StreamBuilder<QuerySnapshot>(
    stream: _chatService.getGroupMessages(groupId),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Center(child: Text('No messages available.'));
      }

      final messages = snapshot.data!.docs.reversed
          .map((doc) => Message.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      return ListView(
        controller: _scrollController,
        children: snapshot.data!.docs.map((document) {
          return _buildMessageItem(document);
        }).toList(),
      );
    },
  );
}

String getFirstName(String fullName) {
  List<String> nameParts = fullName.split(' ');
  if (nameParts.isNotEmpty) {
    return nameParts.first;
  } else {
    return ''; // Return an empty string if the name is empty or invalid
  }
}

Widget _buildMessageItem(DocumentSnapshot document) {
  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
  var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
      ? Alignment.centerRight
      : Alignment.centerLeft;
  var color = (data['senderId'] == _firebaseAuth.currentUser!.uid)
      ? greenColor
      : yellowColor;
  var isMe = (data['senderId'] == _firebaseAuth.currentUser!.uid);
  var name = (data['senderName'] != null)
      ? data['senderName']
      : getFirstName(data['senderEmail']);
  var imageUrl =
      (data['senderProfilePic'] != null) ? data['senderProfilePic'] : "";
  var message = (data['message'] != null) ? data['message'] : "";
  var userId = (data['senderId'] != null) ? data['senderId'] : "";
  return Container(
    alignment: alignment,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          isMe
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Text(data['senderEmail']),
                    // Text(getFirstName(name)),

                    ChatBubble(
                      message: message,
                      color: color,
                      isMe: isMe,
                      isImage: data['isImage'] ?? false,
                      messageId: document.id,
                      userId: userId,
                      otherUserId: data['receiverId'],
                    ),
                    _buildImageWidget(imageUrl, name),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(getFirstName(name)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Text(data['senderEmail']),
                        _buildImageWidget(imageUrl, name),
                        ChatBubble(
                          message: data['message'],
                          color: color,
                          isMe: isMe,
                          isImage: data['isImage'] ?? false,
                          messageId: document.id,
                          userId: data['senderId'],
                          otherUserId: data['receiverId'],
                        ),
                      ],
                    ),
                  ],
                ),
          // Row(
          //   children: [
          //     ChatBubble(
          //       message: data['message'],
          //       color: color,
          //       isMe: isMe,
          //       isImage: data['isImage'] ?? false,
          //       messageId: document.id,
          //       userId: data['senderId'],
          //       otherUserId: data['receiverId'],
          //     ),
          //   ],
          // ),
        ],
      ),
    ),
  );
}

Widget _buildImageWidget(String imageUrl, String receiverUserEmail) {
  return Container(
    height: 20,
    width: 20,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: Colors.transparent,
        // width: 2,
      ),
    ),
    child: imageUrl.isEmpty
        ? Container(
            // height: 60,
            // width: 60,
            decoration:
                BoxDecoration(color: primaryColor, shape: BoxShape.circle),
            child: Center(
              child: Text(
                getFirstandLastNameInitals(receiverUserEmail.toUpperCase()),
                style: TextStyle(color: whiteColor, fontSize: 10),
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
  );
}
