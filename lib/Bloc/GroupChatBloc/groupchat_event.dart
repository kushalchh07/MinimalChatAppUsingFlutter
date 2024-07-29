part of 'groupchat_bloc.dart';

sealed class GroupchatEvent extends Equatable {
  const GroupchatEvent();

  @override
  List<Object> get props => [];
}
class GroupChatAddedEvent extends GroupchatEvent{
// final List<String> members;
//   GroupChatAddedEvent({required this.members});
}
class GroupChatLoadEvent extends GroupchatEvent{
  
}
class GroupChatDeleteEvent extends GroupchatEvent{
  
}
