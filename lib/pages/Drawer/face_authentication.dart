// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:chat_app/constants/colors/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'subscription_page.dart';

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Center(
          child: Container(
            // color: Colors.amber,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //create a body wherre it says you need to have a premium version to unlock this feature and provides details from where to get it .
                SizedBox(
                  height: 100,
                ),
                Text(
                  "You need to have a premium ",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "version to unlock this feature.",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Get the Premium Subscription Now",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                //provide me a button which says get premium now.
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => SubscriptionPage());
                  },
                  child: Text("Get Premium Now"),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
