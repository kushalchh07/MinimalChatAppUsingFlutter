// ignore_for_file: sort_child_properties_last

import 'dart:math';

import 'package:chat_app/Bloc/internetBloc/internet_bloc.dart';
import 'package:chat_app/Bloc/loginbloc/login_bloc.dart';
import 'package:chat_app/constants/colors/colors.dart';
import 'package:chat_app/pages/Chat/chat_screen.dart';
import 'package:chat_app/pages/Login&signUp/sign_uppage.dart';
import 'package:chat_app/pages/screen/base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Bloc/biometricBloc/biometric_bloc.dart';
import '../../Bloc/biometricBloc/biometric_event.dart';
import '../../Bloc/biometricBloc/biometric_state.dart';
import '../../constants/Sharedpreferences/sharedpreferences.dart';
import '../../constants/size/size.dart';
import '../screen/internet_lost_screen.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> with SingleTickerProviderStateMixin {
  bool _showPassword = false;
  bool _isRememberMe = false;
  bool loginError = true;
  bool agreeTerms = false;
  bool _isBiometricEnabled = true;
  void toggleRememberMe() {
    setState(() {
      _isRememberMe = !_isRememberMe;
    });
  }

  final emailController = TextEditingController();
  final passController = TextEditingController();

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  late AnimationController _controller;
  late Animation<double> _animation;

  final String _text = 'Welcome To Guff Gaff!';
  final String _text1 = 'Enjoy Chatting With Friends.';

  final int _durationPerLetter = 100;

  login() {
    print("Logg In tapped");
    // if (formKey.currentState != null && formKey.currentState!.validate()) {
    FocusManager.instance.primaryFocus?.unfocus();
    BlocProvider.of<LoginBloc>(context).add(LoginTappedEvent(
        email: emailController.text.trim(),
        password: passController.text.trim()));
    // }
  }

  google() {
    BlocProvider.of<LoginBloc>(context).add(GoogleLoginTappedEvent());
  }

  Future<void> _checkBiometricStatus() async {
    _isBiometricEnabled = await getBiomertic();
    setState(() {}); // Update the UI based on the retrieved biometric status
  }

  final LocalAuthentication auth = LocalAuthentication();

  Future<void> _authenticateWithBiometrics(BuildContext context) async {
    try {
      // Check if biometric authentication is enabled
      final BiometricBloc biometricBloc = context.read<BiometricBloc>();
      biometricBloc
          .add(GetEnabledBiometrics()); // This retrieves enabled biometrics
      final BiometricState state = biometricBloc.state;
      if (state is AvailableBiometricsLoaded) {
        print("State: ${state.enabledBiometrics}");
      }
      if (state is AvailableBiometricsLoaded &&
          state.enabledBiometrics.isNotEmpty) {
        print("State: ${state.enabledBiometrics}");
        bool authenticated = await auth.authenticate(
          localizedReason: 'Please authenticate to sign in',
          // biometricOnly: true,
          options: AuthenticationOptions(
            stickyAuth: true, // Keeps the authentication active
            useErrorDialogs: true,
          ),
        );

        if (authenticated) {
          // If the user authenticates successfully
          print("Biometric authentication successful");
          // Navigate to Home Screen or continue with Sign-in
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // Handle failure case
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Biometric authentication failed')),
          );
        }
      } else {
        // If no biometrics are enabled, show a message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No biometric methods are enabled')),
        );
      }
    } catch (e) {
      // Handle errors and exceptions
      print("Error in biometric authentication: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error in biometric authentication')),
      );
    }
  }

  facebook() {}
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: _text1.length * _durationPerLetter),
      vsync: this,
    )..forward();
    _animation = Tween<double>(begin: 0, end: _text1.length.toDouble())
        .animate(_controller);

    _checkBiometricStatus();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();

    // _animation.dispose();
    emailController.dispose();
    passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppSize size = AppSize(context: context);
    final BiometricBloc biometricBloc = context.read<BiometricBloc>();
    biometricBloc.add(GetEnabledBiometrics());

    return BlocListener<InternetBloc, InternetState>(
      listener: (context, state) {
        if (state is InternetDisconnected) {
          // Navigate to no internet screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InternetLostScreen()),
          );
        } else if (state is InternetConnected) {
          // Pop the NoInternetScreen if the internet is restored
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        backgroundColor: appBackgroundColor,
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccessfullState) {
              Get.offAll(() => Base());
              Fluttertoast.showToast(
                msg: 'Login Sucessfully',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.green,
                textColor: whiteColor,
              );
            } else if (state is LoginError) {
              _showSnackBar(state.error, Colors.red);
            }
          },
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                // physics: NeverScrollableScrollPhysics(),
                child: Container(
                  height: Get.height,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 30, left: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/icons/appicon.png',
                          width: 200,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Form(
                            // key: formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AnimatedBuilder(
                                  animation: _animation,
                                  builder: (context, child) {
                                    int currentLength =
                                        _animation.value.round();
                                    String currentText = _text.substring(
                                        0, min(_text.length, currentLength));

                                    return Text(
                                      currentText,
                                      style: GoogleFonts.inter(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w600,
                                        color: myBlack,
                                      ),
                                    );
                                  },
                                ),
                                AnimatedBuilder(
                                  animation: _animation,
                                  builder: (context, child) {
                                    int currentLength =
                                        _animation.value.round();
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
                                SizedBox(
                                  height: Get.height * 0.04,
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
                                    floatingLabelStyle:
                                        floatingLabelTextStyle(),
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: greyColor,
                                    ),
                                    focusedBorder: customFocusBorder(),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide(
                                          color: primaryColor, width: 2),
                                    ),
                                    labelStyle: TextStyle(
                                        color: greyColor, fontSize: 13),
                                    hintText: 'Email',
                                  ),
                                ),
                                SizedBox(
                                  height: Get.height * 0.015,
                                ),
                                TextFormField(
                                  cursorColor: greenColor,
                                  controller: passController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                  textInputAction: TextInputAction.go,
                                  obscureText: !_showPassword,
                                  decoration: InputDecoration(
                                    floatingLabelStyle: TextStyle(
                                        color: primaryColor, fontSize: 13),
                                    focusedBorder: customFocusBorder(),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide(
                                          color: primaryColor, width: 2),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: greyColor,
                                    ),
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
                                    labelStyle: GoogleFonts.inter(
                                        color: greyColor, fontSize: 13),
                                    hintText: 'Password',
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _isRememberMe,
                                          onChanged: (value) {
                                            setState(() {
                                              _isRememberMe = value!;
                                            });
                                            toggleRememberMe();
                                          },
                                        ),
                                        Text("Remember Me",
                                            style: GoogleFonts.inter(
                                                fontSize: 14,
                                                color: blackColor,
                                                fontWeight: FontWeight.w400)),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Navigator.of(context).push(
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             const ForgetPassword()));
                                      },
                                      child: Text(
                                        'Forgot Password?',
                                        style: GoogleFonts.inter(
                                          decoration: TextDecoration.underline,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: myBlack,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: BlocBuilder<LoginBloc, LoginState>(
                            builder: (context, state) {
                              if (state is LoginLoadingState) {
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
                                  onPressed: login,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Login',
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
                        const SizedBox(
                          height: 15,
                        ),
                        _isBiometricEnabled
                            ? ElevatedButton(
                                onPressed: () {
                                  _authenticateWithBiometrics(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(200, 50),
                                  backgroundColor:
                                      Colors.green, // Your theme color
                                ),
                                child: Text(
                                  'Sign in with Biometrics',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Container(),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: Get.width * 0.8,
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: yellowColor,
                                  thickness: 2,
                                  endIndent: 5,
                                ),
                              ),
                              Text(
                                'OR',
                                style: GoogleFonts.inter(
                                  color: greenColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: yellowColor,
                                  thickness: 2,
                                  indent: 5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.01,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              child: Container(
                                width: Get.width * 0.4,
                                height: Get.height * 0.06,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black.withOpacity(0.06),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/google.png',
                                      width: 30,
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      'Google',
                                      style: GoogleFonts.inter(
                                        color: myBlack,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: google,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            GestureDetector(
                              child: Container(
                                width: Get.width * 0.4,
                                height: Get.height * 0.06,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black.withOpacity(0.06),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/facebook.png',
                                      width: 30,
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      'Facebook',
                                      style: GoogleFonts.inter(
                                        color: myBlack,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: facebook,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Get.height * 0.03,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.off(() => SignUp());
                          },
                          child: Container(
                            child: RichText(
                              text: TextSpan(
                                text: "Haven't Registered? ",
                                style: GoogleFonts.inter(
                                    fontSize: 15,
                                    color: myBlack,
                                    fontWeight: FontWeight.w400),
                                children: [
                                  TextSpan(
                                    text: "Register here",
                                    style: GoogleFonts.inter(
                                      decoration: TextDecoration.underline,
                                      color: browncolor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.07,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder customFocusBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide(color: greenColor, width: 2),
    );
  }

  TextStyle floatingLabelTextStyle() {
    return TextStyle(color: primaryColor, fontSize: 13);
  }
}
