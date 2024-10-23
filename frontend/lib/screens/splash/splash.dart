import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/screens/chat_interface/chat_interface.dart';
import 'package:frontend/screens/signin/signin.dart';
import 'package:frontend/screens/signup/signup.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Get.to(()=>SignupPage());
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo-1.png',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20), // Add space between logo and text
            Text(
              'Empowering Legal Intelligence',
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Arima",
                color: Color(0xFF083087),
              ),
            ),
            SizedBox(height: 30),
            //CircularProgressIndicator(), // Loading animation
          ],
        ),
      ),
    );
  }
}
