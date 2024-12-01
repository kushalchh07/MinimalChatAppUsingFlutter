part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class LoadNotifications extends NotificationEvent {}

class SendNotification extends NotificationEvent {
  final String title;
  final String body;
  final String receiverUserId;

  SendNotification({
    required this.title,
    required this.body,
    required this.receiverUserId,
  });
}
