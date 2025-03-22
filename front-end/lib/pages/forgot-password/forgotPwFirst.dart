import 'package:flutter/material.dart';
import 'package:fynaura/pages/forgot-password/forgotPwSecond.dart';
import 'package:fynaura/widgets/CustomButton.dart';
import 'package:fynaura/widgets/backBtn.dart';
import 'package:fynaura/pages/log-in/mainLogin.dart';
import 'package:fynaura/widgets/customInput.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';  // To handle JSON

class ForgotPwFirst extends StatefulWidget {
  const ForgotPwFirst({super.key});

  @override
  State<ForgotPwFirst> createState() => _ForgotPwFirstState();
}

class _ForgotPwFirstState extends State<ForgotPwFirst> {
  final TextEditingController _emailController = TextEditingController();

  // Function to send a password reset link
  Future<void> _sendPasswordResetLink() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid email address.")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://<YOUR_BACKEND_URL>/auth/password-reset'),  // Update with your NestJS backend URL
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        // Navigate to the next page after success
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ForgotPWSecond()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password reset link sent to $email")),
        );
      } else {
        // Handle other error statuses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to send password reset link")),
        );
      }
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error occurred: $error")),
      );
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Forgot Password?",
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Please enter the email address linked to your account.",
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF6A707C),
                ),
              ),
              const SizedBox(height: 30),
              CustomInputField(
                hintText: "Enter your Email",
                controller: _emailController,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: "Send Code",
                backgroundColor: const Color(0xFF1E232C),
                textColor: Colors.white,
                onPressed: _sendPasswordResetLink,
              ),
              const SizedBox(height: 500),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Remember the password?",
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Mainlogin()),
                      );
                    },
                    child: const Text(
                      "Login Now",
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF254E7A),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
