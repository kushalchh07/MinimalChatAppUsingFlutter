// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:chat_app/model/groupchat_model.dart';
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
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .get();
    String deviceToken;
    if (documentSnapshot.exists) {
      Map<String, dynamic>? userData =
          documentSnapshot.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('pushToken')) {
        deviceToken = userData['pushToken'];
        sendPushNotification(
            body: message,
            title: 'New Message',
            deviceToken: deviceToken,
            serverKey:
                'MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC2HncOH/2eC4Y5\nO73ERYQuXmHX95VmyFsCdoadi1qtxE8ISiCxsevuazwZfjuKko50cZO+UOxb4uaE\ngMfrBChYFuA8J+lmZFBY3ivKiCv3uo2kZH7tEKBI3hXqqvwhTbevkRc3i4+e1MdX\neiRE51P0BUJ07Gz0ug66SwAIaZFZL0pfCcYucYIKuTwYFbQU3kVk0XeNR/yBl/rh\nRLx7plOyAx0VI0fYZlNYyqrCOwPpSMWOy+/A3oP6Nhg9MTGM1lXKjl2oEDlqbo06\nx+PJmKpGj6Ld6HA7yc0Bz5CfGmEtiQyFLobSemSVnQ4M62VdjztvQVn7ViqxKSIg\nyOCcGFpXAgMBAAECggEAJTCNcVX5DXge/bsEYnsrpehiJJ8LZETPyO35SVy2tLtc\nxD2W9ZJ2smY1jKMpd3+8FW1IFVojGhR4rGA78vMTZgGt4rrnv6AGhE9CNAagq+Lt\nn79h5/k4MgkgAp7OA+MB+pkvW4llV7LtziBEHcn7a95TFttc2JDSBxrfs9gS9VoJ\nrsxjuBx51w5NITqGoJgHU/Y21RevAJltCqnDQ714sauYPwauPyWTW7CgLXL7vudj\nmEcl5jK6aAGeO2iq7FI6ErpQNrDTKGLiMErDw2TWMGU2N8PC5hX504m7H8lsjMtp\nT2WuR3XZC+XYAmUfP6kZqNnLcbSJU+ey+7dnA0tNeQKBgQDZNi1Ys5PewgI4FeLk\nfz8E0pt6D13CGdeCT6NRr1+2hQHqd7PBHOmsp7kysF39h37oz9xJrsrxL5zDEWy7\nkTQp+LmrD09qOKa2PmzDuSercSyEdv1EpxJNommEZA+Uo3T86pS+4NxjHIbBlnsQ\nYDS0tooeHboaEMOlzdJSmu4I9QKBgQDWpAeXYaZ9lxoPjV3fWCE25GWRPIXlZEgG\nLWFp7XM7p51KNT4mWI5zSaOxEm8lS9N+XvjdiY/NlED0DcaFOpBuaF3e+a2C56zR\nqiQ5hYRXs4WJ7NbhjjwK1Jvh7VSq8fK8lryjyayIrgmeO8S3OE0+qhyhMz/YOf/u\n6pvBd3h2mwKBgE7FlgZgAZU8OH/MeB8zglAmbJoEbpUQuBYa+XiLKCPR8pLsXDUB\nXkDuBny6dyuVctHNZ+8Uw6ZaBPi9HfibvRYnjHXbtIoqB1N6KgmE4T0Mav+TA2Bd\nUobzCl8nxnq6GJgMHmtmsqYC11/nSbPzn8mVlVs8npwLTliX3tl0NDTtAoGBAIMX\nvdc0efY8wlr7UXkmn2qiRnJVD8ZR4Dd9ogCLWRT3Q3beW+4Zqi85q7NredzCmhKV\nuNO9v8mkoaMtgrE+WpZEQgj8X4ATNZb8npFPPcw+xfG+aGNsdrl6rxZm2I5rpYCP\nY/l5JFp6ST+Oa5An3+3FAiVmYrkSe4EVYznfWQC/AoGBAK+/ggB8zJfCCJVpUIPo\nDinFpSWdmmxCnzYZ7DmFcnD72n1MtIV79EpPrgqZBEvmRY5lArllZ4IffvrNXbw4\nizJpoa+KfKaH4sloFlYV8fh4MxkJFAlIPmPLeol4LNMW5+6aT+0DWwRCn2vHfJat\nyiB0A5Aar8bpbbUU53ruM7oW');
        print("Device Token: $deviceToken");
      } else {
        print("Device token not found");
      }
    } else {
      print("User not found");
    }
    // add new message to database
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());

    // send push notification
  }

  Future<void> sendGroupMessage(
      String groupId, String message, bool isImage) async {
    try {
      // Get current user info
      final String currentUserId = _firebaseAuth.currentUser!.uid;

      // Fetch user details from the 'users' collection using the currentUserId
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUserId).get();

      if (!userDoc.exists) {
        throw Exception("User not found in the 'users' collection.");
      }

      // Extract user details
      Map<String, dynamic> userDetails = userDoc.data() as Map<String, dynamic>;
      final String currentUserEmail = userDetails['email'] ?? '';
      final String currentUserName = userDetails['name'] ??
          ''; // Assuming you have a 'name' field in the 'users' collection
      final String currentUserProfilePic = userDetails['profileImageUrl'] ??
          ''; // Assuming you have a 'profilePic' field

      // Create a timestamp for the message
      final Timestamp timestamp = Timestamp.now();

      // Create the message
      Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: groupId,
        message: message,
        isImage: isImage,
        timestamp: timestamp,
      );

      // Convert the message to a map and add additional user details
      Map<String, dynamic> messageData = newMessage.toMap();
      messageData.addAll({
        'senderName':
            currentUserName, // Add the sender's name to the message data
        'senderProfilePic':
            currentUserProfilePic, // Add the sender's profile picture to the message data
      });

      // Save the message to Firestore
      await _firestore
          .collection('chatRooms')
          .doc(groupId)
          .collection('messages')
          .add(messageData);

      log('Message sent successfully');
    } catch (e) {
      log('Error sending message: $e');
      throw e;
    }
  }

  Stream<QuerySnapshot> getGroupMessages(String groupId) {
    //construct chat rooms id from user ids (sorted to ensure it matches the id used when sending messages)
    // List<String> ids = [userId, otherUserId];
    // ids.sort();
    // String chatRoomId = ids.join("_");

    return _firestore
        .collection('chatRooms')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
    log(_firestore
        .collection('chatRooms')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .toString());
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

//Get all the users That are not blocked , are friends and are not the member of the chatRoom.
  Stream<List<Map<String, dynamic>>>
      getUsersStreamExcludingBlockedAcceptedAndChatRoomMembers(
          String chatRoomId) {
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

      // Get the chat room's member IDs
      final chatRoomSnapshot =
          await _firestore.collection('chatRooms').doc(chatRoomId).get();
      final List<String> chatRoomMembersIds =
          List<String>.from(chatRoomSnapshot.data()?['memberIds'] ?? []);

      // Get all users and apply the filtering conditions
      final userSnapshot = await _firestore.collection('users').get();

      return userSnapshot.docs
          .where((doc) {
            final userId = doc.id;
            final userEmail = doc.data()['email'];

            // Exclude the current user
            if (userEmail == currentUser.email) return false;

            // Exclude blocked users
            if (blockedUsersIds.contains(userId)) return false;

            // Exclude users who are not accepted friends
            if (!acceptedFriendsIds.contains(userId)) return false;

            // Exclude users who are already members of the chat room
            if (chatRoomMembersIds.contains(userId)) return false;

            // If all conditions are met, include the user
            return true;
          })
          .map((doc) => doc.data())
          .toList();
    });
  }

