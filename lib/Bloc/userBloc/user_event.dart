import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadUsers extends UserEvent {}

class LoadBlockedUsers extends UserEvent {}

class UnBlockUserEvent extends UserEvent {
  String blockedUserId;

  UnBlockUserEvent(this.blockedUserId);
}

class BlockUserEvent extends UserEvent {
  String blockedUserId;
  BlockUserEvent(this.blockedUserId);
}

class LoadMyProfile extends UserEvent {
  final String userId;

  LoadMyProfile(this.userId);
}
