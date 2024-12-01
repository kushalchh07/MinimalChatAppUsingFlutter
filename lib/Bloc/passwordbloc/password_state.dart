part of 'password_bloc.dart';

sealed class PasswordState extends Equatable {
  const PasswordState();
  
  @override
  List<Object> get props => [];
}

final class PasswordInitial extends PasswordState {}
class PasswordChangedState extends PasswordState {}

class PasswordError extends PasswordState {
  final String error;
  PasswordError(this.error);
}
class PasswordChangingState extends PasswordState {}