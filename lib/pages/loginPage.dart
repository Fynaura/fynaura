import 'package:flutter/material.dart';
import 'package:fynaura/pages/mainSignUp.dart';

import 'mainlogin.dart'; // Import the Mainlogin page
import '../widgets/CustomButton.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Image
          Image.asset(
            'images/login.png',
            width: double.infinity,
            height: 450,
            fit: BoxFit.cover,
          ),

          // Center Logo
          Center(
            child: Image.asset("images/fynaura-icon.png"),
          ),

          const SizedBox(height: 20),

          // Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Login Button
                CustomButton(
                  text: "Login",
                  backgroundColor: const Color(0xFF1E232C), // 1E232C color
                  textColor: Colors.white,
                  onPressed: () {
                    // Navigate to Mainlogin page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Mainlogin()),
                    );
                  },
                ),
                const SizedBox(height: 18),

                // Register Button
                CustomButton(
                  text: "Register",
                  isFilled: false,
                  textColor: const Color(0xFF1E232C), // Text color
                  borderColor: const Color(0xFF1E232C), // Border color
                  onPressed: () {
                    // Navigate sign up page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Mainsignup()),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // "Continue as a guest" TextButton
                Center(
                  child: TextButton(
                    onPressed: () {
                      print("Continue as a guest pressed,open the home");
                    },
                    child: const Text(
                      "Continue as a guest",
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF254E7A),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
