// ignore_for_file: empty_catches

import 'dart:developer';

import 'package:chat_app/constants/Sharedpreferences/sharedpreferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//creating new account
  static Future<String> createAccountWithEmail(
      String email, String password) async {
    log("Signup Tapped");
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final name = await getName();
      log(name.toString());
      log(userCredential.user!.uid);
      FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
          'name': name,
          'profileImageUrl': ''
        },
      );

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
  Future<String> loginWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      log(userCredential.toString());
      String uid = userCredential.user!.uid;

      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        String? name = userDoc.data()?['name'];
        String imageUrl = userDoc.data()?['profileImageUrl'];
        log(name.toString());
        if (name != null) {
          // Store the user's name in SharedPreferences
          saveName(name);
          saveImage(imageUrl);
          return "logged";
        }
      }
      return "logged";
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
      saveEmail(userCredential.user!.email.toString());
      saveName(userCredential.user!.displayName.toString());
      log(userCredential.user!.displayName.toString());
      FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .set(
        {
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email,
          'name': userCredential.user!.displayName,
          'profileImageUrl': ''
        },
      );
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
  Future<Map<String, dynamic>> getUserDataFromFirebase(String userId) async {
    Map<String, dynamic> userData = {};

    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      userData = userSnapshot.data() as Map<String, dynamic>;
    }

    return userData;
  }
}
