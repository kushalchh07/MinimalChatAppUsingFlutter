import 'package:chat_app/pages/SplashScreen&onBoard/get_started.dart';
import 'package:chat_app/pages/Chat/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //if user is logged in
          if (snapshot.hasData) {
            return ChatScreen();
          }
          //if user is not logged in
          else {
            return GetStart();
          }
        },
      ),
    );
  }
}
