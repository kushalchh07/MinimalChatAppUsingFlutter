// ignore_for_file: prefer_const_constructors, unused_element

import 'package:chat_app/Bloc/chatBloc/chat_event.dart';
import 'package:chat_app/pages/Chat/big_image_screen.dart';
import 'package:chat_app/services/chat_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../Bloc/chatBloc/chat_bloc.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final Color color;
  final bool isMe;
  final String messageId;
  final String userId;
  final String? otherUserId;
  final bool isImage;
  ChatBubble(
      {super.key,
      required this.message,
      required this.color,
      required this.isMe,
      required this.messageId,
      required this.userId,
      required this.isImage,
       this.otherUserId});

//show options
  void _showoptions(BuildContext context, String messageId, String userId,
      String? otherUserId, bool isMe) {
    showBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
              child: Wrap(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              if (!isMe)
                ListTile(
                  leading: const Icon(Icons.flag),
                  title: const Text("Report"),
                  onTap: () {
                    Navigator.pop(context);
                    _reportContent(context, messageId, userId);
                  },
                ),
              if (isMe)
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text("Remove Message"),
                  onTap: () {
                    Navigator.pop(context);
                    _removeMessage(context, messageId, userId, otherUserId);
                    // _blockUser(context, userId);
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

  @override
  Widget build(BuildContext context) {
    bool isDeleted;
    return GestureDetector(
      onLongPress: () {
        _showoptions(context, messageId, userId, otherUserId, isMe);
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth:
              Get.width * 0.55, // Adjust this value based on your requirement
        ),
        child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: color,
            ),
            child: isImage
                ? (message.isNotEmpty)
                    ? GestureDetector(
                        onTap: () {
                          Get.to(() => BigImageScreen(imageUrl: message));
                        },
                        child: Image.network(
                          message,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset("assets/images/imageLoader.png")
                : Text(
                    message,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    maxLines: null,
                  )),
      ),
    );
  }

  void _removeMessage(BuildContext context, String messageId, String userId,
      String? otherUserId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Are you sure you want to remove this message?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: Text('Remove'),
              onPressed: () {
                ChatService _chatService = ChatService();
                // Add your reporting logic here
                _chatService
                    .deleteMessage(userId, otherUserId, messageId)
                    .then((value) {
                  if (value) {
                    Get.back();

                    BlocProvider.of<ChatBloc>(context).add(FetchChatEvent());
                    Fluttertoast.showToast(
                        msg: "Message Deleted",
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.green);
                  }
                });

                // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
