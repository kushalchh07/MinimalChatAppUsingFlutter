// ignore_for_file: empty_catches

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat_app/pages/Chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../../../constants/colors/colors.dart';
import '../../constants/colors/Sharedpreferences/sharedpreferences.dart';
import '../../services/auth_services.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<LoginTappedEvent>(_loginTappedEvent);
    on<GoogleLoginTappedEvent>(_googleLoginTappedEvent);
  }

  FutureOr<void> _loginTappedEvent(
      LoginTappedEvent event, Emitter<LoginState> emit) async {
    final email = event.email;
    final password = event.password;
    try {
      emit(LoginLoadingState());
      // await Future.delayed(Duration(seconds: 2));
      if (email == "" || password == "") {
        Fluttertoast.showToast(
          msg: 'Email or Password cannot be empty',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: whiteColor,
        );
        emit(LoginError("Email or Password cannot be empty"));
        return;
      }
      // AuthService.loginWithEmail(email, password);
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        if (value.user != null) {
          log(value.toString());
          saveStatus(true);
          Get.offAll(() => ChatScreen());
          Fluttertoast.showToast(
            msg: 'Login Sucessfully',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: whiteColor,
          );
        } else {
          Fluttertoast.showToast(
            msg: 'Invalid email or password',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: whiteColor,
          );
          emit(LoginError("Credentials are not valid"));
        }
      });

      emit(LoginSuccessfullState());
      log("Loggeded in ");
    } catch (e) {
      log("Error occured during login $e");

      emit(LoginError(e.toString()));
    }
  }

  FutureOr<void> _googleLoginTappedEvent(
      GoogleLoginTappedEvent event, Emitter<LoginState> emit) async {
    try {
      emit(LoginLoadingState());
      await AuthService.googleLogin().then((value) {
        if (value == "logged in") {
          log(value.toString());
          saveStatus(true);
          Get.offAll(() => ChatScreen());
          Fluttertoast.showToast(
            msg: 'Login Sucessfully',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: whiteColor,
          );
        } else {
          Fluttertoast.showToast(
            msg: 'Couldnot Login Using Google',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: whiteColor,
          );
        }
      });
    } catch (e) {
      log("Error occured during login $e");

      emit(LoginError(e.toString()));
    }
    emit(LoginSuccessfullState());
  }
}
