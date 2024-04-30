import 'package:chat_app/pages/sign_inpage.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
                  "Register",
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "You and Your friends always connected",
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
                  height: 10,
                ),
                TextField(
                  controller: confirmPassController,
                  obscureText: true,
                  decoration: InputDecoration(
                      label: Text(
                        "Confirm Password",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      prefixIcon: Icon(Icons.lock_open)),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _isChecked,
                      onChanged: (value) {
                        setState(() {
                          _isChecked = value!;
                        });
                      },
                    ),
                    Text(
                      'I agree with the ',
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to the Terms and Conditions screen or open a dialog
                      },
                      child: Text(
                        'Terms and Conditions',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          // decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Text(
                      ' and the ',
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to the Privacy Policy screen or open a dialog
                      },
                      child: Text(
                        'Privacy Policy',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          // decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w800),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, fixedSize: Size(350, 40)),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignIn()));
                      },
                      child: Text(
                        'Login',
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
