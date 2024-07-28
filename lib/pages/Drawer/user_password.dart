// ignore_for_file: avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:chat_app/Bloc/loginbloc/login_bloc.dart';
import 'package:chat_app/Bloc/passwordbloc/password_bloc.dart';
import 'package:chat_app/constants/colors/colors.dart';
import 'package:chat_app/pages/Login&signUp/sign_uppage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class UserPassword extends StatefulWidget {
  const UserPassword({super.key});

  @override
  State<UserPassword> createState() => _UserPasswordState();
}

final TextEditingController _oldPasswordController = TextEditingController();
bool _showPassword = false;
final TextEditingController _newPasswordController = TextEditingController();
final TextEditingController _conPasswordController = TextEditingController();

class _UserPasswordState extends State<UserPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
        centerTitle: true,
        backgroundColor: appBackgroundColor,
      ),
      backgroundColor: appBackgroundColor,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 6,
              ),
              TextFormField(
                cursorColor: greenColor,
                controller: _oldPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 10) {
                    return 'Please enter valid password';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                obscureText: !_showPassword,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  floatingLabelStyle: floatingLabelTextStyle(),
                  prefixIcon: Icon(
                    Icons.password,
                    color: greyColor,
                  ),
                  focusedBorder: customFocusBorder(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                  labelStyle: TextStyle(color: greyColor, fontSize: 13),
                  hintText: 'Current Password',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                    icon: (_showPassword)
                        ? Icon(
                            Icons.visibility,
                            color: greyColor,
                          )
                        : Icon(
                            Icons.visibility_off,
                            color: greyColor,
                          ),
                  ),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              TextFormField(
                cursorColor: greenColor,
                controller: _newPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 10) {
                    return 'Please enter valid password';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                obscureText: !_showPassword,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  floatingLabelStyle: floatingLabelTextStyle(),
                  prefixIcon: Icon(
                    Icons.password,
                    color: greyColor,
                  ),
                  focusedBorder: customFocusBorder(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                  labelStyle: TextStyle(color: greyColor, fontSize: 13),
                  hintText: 'New Password',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                    icon: (_showPassword)
                        ? Icon(
                            Icons.visibility,
                            color: greyColor,
                          )
                        : Icon(
                            Icons.visibility_off,
                            color: greyColor,
                          ),
                  ),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              TextFormField(
                cursorColor: greenColor,
                controller: _conPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 10) {
                    return 'Please enter valid password';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                obscureText: !_showPassword,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  floatingLabelStyle: floatingLabelTextStyle(),
                  prefixIcon: Icon(
                    Icons.password,
                    color: greyColor,
                  ),
                  focusedBorder: customFocusBorder(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                  labelStyle: TextStyle(color: greyColor, fontSize: 13),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                    icon: (_showPassword)
                        ? Icon(
                            Icons.visibility,
                            color: greyColor,
                          )
                        : Icon(
                            Icons.visibility_off,
                            color: greyColor,
                          ),
                  ),
                  hintText: 'Confirm New Password',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: BlocBuilder<PasswordBloc, PasswordState>(
                  builder: (context, state) {
                    if (state is PasswordChangingState) {
                      return const SizedBox(
                          height: 50,
                          width: 50,
                          child: CupertinoActivityIndicator());
                    }

                    return SizedBox(
                      height: 45,
                      width: 300,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        color: greenColor,
                        onPressed: changePassword,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Update Password',
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  color: whiteColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void changePassword() {
    if (_newPasswordController.text == _conPasswordController.text) {
      log("Password Changed");
      BlocProvider.of<PasswordBloc>(context).add(PasswordChanged(
          _newPasswordController.text, _oldPasswordController.text));
      clearControllers();
    } else {
      Fluttertoast.showToast(
          msg: "Both passwords must be same.", backgroundColor: errorColor);
    }
  }

  void clearControllers() {
    _conPasswordController.clear();
    _newPasswordController.clear();
    _oldPasswordController.clear();
  }
}
