import 'package:chat_app/pages/sign_inpage.dart';
import 'package:chat_app/pages/sign_uppage.dart';
import 'package:flutter/material.dart';

class GetStart extends StatelessWidget {
  const GetStart({super.key});

  @override
  Widget build(BuildContext context) {
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
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Get Started",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Start with signing up or sign in.",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 100,
            ),
            Image(image: AssetImage("Icons/peoples.jpeg")),
            SizedBox(
              height: 100,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SignUp()));
              },
              child: Text(
                "Sign up",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, fixedSize: Size(200, 30)),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SignIn()));
              },
              child: Text(
                "Sign in",
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, fixedSize: Size(200, 30)),
            )
          ],
        ),
      ),
    );
  }
}
