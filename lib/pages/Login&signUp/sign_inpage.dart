// import 'package:chat_app/pages/sign_inpage.dart';
// ignore_for_file: dead_code, prefer_const_constructors, sort_child_properties_last

import 'package:chat_app/pages/Login&signUp/sign_uppage.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool _obscuretext = true;

login(){}

 

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
                height: 45,
                width: 45,
                child: Image.asset("assets/images/chat.jpeg")),
          )
        ],
      ),
      body: SingleChildScrollView(
        
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: size.height,
              width: 500,
              child: Column(
                children: [
                  Text("Login",
                      style: GoogleFonts.junge(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Remember to get up & strech once",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "In a while - your friends at chat.",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        label: Text(
                          "Email",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        prefixIcon: Icon(Icons.account_circle_outlined)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: passController,
                    obscureText: _obscuretext,
                    decoration: InputDecoration(
                        label: Text(
                          "Password",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        prefixIcon: Icon(Icons.lock_open),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscuretext
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscuretext = !_obscuretext;
                            });
                          },
                        )),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  ElevatedButton(
                    onPressed:login,
                    child: Text(
                      "Sign in",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, fixedSize: Size(350, 40)),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Forget Password?",
                      style: TextStyle(color: Colors.blue, fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUp()));
                        },
                        child: Text(
                          'Sign up here',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            // decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
