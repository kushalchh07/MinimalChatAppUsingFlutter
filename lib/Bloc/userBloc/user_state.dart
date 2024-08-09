import 'package:chat_app/model/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserState extends Equatable {
  @override
  List<Object> get props => [];
}

class UsersInitial extends UserState {}

class UsersLoading extends UserState {}

class UsersLoaded extends UserState {
  final List<Map<String, dynamic>> users;

  UsersLoaded(this.users);

  @override
  List<Object> get props => [users];
}
class UserLoadFailure extends UserState {}
class AllUsersLoaded extends UserState {
  final List<Map<String, dynamic>> users;

  AllUsersLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class BlockedUsersLoaded extends UserState {
  final List<Map<String, dynamic>> blockedusers;

  BlockedUsersLoaded(this.blockedusers);

  @override
  List<Object> get props => [blockedusers];
}
class AddMembersUsersLoaded extends UserState {
  final List<Map<String, dynamic>> addMembersUsers;

  AddMembersUsersLoaded(this.addMembersUsers);  
}
class AddMembersUsersLoading extends UserState {}
// class RequestedUsersLoaded extends UserState {
//   final List<Map<String, dynamic>> requestedUsers;

//   RequestedUsersLoaded(this.requestedUsers);

//   @override
//   List<Object> get props => [requestedUsers];
// }

class MyProfileLoaded extends UserState {
  final Map<String, dynamic> myprofile;

  MyProfileLoaded(this.myprofile);
}

class UsersError extends UserState {}

class UserBlockedActionState extends UserState {
  final bool isBlocked;

  UserBlockedActionState(this.isBlocked);
}

class UpdateProfileSuccess extends UserState {}

class DeleteProfileSuccess extends UserState {}

class DeleteProfileFailed extends UserState {}

class UserUnblockedState extends UserState {}

class UsersSearchLoaded extends UserState {
  final List<UserModel> users;

  UsersSearchLoaded(this.users);
}
