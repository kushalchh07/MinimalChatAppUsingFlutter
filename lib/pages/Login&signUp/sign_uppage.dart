// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'dart:math';

import 'package:chat_app/constants/colors/colors.dart';
import 'package:chat_app/pages/Chat/chat_screen.dart';
import 'package:chat_app/pages/Login&signUp/email_verification_page.dart';
import 'package:chat_app/pages/Login&signUp/sign_inpage.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Bloc/Signupbloc/signup_bloc.dart';
import '../../utils/customWidgets/alert_dialog_box.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _newPassword = false;
  final fnameController = TextEditingController();
  // final lnameController = TextEditingController();
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();
  // final confirmPasswordController = TextEditingController();
  final contactController = TextEditingController();
  // final couponController = TextEditingController();
  bool registerError = true;
  bool loginError = true;
  bool agreeTerms = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  final String _text = "Let's Get Started!";
  final String _text1 = 'Here Your First Step With Us.';
  final int _durationPerLetter = 100;

  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: Text(message),
            ),
          );
        });
  }

  signup() {
    if (_formKey.currentState!.validate()) {
      (agreeTerms)
          ? BlocProvider.of<SignupBloc>(context).add(SignupTappedEvent(
              email: emailController.text.trim(),
              fname: fnameController.text.trim(),
              contact: contactController.text.trim(),
              password: newPasswordController.text.trim()))
          : customAlertBox(
              context,
              'Please make sure you accept the terms and condition before proceeding',
              '',
              () {},
              'Close',
              () {
                Navigator.pop(context);
              },
            );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: _text.length * _durationPerLetter),
      vsync: this,
    )..forward();
    _animation = Tween<double>(begin: 0, end: _text.length.toDouble())
        .animate(_controller);
  }

  @override
  void dispose() {
    super.dispose();
    fnameController.dispose();
    // lnameController.dispose();
    emailController.dispose();
    newPasswordController.dispose();

    // confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is SignupSuccessState) {
          Get.offAll(() => ChatScreen());
        }
      },
      child: registerScreen(context),
    );
  }

  registerScreen(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        // if (state is EmailSentState) {
        //   // _showSnackBar('Email Sent Sucessfully', Colors.green);
        //   Get.offAll(() => VerifyEmailPage());
        // }
      },
      child: Scaffold(
        backgroundColor: appBackgroundColor,
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              color: appBackgroundColor,
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.only(right: 30, left: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Image.asset(
                      'assets/icons/appicon.png',
                      width: 200,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedBuilder(
                              animation: _animation,
                              builder: (context, child) {
                                int currentLength = _animation.value.round();
                                String currentText = _text.substring(
                                    0, min(_text.length, currentLength));
                                return Text(
                                  currentText,
                                  style: GoogleFonts.inter(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    color: myBlack,
                                  ),
                                );
                              }),
                          AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              int currentLength = _animation.value.round();
                              String currentText1 = _text1.substring(
                                  0, min(currentLength, _text1.length));

                              return Text(
                                currentText1,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: myGrey,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 15),

                              TextFormField(
                                cursorColor: yellowColor,
                                controller: fnameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter your name';
                                  } else if (!RegExp(r'[a-zA-Z]')
                                      .hasMatch(value)) {
                                    // Checks if the value contains at least one alphabetic character
                                    return 'Name should contain at least one letter';
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                    floatingLabelStyle:
                                        floatingLabelTextStyle(),
                                    focusedBorder: customFocusBorder(),
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: greyColor,
                                    ),
                                    fillColor: appBackgroundColor,
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),

                                    // labelText: ' Enter your name',
                                    hintText: ' Enter your name ',
                                    labelText: 'Enter your name',
                                    hintStyle: TextStyle(
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w400,
                                    )),
                              ),
                              const SizedBox(height: 15),

                              TextFormField(
                                cursorColor: browncolor,
                                controller: emailController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Your Email';
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    floatingLabelStyle:
                                        floatingLabelTextStyle(),
                                    focusedBorder: customFocusBorder(),
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: greyColor,
                                    ),
                                    fillColor: appBackgroundColor,
                                    filled: true,
                                    // labelStyle: TextStyle(
                                    //     color: greyColor, fontSize: 13),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    hintText: 'Email',
                                    labelText: 'Email',
                                    hintStyle: GoogleFonts.inter(
                                        fontWeight: FontWeight.w400)),
                              ),
                              const SizedBox(height: 10),
                              //Phone Number

                              TextFormField(
                                cursorColor: greenColor,
                                controller: contactController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter contact number';
                                  }
                                  if (value.length < 10) {
                                    return 'Phone Number cannot be less than 10';
                                  }
                                  if (value.length > 10) {
                                    return 'Phone Number cannot be greater than 10';
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  floatingLabelStyle: floatingLabelTextStyle(),
                                  focusedBorder: customFocusBorder(),
                                  fillColor: appBackgroundColor,
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  // labelStyle:
                                  //     TextStyle(color: greyColor, fontSize: 13),
                                  hintText: 'Phone Number ',
                                  labelText: 'Phone Number',
                                  hintStyle: GoogleFonts.inter(
                                      fontWeight: FontWeight.w400),
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    color: greyColor,
                                  ),
                                ),
                              ),
                              //New Password
                              const SizedBox(height: 10),

                              TextFormField(
                                cursorColor: yellowColor,
                                controller: newPasswordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter new password';
                                  }
                                  if (value.length < 8) {
                                    return 'Password must contain at least 8 characters';
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.newline,
                                obscureText: !_newPassword,
                                decoration: InputDecoration(
                                  floatingLabelStyle: floatingLabelTextStyle(),
                                  focusedBorder: customFocusBorder(),
                                  fillColor: appBackgroundColor,
                                  filled: true,
                                  // labelStyle:
                                  //     TextStyle(color: greyColor, fontSize: 13),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _newPassword = !_newPassword;
                                      });
                                    },
                                    icon: (_newPassword)
                                        ? Icon(
                                            Icons.visibility,
                                            color: greyColor,
                                          )
                                        : Icon(
                                            Icons.visibility_off,
                                            color: greyColor,
                                          ),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  hintText: 'Password ',
                                  labelText: 'Password',
                                  hintStyle: GoogleFonts.inter(
                                      fontWeight: FontWeight.w400),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: greyColor,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          )),
                    ),
                    Row(
                      children: [
                        Checkbox(
                            value: agreeTerms,
                            activeColor: primaryColor,
                            onChanged: (value) {
                              setState(() {
                                agreeTerms = !agreeTerms;
                              });
                            }),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              agreeTerms = !agreeTerms;
                            });
                          },
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text: 'I accept the terms and services',
                              style: GoogleFonts.inter(
                                  color: myBlack,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14),
                            ),
                          ])),
                        ),
                      ],
                    ),
                    BlocBuilder<SignupBloc, SignupState>(
                      builder: (context, state) {
                        // if (state is SignupLoadingState) {
                        //   return const Center(
                        //     child: SizedBox(
                        //       height: 50,
                        //       width: 50,
                        //       child: CupertinoActivityIndicator(),
                        //     ),
                        //   );
                        // }
                        return Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: SizedBox(
                            height: 45,
                            width: 300,
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              color: greenColor,
                              onPressed: signup,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Sign up',
                                    style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                        color: whiteColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Align(
                        alignment: Alignment.center,
                        child: RichText(
                            text: TextSpan(
                                text: 'Already have an account? ',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: myBlack,
                                  // decoration: TextDecoration.underline,
                                ),
                                children: <TextSpan>[
                              TextSpan(
                                  text: 'Login here',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SignIn()));
                                    },
                                  style: GoogleFonts.inter(
                                      decoration: TextDecoration.underline,
                                      color: browncolor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                            ])),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              )),
            ),
          ),
        ),
      ),
    );
  }
}

OutlineInputBorder customFocusBorder() {
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide(color: greenColor, width: 2));
}

TextStyle floatingLabelTextStyle() {
  return TextStyle(color: greenColor, fontSize: 13);
}
