import 'package:chat_app/constants/colors/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBackgroundColor,
        title: Text("Users"),
      ),
      backgroundColor: appBackgroundColor,
      body: Center(
        child: Text("Users"),
      ),
    );
  }
}
