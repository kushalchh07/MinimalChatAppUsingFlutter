// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';

// import 'package:flutter_chat_app/src/features/chat/domain/room_activity.dart';
// import 'package:flutter_chat_app/src/features/chat/domain/room_members.dart';

// typedef ChatRoomID = String;

// class ChatRoom {
//   ChatRoom({
//     required this.id,
//     required this.memberIds,
//     required this.members,
//     required this.activity,
//     this.isGroup = false,
//     this.deleted = false,
//     this.deletedAt,
//   });
//   final ChatRoomID id;
//   final List<String> memberIds;
//   final RoomMembers members;
//   final RoomActivity activity;
//   final bool isGroup;
//   final bool deleted;
//   final DateTime? deletedAt;

//   ChatRoom copyWith({
//     ChatRoomID? id,
//     List<String>? memberIds,
//     RoomMembers? members,
//     RoomActivity? activity,
//     bool? isGroup,
//     bool? deleted,
//     DateTime? deletedAt,
//   }) {
//     return ChatRoom(
//       id: id ?? this.id,
//       memberIds: memberIds ?? this.memberIds,
//       members: members ?? this.members,
//       activity: activity ?? this.activity,
//       isGroup: isGroup ?? this.isGroup,
//       deleted: deleted ?? this.deleted,
//       deletedAt: deletedAt ?? this.deletedAt,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     final chatRoomMap = <String, dynamic>{
//       'id': id,
//       'memberIds': memberIds,
//       'members': members.toMap(),
//       'activity': activity.toMap(),
//       'isGroup': isGroup,
//       'deleted': deleted,
//     };
//     if (deletedAt != null) {
//       chatRoomMap['deletedAt'] = Timestamp.fromDate(deletedAt!);
//     }
//     return chatRoomMap;
//   }

//   static ChatRoom? fromMap(Map<String, dynamic>? map) {
//     if (map == null) return null;
//     final deletedAt = map['deletedAt'];
//     return ChatRoom(
//       id: map['id'] ?? "",
//       memberIds: List<String>.from(map['memberIds'] ?? []),
//       members: RoomMembers.fromMap(map['members']),
//       activity: RoomActivity.fromMap(map['activity'] ?? {}),
//       isGroup: map['isGroup'] as bool,
//       deleted: map['deleted'] as bool,
//       deletedAt: deletedAt != null ? (deletedAt as Timestamp).toDate() : null,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   static ChatRoom? fromJson(String source) =>
//       ChatRoom.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() {
//     return 'ChatRoom(id: $id, memberIds: $memberIds, members: $members, activity: $activity, isGroup: $isGroup, deleted: $deleted, deletedAt: $deletedAt)';
//   }

//   @override
//   bool operator ==(covariant ChatRoom other) {
//     if (identical(this, other)) return true;

//     return other.id == id &&
//         listEquals(other.memberIds, memberIds) &&
//         other.members == members &&
//         other.activity == activity &&
//         other.isGroup == isGroup &&
//         other.deleted == deleted &&
//         other.deletedAt == deletedAt;
//   }

//   @override
//   int get hashCode {
//     return id.hashCode ^
//         memberIds.hashCode ^
//         members.hashCode ^
//         activity.hashCode ^
//         isGroup.hashCode ^
//         deleted.hashCode ^
//         deletedAt.hashCode;
//   }
// }


//   // 'members': members.map((key, value) => MapEntry(key, value.toMap())),

//         // members: Map<String, dynamic>.from(map['members'] ?? {})
//       //     .map((key, value) => MapEntry(key, ChatMemberData.fromMap(value))),