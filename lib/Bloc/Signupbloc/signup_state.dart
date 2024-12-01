part of 'signup_bloc.dart';

@immutable
sealed class SignupState {}

final class SignupInitial extends SignupState {}
final class SignupLoadingState extends SignupState {}
final class EmailSentState extends SignupState {}
final class SignupSuccessState extends SignupState {
  // final dynamic success;
  // final dynamic userId;
  // List<LoginModel> registerResponse;
  // SignupSuccessState({
  //   // required this.success,
  //   // required this.userId,
  //   // required this.registerResponse,
  // });
}

final class SignupErrorState extends SignupState {
  final String error;

  SignupErrorState({
    required this.error,
  });
}


