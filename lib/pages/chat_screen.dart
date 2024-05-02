import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //create a instance of firebaseauth

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ChatRoom',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: IconButton(onPressed: signOut, icon: Icon(Icons.logout)),
      ),
      body: _buildUserList(),
    );
  }
  //build a list of users except for the current logged in user

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }
          return ListView(
            children: snapshot.data!.docs
                .map<Widget>((doc) => _buildUserListItem(doc))
                .toList(),
          );
        });
  }

  //build individual user list items

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    //display all userrs except current user

    if (_firebaseAuth.currentUser!.email != data['email']) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ListTile(
          leading: Icon(Icons.account_circle),
          title: Text(
            data['email'],
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatPage(
                        receiverUserEmail: data['email'],
                        receiverUserId: data['uid'])));
          },

          contentPadding: EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 8.0), // Padding around the content
          dense: true, // Make the tile smaller
          selected: true, // Indicate selection state
          selectedTileColor:
              Colors.blue.withOpacity(0.5), // Color when selected

          tileColor: Colors.grey[200], // Background color of the tile
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3), // Border radius of the tile
            side: BorderSide(color: Colors.black), // Border side of the tile
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
