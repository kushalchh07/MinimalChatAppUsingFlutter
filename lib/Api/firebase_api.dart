import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Api {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  // static final FlutterLocalNotificationsPlugin
  //     _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static Future init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      carPlay: true,
      badge: true,
      sound: true,
      criticalAlert: true,
      provisional: true,
    );
  }

  static Future<String> getDeviceToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      return token!;
    } catch (e) {
      log(e.toString());
      return "";
    }
  }

  //setting this token to the users collection in database
  static Future saveUserToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    String deviceToken = await getDeviceToken();
    log(deviceToken);
    Map<String, dynamic> data = {
      "pushToken": deviceToken,
    };
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .update({
        'pushToken': deviceToken,
      });
      print("Document added");
    } catch (e) {
      print("Error in saving to firestore");
      print(e.toString());
    }
  }
}
