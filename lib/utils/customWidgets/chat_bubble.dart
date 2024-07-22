// ignore_for_file: prefer_const_constructors, unused_element

import 'package:chat_app/services/chat_services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final Color color;
  final bool isMe;
  final String messageId;
  final String userId;
  ChatBubble(
      {super.key,
      required this.message,
      required this.color,
      required this.isMe,
      required this.messageId,
      required this.userId});

//show options
  void _showoptions(BuildContext context, String messageId, String userId) {
    showBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
              child: Wrap(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text("Report"),
                onTap: () {
                  Navigator.pop(context);
                  _reportContent(context, messageId, userId);
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.block),
              //   title: const Text("Block User"),
              //   onTap: () {
              //     Navigator.pop(context);
              //     _blockUser(context, userId);
              //   },
              // ),
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

//report message
  _reportContent(BuildContext context, String messageId, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Are you sure you want to report this message?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: Text('Report'),
              onPressed: () {
                ChatService _chatService = ChatService();
                // Add your reporting logic here
                _chatService.reportUser(messageId, userId);
                Navigator.of(context).pop();
                Fluttertoast.showToast(
                    msg: "Message Reported",
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.green); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

//block user
  // _blockUser(BuildContext context, String userId) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Confirm'),
  //         content: Text('Are you sure you want to block this user?'),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text('Cancel'),
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Dismiss the dialog
  //             },
  //           ),
  //           TextButton(
  //             child: Text('Block'),
  //             onPressed: () {
  //               ChatService _chatService = ChatService();
  //               // Add your reporting logic here
  //               _chatService.blockUser(userId);
  //               Navigator.of(context).pop();
  //               Fluttertoast.showToast(
  //                   msg: "User Blocked",
  //                   gravity: ToastGravity.CENTER,
  //                   backgroundColor: Colors.green);

  //               // Dismiss the dialog
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (!isMe) {
          _showoptions(context, messageId, userId);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color,
        ),
        child:
            Text(message, style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}
