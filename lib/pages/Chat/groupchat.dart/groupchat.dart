// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Bloc/GroupChatBloc/groupchat_bloc.dart';
import 'package:chat_app/Bloc/userBloc/user_bloc.dart';
import 'package:chat_app/Bloc/userBloc/user_event.dart';
import 'package:chat_app/Bloc/userBloc/user_state.dart';
import 'package:chat_app/constants/colors/colors.dart';
import 'package:chat_app/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

TextEditingController _gropNameController = TextEditingController();
final List<String> _selectedMemberIds = [];

class _GroupChatScreenState extends State<GroupChatScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<GroupchatBloc>(context).add(GroupChatLoadEvent());
    BlocProvider.of<UserBloc>(context).add(LoadUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBackgroundColor,
          elevation: 0.2,
          title: Text('Group Chat'),
          actions: <Widget>[
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert),
              onSelected: (String result) {
                if (result == 'Create Group Chat') {
                  // Handle create group chat action
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return AlertDialog(
                            title: Text('Create Group Chat'),
                            content: Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListBody(
                                      children: <Widget>[
                                        _buildTextFormField(
                                            _gropNameController, 'Group Name'),
                                      ],
                                    ),
                                    Text("Select Members:"),
                                    Divider(),
                                    BlocBuilder<UserBloc, UserState>(
                                      builder: (context, state) {
                                        if (state is UsersLoading) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else if (state is UsersLoaded) {
                                          return Container(
                                            height:
                                                300.0, // Set a fixed height for the ListView
                                            child: ListView.builder(
                                              itemCount: state.users.length,
                                              itemBuilder: (context, index) {
                                                final user = state.users[index];
                                                return CheckboxListTile(
                                                  title: Text(user['name']),
                                                  value: _selectedMemberIds
                                                      .contains(user['uid']),
                                                  onChanged:
                                                      (bool? isSelected) {
                                                    setState(() {
                                                      if (isSelected == true) {
                                                        _selectedMemberIds
                                                            .add(user['uid']);
                                                      } else {
                                                        _selectedMemberIds
                                                            .remove(
                                                                user['uid']);
                                                      }
                                                    });
                                                  },
                                                );
                                              },
                                            ),
                                          );
                                        } else if (state is UserLoadFailure) {
                                          return Center(
                                              child: Text(
                                                  'Failed to load users: '));
                                        } else {
                                          return Container();
                                        }
                                      },
                                    ),
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
                                onPressed: () async {
                                  String currentUserId =
                                      FirebaseAuth.instance.currentUser!.uid;

                                  _selectedMemberIds.add(currentUserId);
                                  BlocProvider.of<GroupchatBloc>(context).add(
                                    CreateGroupChatEvent(
                                      _gropNameController.text,
                                      _selectedMemberIds,
                                    ),
                                  );

                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'Create Group Chat',
                  child: Text('Create Group Chat'),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: appBackgroundColor,
        body: RefreshIndicator.adaptive(
          onRefresh: () async {
            BlocProvider.of<GroupchatBloc>(context).add(GroupChatLoadEvent());
          },
          child: Container(
            child: BlocConsumer<GroupchatBloc, GroupchatState>(
              listener: (context, state) {
                if (state is ChatRoomCreated) {
                  BlocProvider.of<GroupchatBloc>(context)
                      .add(GroupChatLoadEvent());
                  Fluttertoast.showToast(
                      msg: 'Group Chat Created',
                      backgroundColor: successColor,
                      gravity: ToastGravity.CENTER);
                }
              },
              builder: (context, state) {
                if (state is ChatRoomLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is ChatRoomsLoaded) {
                  return state.chatRooms.isEmpty
                      ? Center(child: Text('No Rooms Created Yet.'))
                      : ListView.builder(
                          itemCount: state.chatRooms.length,
                          itemBuilder: (context, index) {
                            return buildgroupListItem(context, state, index);
                          },
                        );
                }
                if (state is CreateChatRoomFailure) {
                  return Text(state.error);
                }

                return Center(child: Text('No Rooms Created Yet.'));
              },
            ),
          ),
        ));
  }

  Widget _buildTextFormField(
      TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            fontFamily: 'inter',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter $labelText';
          }
          return null;
        },
      ),
    );
  }
}

buildgroupListItem(BuildContext context, ChatRoomsLoaded state, index) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0, right: 4, left: 4),
    child: GestureDetector(
      onLongPress: () {
        // _showOptions(context, user['uid']);
      },
      child: Container(
        decoration: BoxDecoration(
          color: appSecondary,

          // border: Border.all(color: Colors.black), // Border color
          borderRadius: BorderRadius.circular(5.0),
          // Border radius
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
                // width: 2,
              ),
            ),
            child: state.chatRooms[index].groupImageUrl.isEmpty ?? true
                ? Container(
                    // height: 60,
                    // width: 60,
                    decoration: BoxDecoration(
                        color: primaryColor, shape: BoxShape.circle),
                    child: Center(
                      child: Text(
                        getFirstandLastNameInitals(
                            state.chatRooms[index].name ?? ''.toUpperCase()),
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
                    imageUrl: state.chatRooms[index].groupImageUrl,
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
            state.chatRooms[index].name,
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          subtitle: Text(
            "Enjoy Chatting with friends",
            style: TextStyle(fontFamily: 'poppins', fontSize: 16),
          ),
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => ChatPage(
            //       receiverUserEmail: user['name'],
            //       receiverUserId: user['uid'],
            //       receiverimageUrl: user['profileImageUrl'],
            //       senderImageUrl: imageUrl ?? '',
            //       isImage: isImage,
            //     ),
            //   ),
            // );
          },
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          dense: true,
          selected: true,
          selectedTileColor: Colors.blue.withOpacity(0.5),
          tileColor: Colors.grey[200],
        ),
      ),
    ),
  );
}
