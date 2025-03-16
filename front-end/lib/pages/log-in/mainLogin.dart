import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fynaura/pages/forgot-password/forgotPwFirst.dart';
import 'package:fynaura/pages/sign-up/mainSignUp.dart';
import 'package:fynaura/widgets/CustomButton.dart';
import 'package:fynaura/widgets/backBtn.dart';
import 'package:fynaura/widgets/customInput.dart';
import '../home/main_screen.dart';

class Mainlogin extends StatefulWidget {
  const Mainlogin({super.key});

  @override
  State<Mainlogin> createState() => _MainloginState();
}

class _MainloginState extends State<Mainlogin> {
  // Controllers for the input fields
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // API URL for backend login endpoint
  final String apiUrl = 'http://192.168.127.53:3000/user/login'; // Replace with your backend URL

  // Login user method
  Future<void> loginUser() async {
    // Prepare the data to send to the backend
    final Map<String, dynamic> data = {
      'email': emailController.text,
      'password': passwordController.text,
    };

    try {
      // Send a POST request to the backend
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      // Handle the response from the backend
      if (response.statusCode == 200) {
        // If the login is successful, navigate to the home screen
        print("Login successful!");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      } else {
        // If login fails, show an error message
        print("Login failed. Error: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${response.body}'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      // If there's an error with the HTTP request
      print("Error during login: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred during login.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Center(
                child: Image.asset(
                  "images/fynaura-icon.png",
                  height: 120,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Welcome back!",
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Enter your email and password to login",
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF6A707C),
                ),
              ),
              const SizedBox(height: 32),
              CustomInputField(
                hintText: "Enter your email",
                controller: emailController,
              ),
              const SizedBox(height: 20),
              CustomInputField(
                hintText: "Enter your password",
                controller: passwordController,
                obscureText: true,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Navigate to forgot password screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPwFirst()),
                    );
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF6A707C),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Navigate to forgot password screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainScreen()),
                    );
                  },
                  child: const Text(
                    "temp?",
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF6A707C),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              CustomButton(
                text: "Login",
                backgroundColor: const Color(0xFF1E232C),
                textColor: Colors.white,
                onPressed: loginUser, // Trigger the login function
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Or Login with",
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Color(0xFFE8ECF4))),
                ],
              ),
              const SizedBox(height: 20),
              // Social media login buttons
            ],
          ),
        ),
        
      ),
      
    );
  }
}
