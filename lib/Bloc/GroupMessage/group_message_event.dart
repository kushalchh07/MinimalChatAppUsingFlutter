part of 'group_message_bloc.dart';

sealed class GroupMessageEvent extends Equatable {
  const GroupMessageEvent();

  @override
  List<Object> get props => [];
}
class LoadGroupMessageEvent extends GroupMessageEvent{}
class SendGroupMessageEvent extends GroupMessageEvent{
  final String groupId;
  final String message;
  final String senderId;
  final String senderName;
  final String senderImage;
  final String time;
  final String type;
  final String isImage;
  SendGroupMessageEvent({
    required this.groupId,
    required this.message,
    required this.senderId,
    required this.senderName,
    required this.senderImage,
    required this.time,
    required this.type,
    required this.isImage,
  });
}
