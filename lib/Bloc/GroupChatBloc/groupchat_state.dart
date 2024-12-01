part of 'groupchat_bloc.dart';

sealed class GroupchatState extends Equatable {
  const GroupchatState();

  @override
  List<Object> get props => [];
}

final class GroupchatInitial extends GroupchatState {}
final class CreateGroupChatLoading extends GroupchatState {}

final class ChatRoomLoading extends GroupchatState {}
class ChatRoomCreated extends GroupchatState {
  final ChatRoom chatRoom;
  const ChatRoomCreated(this.chatRoom);
  @override
  List<Object> get props => [chatRoom];
}

class ChatRoomsLoaded extends GroupchatState {
  final List<ChatRoom> chatRooms;

  const ChatRoomsLoaded(this.chatRooms);

  @override
  List<Object> get props => [chatRooms];
}

class ChatRoomSelected extends GroupchatState {
  final ChatRoom chatRoom;

  const ChatRoomSelected(this.chatRoom);

  @override
  List<Object> get props => [chatRoom];
}
final class ChatRoomLoadFailure extends GroupchatState {
  final String error;

  const ChatRoomLoadFailure(this.error);
  @override
  List<Object> get props => [error];

}
class CreateChatRoomFailure extends GroupchatState {
  final String error;

  const CreateChatRoomFailure(this.error);

  @override
  List<Object> get props => [error];
}
final class GroupchatDeleteSuccess extends GroupchatState {}
final class GroupchatDeleteFailure extends GroupchatState {
  final String error;
  const GroupchatDeleteFailure(this.error);
  @override
  List<Object> get props => [error];
}
final class GroupChatSelectError extends GroupchatState {
  final String  error;

  const GroupChatSelectError(this.error);

  @override
  List<Object> get props => [error];
}
final class MembersAdding extends GroupchatState {}

final class AddMembersSuccess extends GroupchatState {}
final class AddMembersFailure extends GroupchatState {
  final String error;

  const AddMembersFailure(this.error);
  @override
  List<Object> get props => [error];
  
}
final class MembersRemoving extends GroupchatState {}
final class RemoveMembersSuccess extends GroupchatState {}