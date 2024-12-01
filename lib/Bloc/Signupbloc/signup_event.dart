part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent {}

class SignupTappedEvent extends SignupEvent {
  dynamic email;
  dynamic password;
  dynamic fname;
  dynamic contact;
  // dynamic lname;
  SignupTappedEvent(
      {required this.email,
      required this.password,
      required this.fname,
      required this.contact});
}

class CheckEmailVerificationEvent extends SignupEvent {}
class ResendEmailVerificationEvent extends SignupEvent {}
