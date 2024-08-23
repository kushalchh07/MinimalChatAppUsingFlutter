// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Bloc/chatBloc/chat_state.dart';
import 'package:chat_app/Bloc/friendRequest/friend_request_bloc.dart';
import 'package:chat_app/Bloc/friendRequest/friend_request_event.dart';
import 'package:chat_app/Bloc/friendRequest/friend_request_state.dart';
import 'package:chat_app/Bloc/userBloc/user_bloc.dart';
import 'package:chat_app/Bloc/userBloc/user_event.dart';
import 'package:chat_app/Bloc/userBloc/user_state.dart';
import 'package:chat_app/constants/colors/colors.dart';
import 'package:chat_app/constants/constants.dart';
import 'package:chat_app/pages/screen/friend_request_screen.dart';
import 'package:chat_app/pages/screen/profile_page.dart';
import 'package:chat_app/services/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserBloc>(context).add(LoadAllUsers());
    BlocProvider.of<FriendRequestBloc>(context).add(LoadRequestedUsers());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(ChatService())..add(LoadAllUsers()),
        ),
        BlocProvider<FriendRequestBloc>(
          create: (context) => FriendRequestBloc(FirebaseFirestore.instance)
            ..add(LoadRequestedUsers()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appBackgroundColor,
          elevation: 0.2,
          title: Text("Users"),
          actions: [
            GestureDetector(
              onTap: () {
                Get.to(() => FriendRequestScreen());
              },
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 14.0),
                    child: Icon(
                      Icons.notifications_active_outlined,
                      size: 30,
                    ),
                  ),
                  BlocBuilder<FriendRequestBloc, FriendRequestState>(
                    builder: (context, state) {
                      if (state is RequestedUsersLoaded) {
                        final rUsers = state.requestedUsers;
                        log(rUsers.toString());

                        if (rUsers.isNotEmpty) {
                          return Positioned(
                            top: 0,
                            right: 10,
                            child: Container(
                              width: 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.red,
                              ),
                              child: Center(
                                child: Text(
                                  state.reqlength.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          );
                        }
                      }
                      return Positioned(
                        top: 0,
                        right: 10,
                        child: Container(),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
        backgroundColor: appBackgroundColor,
        body: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state is UsersInitial) {
              BlocProvider.of<UserBloc>(context).add(LoadAllUsers());
            }
            if (state is UsersLoading) {
              return Center(child: CupertinoActivityIndicator());
            } else if (state is AllUsersLoaded) {
              final users = state.users;
              log(users.toString());
              if (users.isEmpty) {
                return Center(child: Text('No users found'));
              }
              return Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: RefreshIndicator.adaptive(
                  onRefresh: () async {
                    BlocProvider.of<UserBloc>(context).add(LoadAllUsers());
                  },
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return _buildUserListItem(context, users[index]);
                    },
                  ),
                ),
              );
            } else if (state is UsersError) {
              return Center(child: Text('Failed to load users'));
            } else {
              log("Container dekhhiracha");
              return Container();
            }
          },
        ),
      ),
    );
  }
}

_buildUserListItem(BuildContext context, Map<String, dynamic> user) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0, right: 4, left: 4),
    child: GestureDetector(
      onLongPress: () {
        // _showOptions(context, user['uid']);
      },
      child: Card(
        elevation: 0.2,
        child: Container(
          decoration: BoxDecoration(
            color: appSecondary,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ListTile(
            minLeadingWidth: Checkbox.width,
            leading: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.transparent,
                ),
              ),
              child: user['profileImageUrl'] == null ||
                      user['profileImageUrl'].isEmpty
                  ? Container(
                      decoration: BoxDecoration(
                          color: primaryColor, shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          getFirstandLastNameInitals(
                              user['name'] ?? ''.toUpperCase()),
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
                      imageUrl: user['profileImageUrl'],
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
            title: Text(
              user['name'] ?? 'No name',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            onTap: () {
              Get.to(() => ProfilePage(
                  imageUrl: user['profileImageUrl'],
                  uid: user['uid'],
                  fullname: user['name']));
            },
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            dense: true,
            selected: true,
            // selectedTileColor: Colors.blue.withOpacity(0.5),
            // tileColor: Colors.grey[200],
          ),
        ),
      ),
    ),
  );
}
