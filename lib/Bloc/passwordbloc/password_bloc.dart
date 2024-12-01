import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constants/colors/colors.dart';

part 'password_event.dart';
part 'password_state.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  PasswordBloc() : super(PasswordInitial()) {
    on<PasswordChanged>(_passwordChanged);
  }

  FutureOr<void> _passwordChanged(
      PasswordChanged event, Emitter<PasswordState> emit) async {
    emit(PasswordChangingState());
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && user.email != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: event.currentPassword,
        );
        await user!.reauthenticateWithCredential(credential);
        await user.updatePassword(event.password);
        Fluttertoast.showToast(
            msg: "Password changed successfully.",
            backgroundColor: successColor);
        print('Password updated');
      }
    } catch (e) {
      print(e);
    }
  }
}
