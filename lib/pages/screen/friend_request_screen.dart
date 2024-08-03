import 'package:chat_app/constants/colors/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/Bloc/friendRequest/friend_request_bloc.dart';
import 'package:chat_app/Bloc/friendRequest/friend_request_event.dart';
import 'package:chat_app/Bloc/friendRequest/friend_request_state.dart';

class FriendRequestScreen extends StatefulWidget {
  const FriendRequestScreen({super.key});

  @override
  State<FriendRequestScreen> createState() => _FriendRequestScreenState();
}

class _FriendRequestScreenState extends State<FriendRequestScreen> {
  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    // Start listening for friend requests
    context
        .read<FriendRequestBloc>()
        .add(StartListeningForFriendRequests(userId));
  }

  @override
  void dispose() {
    // No need to access Bloc here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBackgroundColor,
        elevation: 2,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      backgroundColor: appBackgroundColor,
      body: BlocBuilder<FriendRequestBloc, FriendRequestState>(
        builder: (context, state) {
          if (state is FriendRequestNotification) {
            if (state.friendRequests.isEmpty) {
              return Center(child: Text("No Friend Requests"));
            }
            return ListView.builder(
              itemCount: state.friendRequests.length,
              itemBuilder: (context, index) {
                final request = state.friendRequests[index];
                return ListTile(
                  title: Text("Friend Request from ${request['fromUserId']}"),
                  subtitle: Text("Status: ${request['status']}"),
                  trailing: IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      // Handle accepting friend request
                    },
                  ),
                );
              },
            );
          }
          if (state is FriendRequestError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
