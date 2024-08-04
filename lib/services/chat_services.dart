// ignore_for_file: unused_local_variable

import 'dart:developer';

import 'package:chat_app/model/message.dart';
import 'package:chat_app/pages/Chat/chat_screen.dart';
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
  Future<void> sendMessage(
      String receiverId, String message, bool isImage) async {
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
        isImage: isImage,
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
      // Get accepted friends IDs
      final friendsSnapshot = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('friendRequests')
          .where('status', isNotEqualTo: 'accepted')
          .get();
      final acceptedFriendsIds =
          friendsSnapshot.docs.map((doc) => doc.id).toList();
      //return as stream list, excluding current user and blocked users
      return userSnapshot.docs
          .where((doc) =>
                  doc.data()['email'] != currentUser.email &&
                  !blockedUsersIds.contains(doc.id)
              //  &&
              // !acceptedFriendsIds.contains(doc.id)
              )
          .map((doc) => doc.data())
          .toList();
    });
  }

//Get all the users which are not blocked and status is pending
  Stream<List<Map<String, dynamic>>>
      getUsersStreamExcludingBlockedAndPending() {
    final currentUser = _firebaseAuth.currentUser;
    return _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((blockedSnapshot) async {
      // Get blocked users IDs
      final blockedUsersIds =
          blockedSnapshot.docs.map((doc) => doc.id).toList();
      // Get all users
      final userSnapshot = await _firestore.collection('users').get();
      final friendsSnapshot = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('friendRequests')
          .where('status', isEqualTo: 'pending')
          .get();
      final pendingFriendsIds =
          friendsSnapshot.docs.map((doc) => doc.id).toList();
      // Return as stream list, excluding current user and blocked users
      return userSnapshot.docs
          .where((doc) =>
              doc.data()['email'] != currentUser.email &&
              !blockedUsersIds.contains(doc.id) &&
              pendingFriendsIds.contains(doc.id))
          .map((doc) => doc.data())
          .toList();
    });
  }

// Get all the users which are friends and arenot blocked
  Stream<List<Map<String, dynamic>>>
      getUsersStreamExcludingBlockedAndAcceptedFriends() {
    final currentUser = _firebaseAuth.currentUser;
    return _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((blockedSnapshot) async {
      // Get blocked users IDs
      final blockedUsersIds =
          blockedSnapshot.docs.map((doc) => doc.id).toList();

      // Get accepted friends IDs
      final friendsSnapshot = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('friendRequests')
          .where('status', isEqualTo: 'accepted')
          .get();
      final acceptedFriendsIds =
          friendsSnapshot.docs.map((doc) => doc.id).toList();

      // Get all users
      final userSnapshot = await _firestore.collection('users').get();

      // Return as stream list, excluding current user, blocked users, and accepted friends
      return userSnapshot.docs
          .where((doc) =>
              doc.data()['email'] != currentUser.email &&
              !blockedUsersIds.contains(doc.id) &&
              acceptedFriendsIds.contains(
                  doc.id)) // Only include users who are accepted friends
          .map((doc) => doc.data())
          .toList();
    });
  }

// Get all the users
  Stream<List<Map<String, dynamic>>> getUsersStream() {
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

// Get accepted friend requests
  Stream<List<String>> getAcceptedFriendRequestIdsStream() {
    final currentUser = _firebaseAuth.currentUser;
    return _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('friendRequests')
        .where('status', isEqualTo: 'accepted')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.id).toList();
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

  Future<bool> deleteMessage(
      String userId, String otherUserId, String messageId) async {
    log(userId);
    log(otherUserId);
    log(messageId);
    try {
      List<String> ids = [userId, otherUserId];
      ids.sort();
      String chatRoomId = ids.join("_");
      // Reference to the specific message document
      await FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .doc(messageId)
          .delete();

      // Delete the document

      return true;
    } catch (e) {
      rethrow;
      log('Error deleting message: $e');
    }
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
      await _firestore
          .collection('users')
          .doc(userId)
          .collection("BlockedUsers")
          .doc(currentUser.uid)
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
          .delete();
      await _firestore
          .collection('users')
          .doc(blockeduserId)
          .collection("BlockedUsers")
          .doc(currentUser.uid)
          .delete();

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

  // Future<void> createGroupChat(String chatRoomTitle) async {
  //   final currentUser = _firebaseAuth.currentUser;
  //   final chatRoomId = currentUser!.uid + chatRoomTitle;
  //   if (currentUser == null) {
  //     throw Exception("something went wrong creating group chat");
  //   }
  //   // final now = currentDate();
  //   final selectedMembers;
  //   final chatRoom = ChatRoom();
  // }
}
