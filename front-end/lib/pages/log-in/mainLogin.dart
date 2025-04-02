import 'package:flutter/material.dart';
import 'package:fynaura/pages/forgot-password/forgotPwFirst.dart';
import 'package:fynaura/pages/home/main_screen.dart'; // Import MainScreen for navigation
import 'package:fynaura/pages/profile/profile.dart'; // Import ProfilePage for forgot password
import 'package:fynaura/pages/user-session/UserSession.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fynaura/pages/sign-up/mainSignUp.dart';
import 'package:fynaura/widgets/CustomButton.dart';
import 'package:fynaura/widgets/customInput.dart';

// Global variable to store the user ID
String? userId;
String? displayName;
String? email;

class Mainlogin extends StatefulWidget {
  const Mainlogin({super.key});

  @override
  State<Mainlogin> createState() => _MainloginState();
}

class _MainloginState extends State<Mainlogin> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final String apiUrl =
      'http://10.31.4.203:3000/user/login'; // API endpoint for login

  String? emailError;
  String? passwordError;
  String? generalError;
  bool isLoading = false;

  String? get currentUserId => userId;

  // Validate form before submission
  bool validateForm() {
    bool isValid = true;

    setState(() {
      emailError = null;
      passwordError = null;
      generalError = null;
    });

    if (emailController.text.isEmpty) {
      setState(() {
        emailError = "Email is required";
      });
      isValid = false;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (emailController.text.isNotEmpty &&
        !emailRegex.hasMatch(emailController.text)) {
      setState(() {
        emailError = "Please enter a valid email address";
      });
      isValid = false;
    }

    if (passwordController.text.isEmpty) {
      setState(() {
        passwordError = "Password is required";
      });
      isValid = false;
    }

    return isValid;
  }

  // Empty function to use when button should be disabled
  void _doNothing() {}

  // Login user method
  Future<void> loginUser() async {
    if (!validateForm()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    final Map<String, dynamic> data = {
      'email': emailController.text,
      'password': passwordController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      setState(() {
        isLoading = false;
      });

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || responseData.containsKey('idToken')) {
        String idToken = responseData['idToken'];

        // Send the idToken to the backend to get user details
        final userDetailsResponse = await http.get(
          Uri.parse('http://10.31.4.203:3000/user/me?idToken=$idToken'),
          headers: {"Authorization": "Bearer $idToken"},
        );

        final userDetails = json.decode(userDetailsResponse.body);
        final userSession = UserSession();
        if (userDetails != null) {
          userSession.userId = userDetails['uid'];
          userSession.displayName = userDetails['displayName'];
          userSession.email = userDetails['email'];
          // Set the global user ID
          userId = userDetails['uid']; // Assuming userId is in the response

          // Navigate to the MainScreen with user details
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(
                
              ),
            ),
          );
        } else {
          setState(() {
            generalError = 'Failed to fetch user details.';
          });
        }
      } else {
        Map<String, dynamic> errorResponse = responseData;
        setState(() {
          generalError = errorResponse['message'] ??
              "Login failed. Please try again later.";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        generalError =
            "Network error. Please check your connection and try again.";
      });
      print("Error during login: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
              const SizedBox(height: 20),

              // General error message
              if (generalError != null)
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          generalError!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 12),
              CustomInputField(
                hintText: "Enter your email",
                controller: emailController,
              ),

              // Email error message
              if (emailError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      emailError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ),

              const SizedBox(height: 20),
              CustomInputField(
                hintText: "Enter your password",
                controller: passwordController,
                obscureText: true,
              ),

              // Password error message
              if (passwordError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      passwordError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPwFirst()),
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
              const SizedBox(height: 10),
              CustomButton(
                text: isLoading ? "Please wait..." : "Login",
                backgroundColor:
                    isLoading ? Colors.grey : Color(0xFF254e7a),
                textColor: Colors.white,
                onPressed: isLoading
                    ? _doNothing
                    : loginUser, // Disable button when loading
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF6A707C),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Mainsignup()),
                      );
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF254E7A),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
