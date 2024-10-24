import 'package:flutter/material.dart';
import 'package:frontend/screens/chat_interface/chat_interface.dart';
import 'package:frontend/screens/signin/signin.dart'; // Importing the signin screen
import 'package:frontend/screens/signup/signup.dart';
import 'package:frontend/screens/splash/splash.dart';
import 'package:get/get.dart'; // GetX package for state management and navigation

void main() {
  runApp(const MyApp()); // Entry point of the Flutter app
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // Using GetMaterialApp for GetX support
      debugShowCheckedModeBanner: false, // Hides the debug banner
      home: ChatInterfacePage(email: "", username: "", firstLetter: "")// Set the chat interface as the home page
    );
  }
}
