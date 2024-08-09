import 'package:cloud_firestore/cloud_firestore.dart';

typedef ChatRoomID = String;

class ChatRoom {
  final String id;
  final String name;
  final List<String> memberIds;
  final bool isGroup;
  final bool deleted;
  final dynamic createdAt;
  final String groupImageUrl;
  final String adminId;

  ChatRoom({
    required this.id,
    required this.name,
    required this.memberIds,
    required this.isGroup,
    required this.deleted,
    required this.createdAt,
    required this.groupImageUrl,
    required this.adminId,
  });

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'] ?? '', // Default to empty string if null
      name: map['name'] ?? 'Unnamed Group', // Provide a default name if null
      memberIds: List<String>.from(
          map['memberIds'] ?? []), // Default to empty list if null
      isGroup: map['isGroup'] ?? false, // Default to false if null
      deleted: map['deleted'] ?? false, // Default to false if null
      createdAt: map['createdAt'] ??
          FieldValue.serverTimestamp(), // Default to server timestamp if null
      groupImageUrl:
          map['groupImageUrl'] ?? '', // Default to empty string if null
      adminId: map['adminId'] ?? '', // Default to empty string if null
    );
  }
}
