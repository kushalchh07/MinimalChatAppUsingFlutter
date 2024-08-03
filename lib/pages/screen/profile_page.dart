// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Bloc/friendRequest/friend_request_bloc.dart';
import 'package:chat_app/Bloc/friendRequest/friend_request_event.dart';
import 'package:chat_app/Bloc/friendRequest/friend_request_state.dart';
import 'package:chat_app/constants/colors/colors.dart';
import 'package:chat_app/constants/constants.dart';
import 'package:chat_app/pages/Chat/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  final String imageUrl;
  final String uid;
  final String fullname;

  ProfilePage({
    super.key,
    required this.imageUrl,
    required this.uid,
    required this.fullname,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String userId;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
    // Dispatch the event to check the friend request status
    context
        .read<FriendRequestBloc>()
        .add(CheckFriendRequestStatus(userId, widget.uid));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBackgroundColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      backgroundColor: appBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 170,
              width: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.transparent,
                ),
              ),
              child: widget.imageUrl.isEmpty
                  ? Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          getFirstandLastNameInitals(
                              widget.fullname.toUpperCase()),
                          style: TextStyle(color: whiteColor, fontSize: 40),
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
                      imageUrl: widget.imageUrl,
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
          ),
          SizedBox(height: 15),
          Text(
            widget.fullname,
            style: TextStyle(fontSize: 50, color: Colors.black),
          ),
          SizedBox(height: 15),
          BlocConsumer<FriendRequestBloc, FriendRequestState>(
            listener: (context, state) {
              if (state is FriendRequestError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.message}')),
                );
              }
            },
            builder: (context, state) {
              if (state is FriendRequestInitial) {
                return CupertinoActivityIndicator();
              }
              if (state is FriendRequestSending) {
                return CupertinoActivityIndicator();
              } else if (state is FriendRequestStatusLoaded) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: greenColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextButton(
                        onPressed: () {
                          if (state.isRequestSent) {
                            context.read<FriendRequestBloc>().add(
                                  CancelFriendRequest(userId, widget.uid),
                                );
                          } else {
                            context.read<FriendRequestBloc>().add(
                                  SendFriendRequest(userId, widget.uid),
                                );
                          }
                        },
                        child: Text(
                          state.isRequestSent == true
                              ? "Cancel Request"
                              : "Add Friend",
                          style: TextStyle(color: whiteColor),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return CupertinoActivityIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}
