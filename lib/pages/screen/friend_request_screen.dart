// import 'package:chat_app/constants/colors/colors.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:chat_app/Bloc/friendRequest/friend_request_bloc.dart';
// import 'package:chat_app/Bloc/friendRequest/friend_request_event.dart';
// import 'package:chat_app/Bloc/friendRequest/friend_request_state.dart';

// class FriendRequestScreen extends StatefulWidget {
//   const FriendRequestScreen({super.key});

//   @override
//   State<FriendRequestScreen> createState() => _FriendRequestScreenState();
// }

// class _FriendRequestScreenState extends State<FriendRequestScreen> {
//   @override
//   void initState() {
//     super.initState();
//     final userId = FirebaseAuth.instance.currentUser!.uid;
//     // Start listening for friend requests
//     context
//         .read<FriendRequestBloc>()
//         .add(StartListeningForFriendRequests(userId));
//   }

//   @override
//   void dispose() {
//     // No need to access Bloc here
//     super.dispose();
//   }

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: appBackgroundColor,
//         elevation: 2,
//         leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: Icon(Icons.arrow_back_ios)),
//       ),
//       backgroundColor: appBackgroundColor,
//       body: BlocBuilder<FriendRequestBloc, FriendRequestState>(
//         builder: (context, state) {
//           if (state is FriendRequestNotification) {
//             if (state.friendRequests.isEmpty) {
//               return Center(child: Text("No Friend Requests"));
//             }
//             return ListView.builder(
//               itemCount: state.friendRequests.length,
//               itemBuilder: (context, index) {
//                 final request = state.friendRequests[index];
//                 return ListTile(
//                   title: Text("Friend Request from ${request['fromUserId']}"),
//                   subtitle: Text("Status: ${request['status']}"),
//                   trailing: IconButton(
//                     icon: Icon(Icons.check),
//                     onPressed: () {
//                       // Handle accepting friend request
//                     },
//                   ),
//                 );
//               },
//             );
//           }
//           if (state is FriendRequestError) {
//             return Center(child: Text("Error: ${state.message}"));
//           }
//           return Center(child: CupertinoActivityIndicator());
//         },
//       ),
//     );
//   }
// }
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Bloc/friendRequest/friend_request_bloc.dart';
import 'package:chat_app/Bloc/friendRequest/friend_request_event.dart';
import 'package:chat_app/Bloc/friendRequest/friend_request_state.dart';
import 'package:chat_app/constants/colors/colors.dart';
import 'package:chat_app/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class FriendRequestScreen extends StatefulWidget {
  const FriendRequestScreen({super.key});

  @override
  State<FriendRequestScreen> createState() => _FriendRequestScreenState();
}

class _FriendRequestScreenState extends State<FriendRequestScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<FriendRequestBloc>(context).add(LoadRequestedUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBackgroundColor,
        elevation: 2,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios_new)),
      ),
      backgroundColor: appBackgroundColor,
      body: BlocConsumer<FriendRequestBloc, FriendRequestState>(
        listener: (context, state) {
          if (state is FriendRequestAccepted) {
            Fluttertoast.showToast(
                msg: "Request Accepted Successfully.",
                backgroundColor: successColor);
          }
          if (state is FriendRequestRejected) {
            Fluttertoast.showToast(
                msg: "Request Rejected.", backgroundColor: successColor);
          }
        },
        builder: (context, state) {
          if (state is RequestedUsersLoaded) {
            return RefreshIndicator.adaptive(
              onRefresh: () async {
                BlocProvider.of<FriendRequestBloc>(context)
                    .add(LoadRequestedUsers());
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: state.requestedUsers.length,
                  itemBuilder: (context, index) {
                    if (index >= state.requestedUsers.length ||
                        index >= state.rUsers.length) {
                      return SizedBox(); // Return an empty widget if index is out of bounds
                    }
                    final user = state.requestedUsers[index];
                    final requesteduser = state.rUsers[index];
                    log(requesteduser.toString());
                    return _buildUserListItem(context, user, requesteduser);
                  },
                ),
              ),
            );
          }
          return Center(
            child: Text('No friend requests found'),
          );
        },
      ),
    );
  }
}

Widget _buildUserListItem(BuildContext context, Map<String, dynamic> user,
    Map<String, dynamic> rUsers) {
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  return rUsers['fromUserId'] != FirebaseAuth.instance.currentUser!.uid
      ? Padding(
          padding: const EdgeInsets.only(top: 8.0, right: 4, left: 4),
          child: GestureDetector(
            onLongPress: () {},
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
                              color: primaryColor, shape: BoxShape.circle),
                          child: Center(
                            child: Text(
                              getFirstandLastNameInitals(
                                  user['name']?.toUpperCase() ?? ''),
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
                trailing: SizedBox(
                  width: Get.width * 0.25,
                  child: BlocConsumer<FriendRequestBloc, FriendRequestState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state is FriendRequestProcessing) {
                        return CupertinoActivityIndicator();
                      }
                      if (state is FriendRequestAccepted) {
                        return IconButton(
                            onPressed: () {}, icon: Text("Friends"));
                      }
                      if (state is FriendRequestRejected) {
                        return IconButton(
                            onPressed: () {}, icon: Text("Rejected"));
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                BlocProvider.of<FriendRequestBloc>(context).add(
                                    AcceptFriendRequest(
                                        currentUserId, user['uid']));
                              },
                              icon: Icon(Icons.check)),
                          IconButton(
                              onPressed: () {
                                BlocProvider.of<FriendRequestBloc>(context).add(
                                    RejectFriendRequest(
                                        currentUserId, user['uid']));
                              },
                              icon: Icon(Icons.close)),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        )
      : Container();
}
