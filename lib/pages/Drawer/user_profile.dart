import 'package:chat_app/constants/colors/colors.dart';
import 'package:chat_app/pages/Login&signUp/sign_uppage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

TextEditingController fullNameController = TextEditingController();
TextEditingController emailController = TextEditingController();

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
          child: Column(
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
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  minimumSize: Size(200, 40),
                  maximumSize: Size(200, 40),
                  elevation: 0,
                  textStyle: TextStyle(color: Colors.white),
                  side: BorderSide(color: greenColor),
                ),
                onPressed: () {},
                child: Text(
                  'Update Profile ',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
