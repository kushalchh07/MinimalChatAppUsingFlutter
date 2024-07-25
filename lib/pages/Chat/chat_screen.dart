import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/constants/colors/colors.dart';
import 'package:chat_app/constants/constants.dart';
import 'package:chat_app/pages/Chat/chat_page.dart';
import 'package:chat_app/pages/Login&signUp/sign_inpage.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/chat_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Bloc/userBloc/user_bloc.dart';
import '../../Bloc/userBloc/user_event.dart';
import '../../Bloc/userBloc/user_state.dart';
import '../../constants/Sharedpreferences/sharedpreferences.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

dynamic imageUrl;

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void signOut() {
    AuthService.logout();
    clearData();
    saveStatus(false);
    Get.offAll(() => SignIn());
  }

  Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('name') ?? 'N/A';
  }

  String getFirstName(String fullName) {
    if (fullName.isEmpty) {
      return 'N/A';
    }
    return fullName.split(' ')[0];
  }

  Future<Map<String, String?>> getProfileInfo() async {
    final fullName = await getName();
    final email = await getEmail();
    final imageUrl = await getImage();

    return {'fullName': fullName, 'email': email, 'imageUrl': imageUrl};
  }

  Future<void> getImageUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _imageUrl = prefs.getString('imageUrl') ?? 'N/A';
    setState(() {
      imageUrl = _imageUrl;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImageUrl();
  }

  @override
  Widget build(BuildContext context) {
    final currentTime = TimeOfDay.now();
    String greeting = '';
    if (currentTime.hour < 12) {
      greeting = 'Good Morning!';
    } else if (currentTime.hour < 18) {
      greeting = 'Good Afternoon!';
    } else {
      greeting = 'Good Evening!';
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        leading: FutureBuilder<Map<String, String?>>(
            future: getProfileInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Icon(Icons.error);
              } else {
                final profileInfo = snapshot.data!;

                final fullName = profileInfo['fullName'] ?? 'Unknown';
                final email = profileInfo['email'] ?? 'Unknown';
                final imageUrl = profileInfo['imageUrl'] ?? '';
                return Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.transparent,
                      // width: 2,
                    ),
                  ),
                  child: imageUrl.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            // height: 60,
                            // width: 60,
                            decoration: BoxDecoration(
                                color: primaryColor, shape: BoxShape.circle),
                            child: Center(
                              child: Text(
                                getFirstandLastNameInitals(
                                    fullName.toUpperCase()),
                                style:
                                    TextStyle(color: whiteColor, fontSize: 20),
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: CachedNetworkImage(
                            imageBuilder: (context, imageProvider) {
                              return Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                            imageUrl: imageUrl,
                            placeholder: (context, url) => Image.asset(
                              'assets/images/no-image.png',
                              fit: BoxFit.cover,
                              height: 40,
                              width: 40,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/no-image.png',
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                );
              }
            }),
        actions: [
          Image.asset(
            "assets/images/chat.png",
            height: 60,
          ),
        ],
        title: FutureBuilder<String>(
          future: getName(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error');
            } else {
              String fullName = snapshot.data ?? 'N/A';
              String firstName = getFirstName(fullName).toUpperCase();
              return Padding(
                padding: const EdgeInsets.only(top: 1, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      firstName == 'N/A' ? 'N/A' : 'Hi $firstName,',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: myBlack,
                      ),
                    ),
                    // const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        greeting,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: myBlack,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
        backgroundColor: appBackgroundColor,
        elevation: 0.2,
        leadingWidth: 70,
        titleSpacing: 0,
      ),
      body: BlocProvider(
        create: (context) => UserBloc(ChatService())..add(LoadUsers()),
        child: Container(
          color: appBackgroundColor,
          child: UserList(),
        ),
      ),
    );
  }
}

class UserList extends StatefulWidget {
  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserBlockedActionState) {
          if (state.isBlocked) {
            Fluttertoast.showToast(
                msg: "User Blocked",
                gravity: ToastGravity.BOTTOM,
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: successColor);
          } else {
            Fluttertoast.showToast(
                msg: "Failed to Block",
                gravity: ToastGravity.BOTTOM,
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: successColor);
          }
        }
      },
      builder: (context, state) {
        if (state is UsersLoading) {
          return Center(child: CupertinoActivityIndicator());
        } else if (state is UsersLoaded) {
          final users = state.users;
          log(users.toString());
          if (users.isEmpty) {
            return Center(child: Text('No users found'));
          }
          return Padding(
              padding: const EdgeInsets.only(left: 2, right: 2),
              child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return _buildUserListItem(context, users[index]);
                  }));
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
      padding: const EdgeInsets.only(top: 8.0, right: 4, left: 4),
      child: GestureDetector(
        onLongPress: () {
          _showOptions(context, user['uid']);
        },
        child: Container(
          decoration: BoxDecoration(
            color: appSecondary,

            // border: Border.all(color: Colors.black), // Border color
            borderRadius: BorderRadius.circular(5.0),
            // Border radius
          ),
          child: ListTile(
            minLeadingWidth: Checkbox.width,
            leading: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.transparent,
                  // width: 2,
                ),
              ),
              child: user['profileImageUrl'].isEmpty
                  ? Container(
                      // height: 60,
                      // width: 60,
                      decoration: BoxDecoration(
                          color: primaryColor, shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          getFirstandLastNameInitals(
                              user['name'].toUpperCase()),
                          style: TextStyle(color: whiteColor, fontSize: 20),
                        ),
                      ),
                    )
                  : CachedNetworkImage(
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                      imageUrl: user['profileImageUrl'],
                      placeholder: (context, url) => Image.asset(
                        'assets/images/no-image.png',
                        fit: BoxFit.cover,
                        height: 60,
                        width: 60,
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/no-image.png',
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                      fit: BoxFit.cover,
                    ),
            ),
            title: Text(
              user['name'] ?? 'No name',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    receiverUserEmail: user['name'],
                    receiverUserId: user['uid'],
                    receiverimageUrl: user['profileImageUrl'],
                    senderImageUrl: imageUrl,
                  ),
                ),
              );
            },
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            dense: true,
            selected: true,
            selectedTileColor: Colors.blue.withOpacity(0.5),
            tileColor: Colors.grey[200],
          ),
        ),
      ),
    );
  }

  void _showOptions(BuildContext context, String userId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text("Report"),
                onTap: () {
                  Navigator.pop(context);
                  // Add reporting logic here
                },
              ),
              ListTile(
                leading: const Icon(Icons.block),
                title: const Text("Block User"),
                onTap: () {
                  Navigator.pop(context);
                  _blockUser(context, userId);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text("Cancel"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _blockUser(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Are you sure you want to block this user?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Block'),
              onPressed: () {
                BlocProvider.of<UserBloc>(context).add(BlockUserEvent(userId));
                BlocProvider.of<UserBloc>(context).add(LoadUsers());
                log("LoadUsers Added Hai");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
