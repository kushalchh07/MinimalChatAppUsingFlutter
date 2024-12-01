part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessfullState extends LoginState {}

class LoginError extends LoginState {
  final String error;
  LoginError(this.error);
}

class LoginFailureState extends LoginState {
  String message;
  LoginFailureState({required this.message});
}
