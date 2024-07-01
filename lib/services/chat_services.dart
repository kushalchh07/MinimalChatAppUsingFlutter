import 'package:chat_app/model/message.dart';
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
}
