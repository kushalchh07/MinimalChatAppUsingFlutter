import 'package:chat_app/constants/colors/colors.dart';
import 'package:chat_app/pages/Chat/chat_page.dart';
import 'package:chat_app/pages/Login&signUp/sign_inpage.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../Bloc/userBloc/user_bloc.dart';
import '../../Bloc/userBloc/user_event.dart';
import '../../Bloc/userBloc/user_state.dart';
import '../../constants/Sharedpreferences/sharedpreferences.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void signOut() {
    AuthService.logout();
    saveStatus(false);
    Get.offAll(() => SignIn());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ChatRoom',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: appBackgroundColor,
      ),
      drawer: Drawer(
        child: IconButton(onPressed: signOut, icon: Icon(Icons.logout)),
      ),
      body: BlocProvider(
        create: (context) => UserBloc()..add(LoadUsers()),
        child: UserList(),
      ),
    );
  }
}

class UserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UsersLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is UsersLoaded) {
          final users = state.users;
          if (users.isEmpty) {
            return Center(child: Text('No users found'));
          }
          return ListView(
            children: users
                .where((user) => user['email'] != FirebaseAuth.instance.currentUser?.email)
                .map((user) => _buildUserListItem(context, user))
                .toList(),
          );
        } else if (state is UsersError) {
          return Center(child: Text('Failed to load users'));
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildUserListItem(BuildContext context, Map<String, dynamic> user) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ListTile(
        leading: Icon(Icons.account_circle),
        title: Text(
          user['email'] ?? 'No email',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverUserEmail: user['email'],
                receiverUserId: user['uid'],
              ),
            ),
          );
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        dense: true,
        selected: true,
        selectedTileColor: Colors.blue.withOpacity(0.5),
        tileColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
          side: BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}
