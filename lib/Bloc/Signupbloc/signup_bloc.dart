// ignore_for_file: empty_catches

import 'dart:async';
import 'dart:developer';
// import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:chat_app/pages/Login&signUp/email_verification_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:meta/meta.dart';

import '../../../constants/colors/colors.dart';
import '../../constants/Sharedpreferences/sharedpreferences.dart';
import '../../services/auth_services.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitial()) {
    on<SignupTappedEvent>(_signupTappedEvent);
    on<CheckEmailVerificationEvent>(_checkEmailVerification);
    on<ResendEmailVerificationEvent>(_resendEmailVerification);
  }

  FutureOr<void> _signupTappedEvent(
      SignupTappedEvent event, Emitter<SignupState> emit) async {
    log("Signup Tapped");
    try {
      final email = event.email;
      final password = event.password;
      final fname = event.fname;
      final contact = event.contact;

      // emit(SignupLoadingState());
      // log("Signup loading");

      // await Future.delayed(Duration(seconds: 1));
      // await AuthService.createAccountWithEmail(email, password);

      await AuthService.createAccountWithEmail(email, password).then((value) {
        if (value == "Account Created") {
          saveName(fname);
          saveEmail(email);
          saveContact(contact);
          
          AuthService.verifyEmail();
          emit(EmailSentState());
          log("Email Verification Sent");
          Get.offAll(() => VerifyEmailPage());
          // Get.to(() => Base());
          Fluttertoast.showToast(
            msg: 'Verification Email Sent Sucessfully',
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
        }
      });

      // log("Account Created");

      // emit(SignupSuccessState());
      // log("Signup Successfull");
    } on FirebaseAuthException catch (e) {
      // return e.message.toString();
      log("$e");
    } catch (e) {
      log("Error occured during signup $e");
    }
  }

  FutureOr<void> _checkEmailVerification(
      CheckEmailVerificationEvent event, Emitter<SignupState> emit) async {
    emit(SignupLoadingState());

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      if (user.emailVerified) {
        log("Email Verified ");
        Fluttertoast.showToast(
          msg: 'SignUp SuccessFully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: whiteColor,
        );
        saveStatus(true);
        emit(SignupSuccessState());
      } else {
        emit(SignupErrorState(error: "Email Not Verified"));
      }
    } else {
      emit(SignupErrorState(error: "User NotFound "));
    }
  }

  FutureOr<void> _resendEmailVerification(
      ResendEmailVerificationEvent event, Emitter<SignupState> emit) {
    AuthService.verifyEmail();
    Fluttertoast.showToast(
      msg: 'Verification Email Sent Sucessfully',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: whiteColor,
    );
  }
}
