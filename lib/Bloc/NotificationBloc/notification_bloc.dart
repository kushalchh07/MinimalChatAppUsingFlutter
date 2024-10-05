import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
       on<LoadNotifications>(_loadNotifications);
       on<SendNotification>(_sendNotification);
  }

  FutureOr<void> _loadNotifications(LoadNotifications event, Emitter<NotificationState> emit) {
  }

  FutureOr<void> _sendNotification(SendNotification event, Emitter<NotificationState> emit) {
    

  }
}
