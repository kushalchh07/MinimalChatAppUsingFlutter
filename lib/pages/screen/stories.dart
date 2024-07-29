import 'package:chat_app/constants/colors/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Stories extends StatefulWidget {
  const Stories({super.key});

  @override
  State<Stories> createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stories"),
        backgroundColor: appBackgroundColor,
        actions: [
          Image.asset(
            "assets/images/chat.png",
            height: 60,
          ),
        ],
      ),
    );
  }
}
