import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadUsers extends UserEvent {}

class LoadAllUsers extends UserEvent {}

class LoadBlockedUsers extends UserEvent {}
class LoadMembers extends UserEvent {
  String chatRoomId;
  LoadMembers(this.chatRoomId);
}
class LoadAddMembersUser extends UserEvent {
  String chatRoomId;
  LoadAddMembersUser(this.chatRoomId);  
}

class UnBlockUserEvent extends UserEvent {
  String blockedUserId;

  UnBlockUserEvent(this.blockedUserId);
}

class BlockUserEvent extends UserEvent {
  String blockedUserId;
  BlockUserEvent(this.blockedUserId);
}

class LoadMyProfileLoading extends UserEvent {}

class LoadMyProfile extends UserEvent {
  final String userId;

  LoadMyProfile(this.userId);
}

class LoadMyProfileError extends UserEvent {}

class UpdateProfile extends UserEvent {
  String fname;
  // String lname;
  // String email;
  // String phone;
  UpdateProfile({
    required this.fname,
    // required this.lname,
    // required this.email,
    // required this.phone,
  });
}

class DeleteMyProfileWithEmail extends UserEvent {
  String password;

  DeleteMyProfileWithEmail(this.password);
}

class DeleteMyProfileWithGoogle extends UserEvent {}

class SearchUsers extends UserEvent {
  final String query;

  SearchUsers(this.query);
}
// class LoadRequestedUsers extends UserEvent{

// }
