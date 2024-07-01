import 'package:equatable/equatable.dart';

abstract class ChatState extends Equatable {
  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class MessageSent extends ChatState {}

class MessageFailure extends ChatState {
  final String error;

  MessageFailure(this.error);

  @override
  List<Object> get props => [error];
}

class MessagesLoaded extends ChatState {
  final List<Map<String, dynamic>> messages;

  MessagesLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}
