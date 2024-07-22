import 'package:chat_app/Bloc/userBloc/user_bloc.dart';
import 'package:chat_app/constants/colors/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Bloc/userBloc/user_event.dart';
import '../../Bloc/userBloc/user_state.dart';

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
            return GestureDetector(
              onLongPress: () {
                _showoptions(context, state.blockedusers[0]['uid']);
              },
              child: ListView(
                children: users
                    .where((user) =>
                        user['email'] !=
                        FirebaseAuth.instance.currentUser?.email)
                    .map((user) => _buildUserListItem(context, user))
                    .toList(),
              ),
            );
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
      child: Container(
        decoration: BoxDecoration(
          color: appSecondary,

          // border: Border.all(color: Colors.black), // Border color
          borderRadius: BorderRadius.circular(5.0),
          // Border radius
        ),
        child: ListTile(
          leading: Icon(Icons.account_circle),
          title: Text(
            user['name'] ?? 'No name',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          onTap: () {},
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          dense: true,
          selected: true,
          selectedTileColor: Colors.blue.withOpacity(0.5),
          tileColor: Colors.grey[200],
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
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              // ListTile(
              //   leading: const Icon(Icons.flag),
              //   title: const Text("Report"),
              //   onTap: () {
              //     Navigator.pop(context);
              //     // _reportContent(context, messageId, userId);
              //   },
              // ),
              ListTile(
                leading: const Icon(Icons.block),
                title: const Text("UnBlock User"),
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
          ));
        });
  }

  //block user
  _unblockUser(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Are you sure you want to block this user?'),
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
                Navigator.of(context).pop();

                // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
