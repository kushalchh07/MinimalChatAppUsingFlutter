// ignore_for_file: avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserPassword extends StatefulWidget {
  const UserPassword({super.key});

  @override
  State<UserPassword> createState() => _UserPasswordState();
}

final TextEditingController _passwordController = TextEditingController();

class _UserPasswordState extends State<UserPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Work In progress")],
        ),
      ),
    );
  }
}
