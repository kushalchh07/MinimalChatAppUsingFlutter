import 'package:chat_app/Bloc/userBloc/user_bloc.dart';
import 'package:chat_app/Bloc/userBloc/user_event.dart';
import 'package:chat_app/constants/colors/colors.dart';
import 'package:chat_app/pages/Login&signUp/sign_uppage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Bloc/userBloc/user_state.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

TextEditingController fullNameController = TextEditingController();
TextEditingController emailController = TextEditingController();

class _UserProfileState extends State<UserProfile> {
  getUser() {
    BlocProvider.of<UserBloc>(context)
        .add(LoadMyProfile(FirebaseAuth.instance.currentUser!.uid));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // child: Text("Work In progress"),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
          child: BlocConsumer<UserBloc, UserState>(
            listener: (context, state) {
              // TODO: implement listener
              if (state is UpdateProfileSuccess) {
                Fluttertoast.showToast(
                    msg: "Profile Updated",
                    gravity: ToastGravity.BOTTOM,
                    toastLength: Toast.LENGTH_SHORT,
                    backgroundColor: successColor);
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              if (state is LoadMyProfileLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is MyProfileLoaded) {
                fullNameController.text = state.myprofile['name'];
                emailController.text = state.myprofile['email'];
                return Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      cursorColor: greenColor,
                      controller: fullNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Name';
                        }
                        if (value.length < 10) {
                          return 'Please enter valid Name';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        floatingLabelStyle: floatingLabelTextStyle(),
                        prefixIcon: Icon(
                          Icons.person,
                          color: greyColor,
                        ),
                        focusedBorder: customFocusBorder(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                        labelStyle: TextStyle(color: greyColor, fontSize: 13),
                        hintText: 'Name',
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      onTap: () {
                        Fluttertoast.showToast(msg: "Email Can't be changed");
                      },
                      enabled: false,
                      cursorColor: greenColor,
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Email';
                        }
                        if (value.length < 10) {
                          return 'Please enter valid Email';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        floatingLabelStyle: floatingLabelTextStyle(),
                        prefixIcon: Icon(
                          Icons.email,
                          color: greyColor,
                        ),
                        focusedBorder: customFocusBorder(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                        labelStyle: TextStyle(color: greyColor, fontSize: 13),
                        hintText: 'Email',
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenColor,
                        shape: StadiumBorder(),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        minimumSize: Size(200, 40),
                        maximumSize: Size(200, 40),
                        elevation: 0,
                        textStyle: TextStyle(color: Colors.white),
                        side: BorderSide(color: greenColor),
                      ),
                      onPressed: () {
                        BlocProvider.of<UserBloc>(context)
                            .add(UpdateProfile(fname: fullNameController.text));
                      },
                      child: Text(
                        'Update Profile ',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              } else {
                return CupertinoActivityIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
