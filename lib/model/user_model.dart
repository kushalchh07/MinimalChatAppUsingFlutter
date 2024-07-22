import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String name;
  final String profileImageUrl;
  final String uid;
  final bool isOnline;
  final String pushToken;
  final Timestamp lastActive;

  UserModel({
    required this.email,
    required this.name,
    required this.profileImageUrl,
    required this.uid,
    required this.isOnline,
    required this.pushToken,
    required this.lastActive,
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
    );
  }
}
