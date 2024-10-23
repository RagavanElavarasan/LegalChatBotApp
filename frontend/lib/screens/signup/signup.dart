import 'package:flutter/material.dart';
import 'package:frontend/screens/signin/signin.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _signup() async {
    final String username = _usernameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showSnackbar("All fields are required.");
      return;
    }

    if (password != confirmPassword) {
      _showSnackbar("Passwords do not match.");
      return;
    }

    try {
      final Map<String, dynamic> signupPayload = {
        "user_name": username,
        "email": email,
        "password": password,
        "confirm_password": confirmPassword,
      };

      var response = await http.post(
        Uri.parse('http://10.0.2.2:5001/signup'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(signupPayload),
      );

      if (response.statusCode == 201) {
        Get.to(() => SigninPage(username: username,));
      } else {
        var responseBody = json.decode(response.body);
        _showSnackbar(responseBody["error"] ?? "Signup failed. Try again.");
      }
    } catch (e) {
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Sign Up", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),
                _buildTextField(_usernameController, 'Username', 'Enter your username'),
                const SizedBox(height: 20),
                _buildTextField(_emailController, 'Email', 'Enter your email'),
                const SizedBox(height: 20),
                _buildTextField(
                  _passwordController,
                  'Password',
                  'Enter your password',
                  obscureText: !_isPasswordVisible,
                  isPassword: true,
                  isPasswordVisible: _isPasswordVisible,
                  togglePasswordVisibility: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  _confirmPasswordController,
                  'Confirm Password',
                  'Re-enter your password',
                  obscureText: !_isConfirmPasswordVisible,
                  isPassword: true,
                  isPasswordVisible: _isConfirmPasswordVisible,
                  togglePasswordVisibility: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _signup,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 125, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: const Color(0xFF083087),
                  ),
                  child: const Text("Sign Up", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Get.to(() => SigninPage());
                      },
                      child: const Text("Sign In", style: TextStyle(color: Color(0xFF083087))),
                    ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String labelText,
    String hintText, {
    bool obscureText = false,
    bool isPassword = false,
    bool isPasswordVisible = false,
    Function()? togglePasswordVisibility,
  }) {
    return Container(
      width: 320,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          labelStyle: const TextStyle(fontSize: 16, color: Colors.black),
          hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(5.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 1.5),
            borderRadius: BorderRadius.circular(5.0),
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: togglePasswordVisibility,
                )
              : null,
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
