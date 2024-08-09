// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Bloc/userBloc/user_bloc.dart';
import 'package:chat_app/Bloc/userBloc/user_event.dart';
import 'package:chat_app/Bloc/userBloc/user_state.dart';
import 'package:chat_app/constants/colors/colors.dart';
import 'package:chat_app/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Bloc/GroupChatBloc/groupchat_bloc.dart';

class AddNewMembers extends StatefulWidget {
  final String groupId; // Chat Room ID to add new members

  const AddNewMembers({super.key, required this.groupId});

  @override
  State<AddNewMembers> createState() => _AddNewMembersState();
}

class _AddNewMembersState extends State<AddNewMembers> {
  final Set<String> _selectedMemberIds = {}; // To hold selected user IDs

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Members'),
        elevation: 2.0,
        backgroundColor: appBackgroundColor,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // Pass selected user IDs to the Bloc
              if (_selectedMemberIds.isNotEmpty) {
                BlocProvider.of<GroupchatBloc>(context).add(
                  AddMembersToChatRoomEvent(
                    chatRoomId: widget.groupId,
                    memberIds: _selectedMemberIds.toList(),
                  ),
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('No members selected')),
                );
              }
            },
          ),
        ],
      ),
      backgroundColor: appBackgroundColor,
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          // Handle any state changes
        },
        builder: (context, state) {
          if (state is UsersInitial) {
            BlocProvider.of<UserBloc>(context).add(LoadUsers());
          }
          if (state is UsersLoading) {
            return Center(child: CupertinoActivityIndicator());
          } else if (state is UsersLoaded) {
            final users = state.users;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return _buildUserListItem(context, users[index]);
                },
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildUserListItem(BuildContext context, Map<String, dynamic> user) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, right: 4, left: 4),
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            color: appSecondary,
            borderRadius: BorderRadius.circular(5.0),
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
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
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
            subtitle: Text(
              "Hello I am New Here.",
              style: TextStyle(fontFamily: 'poppins', fontSize: 16),
            ),
            trailing: Checkbox(
              value: _selectedMemberIds.contains(user['uid']),
              onChanged: (bool? isSelected) {
                setState(() {
                  if (isSelected == true) {
                    _selectedMemberIds.add(user['uid']);
                    log(_selectedMemberIds.toString());
                  } else {
                    _selectedMemberIds.remove(user['uid']);
                    log(_selectedMemberIds.toString());
                  }
                });
              },
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            dense: true,
            selected: _selectedMemberIds.contains(user['uid']),
            selectedTileColor: Colors.blue.withOpacity(0.5),
            tileColor: Colors.grey[200],
          ),
        ),
      ),
    );
  }
}
