import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String name;
  final String profileImageUrl;
  final String uid;
  final bool isOnline;
  final String pushToken;
  final Timestamp lastActive;
  List<String> friendsUids;
  List<String> friendRequestsUids;
  List<String> blockedUsersUids;
  List<String> blockedByUsersUids;
  List<String> friendRequestsSentUids;


  UserModel({
    required this.email,
    required this.name,
    required this.profileImageUrl,
    required this.uid,
    required this.isOnline,
    required this.pushToken,
    required this.lastActive,
    required this.friendsUids,
    required this.friendRequestsUids,
    required this.blockedUsersUids,
    required this.blockedByUsersUids,
    required this.friendRequestsSentUids,
  });

  // convert to a map
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'uid': uid,
      'isOnline': isOnline,
      'pushToken': pushToken,
      'lastActive': lastActive,
      'friendsUids': friendsUids,
      'friendRequestsUids': friendRequestsUids,
      'blockedUsersUids': blockedUsersUids,
      'blockedByUsersUids': blockedByUsersUids,
      'friendRequestsSentUids': friendRequestsSentUids,
    };
  }

  // convert from a map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'],
      name: map['name'],
      profileImageUrl: map['profileImageUrl'],
      uid: map['uid'],
      isOnline: map['isOnline'],
      pushToken: map['pushToken'],
      lastActive: map['lastActive'],
      friendsUids: List<String>.from(map['friendsUids']),
      friendRequestsUids: List<String>.from(map['friendRequestsUids']),
      blockedUsersUids: List<String>.from(map['blockedUsersUids']),
      blockedByUsersUids: List<String>.from(map['blockedByUsersUids']),
      friendRequestsSentUids: List<String>.from(map['friendRequestsSentUids']),
    );
  }
}
