import 'package:chat_app/constants/colors/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FaceAuthentication extends StatefulWidget {
  const FaceAuthentication({super.key});

  @override
  State<FaceAuthentication> createState() => _FaceAuthenticationState();
}

class _FaceAuthenticationState extends State<FaceAuthentication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBackgroundColor,
        elevation: 0,
        title: Text("Face Authentication"),
      ),
    );
  }
}
