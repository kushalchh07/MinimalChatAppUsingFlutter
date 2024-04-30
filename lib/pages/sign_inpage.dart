// import 'package:chat_app/pages/sign_inpage.dart';
import 'package:chat_app/pages/sign_uppage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final emailController = TextEditingController();
    final passController = TextEditingController();
    final confirmPassController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
                height: 45,
                width: 45,
                child: Image(
                    image: AssetImage(
                  "Icons/ChatIcon.png",
                ))),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: size.height,
            width: 500,
            child: Column(
              children: [
                Text(
                  "Login",
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
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
                  obscureText: true,
                  decoration: InputDecoration(
                      label: Text(
                        "Password",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      prefixIcon: Icon(Icons.lock_open)),
                ),
                SizedBox(
                  height: 60,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "Sign in",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w800),
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUp()));
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
    );
  }
}
