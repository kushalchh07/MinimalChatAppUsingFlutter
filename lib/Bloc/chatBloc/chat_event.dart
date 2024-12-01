import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SendMessage extends ChatEvent {
  final String message;
  final String userId;

  SendMessage(this.message, this.userId);

  @override
  List<Object> get props => [message, userId];
}

class LoadMessages extends ChatEvent {}

class ImagePickedEvent extends ChatEvent {}

class ImageSendEvent extends ChatEvent {

final File image;
String userId;
ImageSendEvent(this.image, this.userId);
}
class ImageCancelEvent extends ChatEvent{}
class FetchChatEvent extends ChatEvent{}