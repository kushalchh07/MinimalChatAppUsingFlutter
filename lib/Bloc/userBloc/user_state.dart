import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  @override
  List<Object> get props => [];
}

class UsersLoading extends UserState {}

class UsersLoaded extends UserState {
  final List<Map<String, dynamic>> users;

  UsersLoaded(this.users);

  @override
  List<Object> get props => [users];
}
class BlockedUsersLoaded extends UserState {
  final List<Map<String, dynamic>> blockedusers;

  BlockedUsersLoaded(this.blockedusers);

  @override
  List<Object> get props => [blockedusers];
}

class MyProfileLoaded extends UserState {
  final Map<String, dynamic> myprofile;

  MyProfileLoaded(this.myprofile);
}
class UsersError extends UserState {}
class UserBlockedActionState extends UserState{
  final bool isBlocked;

  UserBlockedActionState(this.isBlocked);
}
class UpdateProfileSuccess extends UserState{}
class DeleteProfileSuccess extends UserState{}
class DeleteProfileFailed extends UserState{}