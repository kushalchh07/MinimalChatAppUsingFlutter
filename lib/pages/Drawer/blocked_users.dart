import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Bloc/userBloc/user_bloc.dart';
import 'package:chat_app/constants/colors/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Bloc/userBloc/user_event.dart';
import '../../Bloc/userBloc/user_state.dart';
import '../../constants/constants.dart';

class BlockedUsers extends StatefulWidget {
  const BlockedUsers({super.key});

  @override
  State<BlockedUsers> createState() => _BlockedUsersState();
}

class _BlockedUsersState extends State<BlockedUsers> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserBloc>(context).add(LoadBlockedUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blocked Users'),
        centerTitle: true,
        backgroundColor: appBackgroundColor,
      ),
      backgroundColor: appBackgroundColor,
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is UsersLoading) {
            return Center(child: CupertinoActivityIndicator());
          } else if (state is BlockedUsersLoaded) {
            final users = state.blockedusers;
            if (users.isEmpty) {
              return Center(child: Text('No users found'));
            }
            return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return _buildUserListItem(context, users[index]);
                });
          } else if (state is UsersError) {
            return Center(child: Text('Failed to load users'));
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildUserListItem(BuildContext context, Map<String, dynamic> user) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, right: 4, left: 4),
      child: GestureDetector(
        onLongPress: () {
          _showoptions(context, user['uid']);
        },
        child: Container(
          decoration: BoxDecoration(
            color: appSecondary,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListTile(
            leading: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.transparent,
                ),
              ),
              child: user['profileImageUrl'].isEmpty
                  ? Container(
                      decoration: BoxDecoration(
                          color: primaryColor, shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          getFirstandLastNameInitals(
                              user['name'].toUpperCase()),
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
            onTap: () {},
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            dense: true,
            selected: true,
            selectedTileColor: Colors.blue.withOpacity(0.5),
            tileColor: Colors.grey[200],
          ),
        ),
      ),
    );
  }

  _showoptions(BuildContext context, String userId) {
    showBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.block),
                title: const Text("Unblock User."),
                onTap: () {
                  Navigator.pop(context);
                  _unblockUser(context, userId);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text("Cancel"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  _unblockUser(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Are you sure you want to unblock this user?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: Text('UnBlock'),
              onPressed: () {
                BlocProvider.of<UserBloc>(context)
                    .add(UnBlockUserEvent(userId));
                BlocProvider.of<UserBloc>(context).add(LoadBlockedUsers());
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