//Get all the Users In chatRoom
  Stream<List<Map<String, dynamic>>> getUsersInChatRoom(String chatRoomId) {
    final currentUser = _firebaseAuth.currentUser;

    return _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .snapshots()
        .asyncMap((chatRoomSnapshot) async {
      // Get the list of member IDs in the chat room
      final List<String> chatRoomMembersIds =
          List<String>.from(chatRoomSnapshot.data()?['memberIds'] ?? []);

      // Fetch the user data for each member ID
      final usersSnapshot = await _firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: chatRoomMembersIds)
          .get();

      // Return the user data as a list of maps
      return usersSnapshot.docs.map((doc) => doc.data()).toList();
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
      String userId, String? otherUserId, String messageId) async {
    try {
      List<String?> ids = [userId, otherUserId];
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

  Future<void> addMembersToChatRoom({
    required String chatRoomId,
    required List<String> memberIds,
  }) async {
    final chatRoomRef = _firestore.collection('chatRooms').doc(chatRoomId);

    await _firestore.runTransaction((transaction) async {
      final chatRoomSnapshot = await transaction.get(chatRoomRef);
      if (!chatRoomSnapshot.exists) {
        throw Exception("Chat room does not exist");
      }

      List<String> currentMembers =
          List<String>.from(chatRoomSnapshot['memberIds']);

      // Add new members to the existing ones
      currentMembers.addAll(memberIds);
      currentMembers = currentMembers.toSet().toList(); // Ensure uniqueness

      transaction.update(chatRoomRef, {'memberIds': currentMembers});
    });
  }

  Future<void> sendPushNotification({
    required String deviceToken,
    required String title,
    required String body,
    required String serverKey,
  }) async {
    log("Send NOtifications");
    try {
      // Define the payload for the FCM request
      final Map<String, dynamic> notificationPayload = {
        'to': deviceToken,
        'notification': {
          'title': title,
          'body': body,
        },
      };

      // Make the HTTP POST request to the FCM endpoint
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode(notificationPayload),
      );

      // Check for success
      if (response.statusCode == 200) {
        log('Notification sent successfully!');
      } else {
        log('Failed to send notification. Status code: ${response.statusCode}');
        ;
        log('Response body: ${response.body}');
      }
    } catch (e) {
      log('Error sending notification: $e');
    }
  }
}
