import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  //creating instance of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
//sign user in
  Future<UserCredential> signInWithEmailandPassword(
      String email, String password) async {
    try {
      //sign in
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
//add a new document for the user in users collection if it doesnot already exists.
      _firebaseFirestore.collection('users').doc(userCredential.user!.uid).set(
          {'uid': userCredential.user!.uid, 'email': email},
          SetOptions(merge: true));

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

      //after creating the user , create a new document for the user in theusers collection
      _firebaseFirestore.collection('users').doc(userCredential.user!.uid).set(
        {'uid': userCredential.user!.uid, 'email': email},
      );
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
