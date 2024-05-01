import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  //creating instance of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//sign user in
  Future<UserCredential> signInWithEmailandPassword(
      String email, String password) async {
    try {
      //sign in
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    }
    //catching error
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

//create a user
  Future<UserCredential> signUpWithEmailandPassword(
      String email, String password) async {
    try {
      //sign in
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    }
    //catching error
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //signUserOut
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
