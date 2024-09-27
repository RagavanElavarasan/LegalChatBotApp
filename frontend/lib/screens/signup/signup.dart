import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/screens/signin/signin.dart';
import 'package:http/http.dart' as http;


class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _signup() async {
    final String username = _usernameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    // Validation
    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showSnackbar("All fields are required.");
      return;
    }

    if (password != confirmPassword) {
      _showSnackbar("Passwords do not match.");
      return;
    }

    try {
      // Prepare the signup data payload
      final Map<String, dynamic> signupPayload = {
        "user_name": username,
        "email": email,
        "password": password,
        "confirm_password": confirmPassword
      };

      // Make the POST request to your Flask backend
      var response = await http.post(
        Uri.parse('http://10.0.2.2:5001/signup'), // Adjust this with your server IP if needed
        headers: {"Content-Type": "application/json"},
        body: json.encode(signupPayload),
      );

      // Handle the response
      if (response.statusCode == 201) {
        // If signup is successful, navigate to ChatInterfacePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SigninPage()),
        );
      } else {
        // If signup failed, show the error message in the SnackBar
        var responseBody = json.decode(response.body);
        _showSnackbar(responseBody["error"] ?? "Signup failed. Try again.");
      }
    } catch (e) {
      // Handle connection errors
      _showSnackbar("An error occurred. Please try again.");
      print('Error: $e');
    }
  }

  void _showSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
              child: Text("Sign up", style: TextStyle(fontSize: 32)),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 41,
              width: 242,
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Enter your username',
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
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Enter your email address',
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
                controller: _passwordController,
                obscureText: true,  // Hide password text
                decoration: InputDecoration(
                  labelText: 'Enter your password',
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
                controller: _confirmPasswordController,
                obscureText: true,  // Hide confirm password text
                decoration: InputDecoration(
                  labelText: 'Re-enter your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _signup, // Call the signup function
              child: const Text("Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}