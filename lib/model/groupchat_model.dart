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
  ChatRoom({
    required this.id,
    required this.name,
    required this.memberIds,
    required this.isGroup,
    required this.deleted,
    required this.createdAt,
    required this.groupImageUrl,
  });

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'],
      name: map['name'],
      memberIds: List<String>.from(map['memberIds']),
      isGroup: map['isGroup'],
      deleted: map['deleted'],
      createdAt: map['createdAt'],
      groupImageUrl: map['groupImageUrl'],
    );
  }
}
