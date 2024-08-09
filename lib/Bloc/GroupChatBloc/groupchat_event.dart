part of 'groupchat_bloc.dart';

sealed class GroupchatEvent extends Equatable {
  const GroupchatEvent();

  @override
  List<Object> get props => [];
}

class CreateGroupChatEvent extends GroupchatEvent {
  final String chatRoomName;
  final List<String> memberIds;

  const CreateGroupChatEvent(this.chatRoomName, this.memberIds);

  @override
  List<Object> get props => [chatRoomName, memberIds];
}

class GroupChatAddedEvent extends GroupchatEvent {
// final List<String> members;
//   GroupChatAddedEvent({required this.members});
}

class ChatRoomSelect extends GroupchatEvent {
  final String chatRoomId;

  const ChatRoomSelect(this.chatRoomId);

  @override
  List<Object> get props => [chatRoomId];
}

class GroupChatLoadEvent extends GroupchatEvent {}

class GroupChatDeleteEvent extends GroupchatEvent {
  final String chatRoomId;

  const GroupChatDeleteEvent(this.chatRoomId);

  @override
  List<Object> get props => [chatRoomId];
}

class AddMembersToChatRoomEvent extends GroupchatEvent {
  final String chatRoomId;
  final List<String> memberIds;

  const AddMembersToChatRoomEvent(
      {required this.chatRoomId, required this.memberIds});

  @override
  List<Object> get props => [chatRoomId, memberIds];
}

class RemoveMembersFromChatRoomEvent extends GroupchatEvent {
  final String chatRoomId;
  final List<String> memberIds;

  const RemoveMembersFromChatRoomEvent(
      {required this.chatRoomId, required this.memberIds});

  @override
  List<Object> get props => [chatRoomId, memberIds];
}
