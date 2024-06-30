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

class UsersError extends UserState {}
