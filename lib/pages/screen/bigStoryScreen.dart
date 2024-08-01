import 'dart:async';

import 'package:chat_app/constants/colors/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class Bigstoryscreen extends StatefulWidget {
  String url;
  Bigstoryscreen({super.key, required this.url});

  @override
  State<Bigstoryscreen> createState() => _BigstoryscreenState();
}

class _BigstoryscreenState extends State<Bigstoryscreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pop(context);
    });
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
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        height: Get.height,
        width: Get.width,
        child: Image.network(
          widget.url,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
