import 'package:flutter/material.dart';
import 'package:frontend/screens/chat_interface/chat_interface.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http; // Add this import
import 'dart:convert'; // For JSON encoding

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  // Variables to store email and password
  String email = '';
  String password = '';

  // Function to handle sign-in
  Future<void> _signIn() async {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    // API URL (replace with your backend URL)
    const String apiUrl = 'http://10.0.2.2:5001/login'; // Adjust the URL

    // Prepare the data for the request
    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };

    try {
      // Send POST request to Flask backend
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        Get.to(()=>ChatInterfacePage());
        // Handle successful login (navigate to another screen, store user info, etc.)
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${response.body}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Copsify AI"),
      ),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 50),
              child: Text(
                "Sign in",
                style: TextStyle(fontSize: 32),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 41,
              width: 242,
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value; // Update email state
                },
                decoration: InputDecoration(
                  labelText: 'Enter Your Email Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 41,
              width: 242,
              child: TextField(
                obscureText: true, // Hide password text
                onChanged: (value) {
                  password = value; // Update password state
                },
                decoration: InputDecoration(
                  labelText: 'Enter Your Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signIn, // Call the _signIn function
              child: const Text("Sign in"),
            ),
          ],
        ),
      ),
    );
  }
}
