// ignore_for_file: empty_catches

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
//creating new account
  static Future<String> createAccountWithEmail(
      String email, String password) async {
    log("Signup Tapped");
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return "Account Created";

      // return user;
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
    // log("Signup Tapped");
  }

  //Logging In with Email and password
  static Future<String> loginWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return "Logged";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

// for logging user out
  static Future logout() async {
    await FirebaseAuth.instance.signOut();
  }
// checking user is logged in or not

  static Future<bool> isLoggedIn() async {
    var user = FirebaseAuth.instance.currentUser;
    return user != null; // returns boolean value true if user is logged in
  }

  static Future<String> getCurrentUser() async {
    var user = FirebaseAuth.instance.currentUser;
    return user.toString();
  }

  static Future<String> resetPassword(String email) {
    return FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((_) => "Password reset email sent");
  }

  static Future<String> googleLogin() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      log("userCredential ${userCredential.toString()}");

      return "logged in";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String> verifyEmail() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await user!.sendEmailVerification();
      return "Verification email sent";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }
  // static Future<String> facebookLogin() async {
  //   try {
  //     final LoginResult result = await FacebookAuth.instance.login();

  //     if (result.status == LoginStatus.success) {
  //       final userData = await FacebookAuth.instance.getUserData();
  //       log("userData ${userData.toString()}");
  //       return "logged in";
  //     } else {
  //       return "failed";
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     return e.message.toString();
  //   } catch (e) {
  //     return e.toString();
  //   }
  // }
}
