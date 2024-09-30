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
        Get.to(() => ChatInterfacePage());
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
              padding: EdgeInsets.only(top: 100),
              child: Text(
                "Sign in",
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: "Joan",
                ),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              height: 45,
              width: 300,
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
              height: 45,
              width: 300,
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
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft, // Aligns the button to the left
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 50), // Adjust the padding as necessary
                child: TextButton(
                  onPressed: () {
                    // Handle password recovery
                  },
                  child: const Text(
                    "Forget Password?",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                _signIn();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF083087),
                padding:
                    const EdgeInsets.symmetric(horizontal: 75, vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Sign in",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Text("              "),
                Expanded(child: Divider(thickness: 3, color: Colors.black26)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("or"),
                ),
                Expanded(child: Divider(thickness: 3, color: Colors.black26)),
                Text("               "),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Create account"),
                TextButton(
                  onPressed: () {
                    // Handle sign-up navigation
                  },
                  child: const Text(
                    " Sign up",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialMediaIcon('assets/images/google.png', 30, 30),
                const SizedBox(width: 20),
                _buildSocialMediaIcon(
                    'assets/images/microsoft.png', 50, 50), // Adjusted width
                const SizedBox(width: 20),
                _buildSocialMediaIcon('assets/images/facebook.png', 30, 30),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaIcon(String assetPath, double height, double width) {
    return InkWell(
      onTap: () {
        // Add logic for social media sign-in
      },
      child: Image.asset(
        assetPath,
        height: height,
        width: width, // Set custom width
      ),
    );
  }
}