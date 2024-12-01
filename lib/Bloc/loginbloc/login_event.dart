part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginInitialEvent extends LoginEvent {}

class LoginTappedEvent extends LoginEvent {
  dynamic email;
  dynamic password;

  LoginTappedEvent({required this.email, required this.password});
}

class GoogleLoginTappedEvent extends LoginEvent {}
