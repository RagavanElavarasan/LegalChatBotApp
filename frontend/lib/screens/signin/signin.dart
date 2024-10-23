import 'package:flutter/material.dart';
import 'package:frontend/screens/chat_interface/chat_interface.dart';
import 'package:frontend/screens/signup/signup.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SigninPage extends StatefulWidget {
  final String? username;
  const SigninPage({Key? key, this.username}) : super(key: key);

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  String email = '';
  String password = '';
  bool rememberMe = false;
  bool obscurePassword = true;

  Future<void> _signIn() async {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    const String apiUrl = 'http://10.0.2.2:5001/login';

    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final firstLetter = email[0].toUpperCase();

        Get.to(() => ChatInterfacePage(
              email: email,
              username: widget.username??email,
              firstLetter: firstLetter,
            ));
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // Sign-in image
              SizedBox(
                height: 200, // Set your desired height
                width: 200, // Set your desired width
                child: Image.asset('assets/images/sign_in.png'),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20),
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
                    email = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter Your Email Address',
                    labelText: 'Email',
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.black), // Change border color to black
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.black), // Change enabled border color to black
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.black), // Change focused border color to black
                  ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 45,
                width: 300,
                child: TextField(
                  obscureText: obscurePassword,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter Your Password',
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.black), // Change border color to black
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.black), // Change enabled border color to black
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.black), // Change focused border color to black
                  ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Handle Forgot Password action
                      },
                      child: const Text('Forgot Password?',
                      style: TextStyle(
                        color: Color(0xFF083087)
                      ),),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 47,
                width: 300,
                child: ElevatedButton(
                  onPressed: _signIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF083087),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    "Sign In",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 40),
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
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialMediaIcon('assets/images/google.png', 30, 30),
                  const SizedBox(width: 20),
                  _buildSocialMediaIcon('assets/images/microsoft.png', 50, 50),
                  const SizedBox(width: 20),
                  _buildSocialMediaIcon('assets/images/facebook.png', 30, 30),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("don’t have an account?"),
                  TextButton(
                    onPressed: () {
                      Get.to(()=>SignupPage());
                    },
                    child: const Text(
                      " Sign up",
                      style: TextStyle(
                        color: Color(0xFF083087),
                      ),
                    ),
                  ),
                  const SizedBox(height: 70),
                ],
              ),
            ],
          ),
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
        width: width,
      ),
    );
  }
}
