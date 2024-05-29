import 'package:chat_app/pages/sign_inpage.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isChecked = false;

  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();

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

  void signUserUp() async {
    //making sure user must agree the terms and conditions
    if (!_isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Please agree to the Terms and Conditions and Privacy Policy"),
        ),
      );
      return; // Return to exit the function
    }

// some time to load showing loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    if (passController != confirmPassController) {
      Navigator.pop(context); // end CircularProgressIndicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password Donot Match!"),
        ),
      );
    }
    final authservice = Provider.of<AuthService>(context, listen: false);
    try {
      await authservice.signUpWithEmailandPassword(
          emailController.text, passController.text);
      Navigator.pop(context); // end CircularProgressIndicator
    } catch (e) {
      Navigator.pop(context); // end CircularProgressIndicator

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
    // try {
    //   if (passController == confirmPassController) {
    //     await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //         email: emailController.text, password: passController.text);
    //   } else {
    //     showErrorMessage("Both passwords doesnot match");
    //   }
    // } on FirebaseAuthException catch (e) {
    //   Navigator.pop(context);
    //   showErrorMessage(e.code);
    // }
  }

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
                child: Image(
                    image: AssetImage(
                  "assets/Icons/ChatIcon.png",
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
                  style: GoogleFonts.junge(
                      color: Colors.black,
                      fontSize: 40,
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
                  onPressed: () {
                    signUserUp();
                  },
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16),
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
