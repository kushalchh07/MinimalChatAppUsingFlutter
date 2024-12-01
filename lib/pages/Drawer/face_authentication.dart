// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:chat_app/constants/colors/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'recognition_screen.dart';
import 'registration_screen.dart';
import 'subscription_page.dart';

class FaceAuthentication extends StatefulWidget {
 FaceAuthentication({super.key, required this.isPerimum});
  bool isPerimum;
  @override
  State<FaceAuthentication> createState() => _FaceAuthenticationState();
}

class _FaceAuthenticationState extends State<FaceAuthentication> {
  @override
  void initState() {
    super.initState();
   
  }

  

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return widget.isPerimum
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: appBackgroundColor,
              elevation: 0,
              title: Text("Face Authentication"),
              centerTitle: true,
              surfaceTintColor: whiteColor,
              leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: blackColor,
                  )),
            ),
            backgroundColor: appBackgroundColor,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    margin: const EdgeInsets.only(top: 100),
                    child: Image.asset(
                      "assets/images/logo.png",
                      width: screenWidth - 40,
                      height: screenWidth - 40,
                    )),
                Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegistrationScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(screenWidth - 30, 50)),
                        child: const Text("Register"),
                      ),
                      Container(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RecognitionScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(screenWidth - 30, 50)),
                        child: const Text("Recognize"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Scaffold(
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
