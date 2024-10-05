// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Bloc/chatBloc/chat_bloc.dart';
import 'package:chat_app/Bloc/chatBloc/chat_event.dart';
import 'package:chat_app/Bloc/friendRequest/friend_request_bloc.dart';
import 'package:chat_app/Bloc/friendRequest/friend_request_event.dart';
import 'package:chat_app/constants/Sharedpreferences/sharedpreferences.dart';
import 'package:chat_app/constants/colors/colors.dart';
import 'package:chat_app/pages/Login&signUp/sign_uppage.dart';
import 'package:chat_app/pages/screen/base.dart';
import 'package:chat_app/utils/customWidgets/chat_bubble.dart';
import 'package:chat_app/services/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../Bloc/NotificationBloc/notification_bloc.dart';
import '../../Bloc/chatBloc/chat_state.dart';
import '../../constants/constants.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserId;
  final String receiverimageUrl;
  final String senderImageUrl;
  final bool isImage;
  ChatPage({
    Key? key,
    required this.receiverUserEmail,
    required this.receiverUserId,
    required this.receiverimageUrl,
    required this.senderImageUrl,
    required this.isImage,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();
  final FocusNode myFocusNode = FocusNode();

  void sendMessage() {
    if (_messageController.text.isNotEmpty) {
      _chatService.sendMessage(
          widget.receiverUserId, _messageController.text, widget.isImage);
      _messageController.clear();
    }
    scrollDown();
  }

  void scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(Duration(milliseconds: 500), () => scrollDown());
      }
    });
    Future<String?> senderImageUrl = getImage();
    log(senderImageUrl.toString());
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        title: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.transparent,
                  // width: 2,
                ),
              ),
              child: widget.receiverimageUrl.isEmpty
                  ? Container(
                      // height: 60,
                      // width: 60,
                      decoration: BoxDecoration(
                          color: primaryColor, shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          getFirstandLastNameInitals(
                              widget.receiverUserEmail.toUpperCase()),
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
                      imageUrl: widget.receiverimageUrl,
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
            SizedBox(width: Get.width * 0.03),
            Text(widget.receiverUserEmail),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
        backgroundColor: appBackgroundColor,
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (String result) {
              if (result == 'Remove Friend') {
                // Handle create group chat action
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Are You Sure You want to remove?'),
                      content: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              // _buildTextFormField(
                              //     _gropNameController, 'Group Name'),
                            ],
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Close'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Save'),
                          onPressed: () {
                            BlocProvider.of<FriendRequestBloc>(context).add(
                                RemoveFriend(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    widget.receiverUserId));
                            Get.offAll(() => Base());
                            // Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Remove Friend',
                child: Text('Remove Friend'),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: appBackgroundColor),
        child: Column(
          children: [
            Expanded(
              child: _buildMessageList(),
            ),
            _buildMessageInput(),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatLoadingState) {
          return CupertinoActivityIndicator();
        }
        if (state is ChatSuccessState) {
          return StreamBuilder<QuerySnapshot>(
            stream: _chatService.getMessages(
                widget.receiverUserId, _firebaseAuth.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              WidgetsBinding.instance.addPostFrameCallback((_) => scrollDown());

              return ListView(
                controller: _scrollController,
                children: snapshot.data!.docs.map((document) {
                  return _buildMessageItem(document);
                }).toList(),
              );
            },
          );
        }
        return StreamBuilder<QuerySnapshot>(
          stream: _chatService.getMessages(
              widget.receiverUserId, _firebaseAuth.currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            WidgetsBinding.instance.addPostFrameCallback((_) => scrollDown());

            return ListView(
              controller: _scrollController,
              children: snapshot.data!.docs.map((document) {
                return _buildMessageItem(document);
              }).toList(),
            );
          },
        );
      },
    );
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

    var imageUrl = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? widget.senderImageUrl
        : widget.receiverimageUrl;
    var userId = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? widget.receiverUserId
        : data['senderId'];
    var otherUserId = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? data['senderId']
        : widget.receiverUserId;
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
                      _buildImageWidget(imageUrl, data['senderEmail']),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildImageWidget(imageUrl, data['senderEmail']),
                      // Text(data['senderEmail']),
                    ],
                  ),
            ChatBubble(
              message: data['message'],
              color: color,
              isMe: isMe,
              isImage: data['isImage'] ?? false,
              messageId: document.id,
              userId: userId,
              otherUserId: otherUserId,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is ImagePicked) {
          return ImageSentWidget(image: state.image);
        }
        if (state is ImageCancelImage) {
          return Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 8, top: 10),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      BlocProvider.of<ChatBloc>(context)
                          .add(ImagePickedEvent());
                    },
                    icon: Icon(Icons.image)),
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
                  onPressed: () {
                    sendMessage();
                    BlocProvider.of<NotificationBloc>(context)
                        .add(SendNotification(
                      title: 'New Message',
                      body: _messageController.text,
                      receiverUserId: widget.receiverUserId,
                    ));
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 8, top: 10),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    BlocProvider.of<ChatBloc>(context).add(ImagePickedEvent());
                  },
                  icon: Icon(Icons.image)),
              Expanded(
                child: TextFormField(
                  focusNode: myFocusNode,
                  cursorColor: greenColor,
                  controller: _messageController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
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
                onPressed: sendMessage,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        );
      },
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

  Widget ImageSentWidget({required File image}) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is ImageSendingEvent) {
          return CupertinoActivityIndicator();
        }
        return Container(
            height: 60,
            width: Get.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      BlocProvider.of<ChatBloc>(context)
                          .add(ImagePickedEvent());
                    },
                    icon: Icon(Icons.image)),
                Container(
                    height: 90,
                    width: Get.width * 0.3,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Image.file(image),
                        ),
                        IconButton(
                            onPressed: () {
                              BlocProvider.of<ChatBloc>(context)
                                  .add(ImageCancelEvent());
                            },
                            icon: Icon(
                              Icons.close,
                              size: 20,
                            ))
                      ],
                    )),
                IconButton(
                    onPressed: () {
                      BlocProvider.of<ChatBloc>(context)
                          .add(ImageSendEvent(image, widget.receiverUserId));
                    },
                    icon: Icon(Icons.send))
              ],
            ));
      },
    );
  }
}
