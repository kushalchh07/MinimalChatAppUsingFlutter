part of 'password_bloc.dart';

sealed class PasswordEvent extends Equatable {
  const PasswordEvent();

  @override
  List<Object> get props => [];
}

class PasswordChanged extends PasswordEvent {
  final String currentPassword;
  final String password;
  const PasswordChanged(this.password, this.currentPassword);
}
