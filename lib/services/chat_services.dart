// ignore_for_file: unused_local_variable

import 'package:chat_app/model/message.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  //get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get user stream,

//Send Message
  Future<void> sendMessage(String receiverId, String message) async {
//get current user info
    final String currentUser = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();
    // create a message

    Message newMessage = Message(
        senderId: currentUser,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        message: message,
        // messageId:messageId,
        timestamp: timestamp);

    //construct chat room id from current user id and receiver id()
    List<String> ids = [currentUser, receiverId];
    ids.sort(); //sort the ids(this ensures the chat room id is always the same for any pair of users)
    String chatRoomId = ids.join(
        "_"); //combine the ids into a single string to use as a chat roomid

    // add new message to database
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

//get messages
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    //construct chat rooms id from user ids (sorted to ensure it matches the id used when sending messages)
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  //Get all the users except blocked user
  Stream<List<Map<String, dynamic>>> getUsersStreamExcludingBlocked() {
    final currentUser = _firebaseAuth.currentUser;
    return _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
      //get blocked users id
      final blockedUsersIds = snapshot.docs.map((doc) => doc.id).toList();
      //get all users
      final userSnapshot = await _firestore.collection('users').get();
      //return as stream list, excluding current user and blocked users
      return userSnapshot.docs
          .where((doc) =>
              doc.data()['email'] != currentUser.email &&
              !blockedUsersIds.contains(doc.id))
          .map((doc) => doc.data())
          .toList();
    });
  }

  // report user
  Future<void> reportUser(String messageId, String userId) async {
    // AuthService _authservice = AuthService();
    // ignore: prefer_const_declarations
    final currentUser = await FirebaseAuth.instance.currentUser!;
    final report = {
      'reportBy': currentUser!.uid,
      'messageId': messageId,
      'messageOwnerId': userId,
      'timestamp': FieldValue.serverTimestamp()
    };
    await _firestore.collection('Reports').add(report);
  }

  //block user
  Future<String> blockUser(String userId) async {
    final currentUser = await FirebaseAuth.instance.currentUser!;
    try {
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection("BlockedUsers")
          .doc(userId)
          .set({});
      return "blocked";
    } catch (e) {
      return "Error";
    }
  }

  //unblock user
  Future<String> unBlockUser(String blockeduserId) async {
    final currentUser = await FirebaseAuth.instance.currentUser!;
    try {
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection("BlockedUsers")
          .doc(blockeduserId)
          .delete()
          .then((value) => "unblocked");
      return "unblocked";
    } catch (e) {
      return "Error";
    }
  }
  //get blocked userr stream

  Stream<List<Map<String, dynamic>>> getBlockedUsers(String userid) {
    return _firestore
        .collection('users')
        .doc(userid)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
      //get list of blocked user ids
      final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();
      final userDocs = await Future.wait(blockedUserIds
          .map((id) => _firestore.collection('users').doc(id).get()));
      //return as a list
      return userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }
}
