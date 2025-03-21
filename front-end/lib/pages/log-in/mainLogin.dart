import 'package:flutter/material.dart';
import 'package:fynaura/pages/home/home.dart';
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
  final String apiUrl = 'http://192.168.127.53:3000/user/login';

  // Error message state variables
  String? emailError;
  String? passwordError;
  String? generalError;
  bool isLoading = false;

  // Validate form before submission
  bool validateForm() {
    bool isValid = true;

    // Reset error messages
    setState(() {
      emailError = null;
      passwordError = null;
      generalError = null;
    });

    // Check if email is empty
    if (emailController.text.isEmpty) {
      setState(() {
        emailError = "Email is required";
      });
      isValid = false;
    }

    // Validate email format
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (emailController.text.isNotEmpty && !emailRegex.hasMatch(emailController.text)) {
      setState(() {
        emailError = "Please enter a valid email address";
      });
      isValid = false;
    }

    // Check if password is empty
    if (passwordController.text.isEmpty) {
      setState(() {
        passwordError = "Password is required";
      });
      isValid = false;
    }

    return isValid;
  }

  // Empty function to use when button should be disabled
  void _doNothing() {
    // This function intentionally does nothing
  }

  // Login user method
  Future<void> loginUser() async {
    // Validate form
    if (!validateForm()) {
      return;
    }

    // Show loading indicator
    setState(() {
      isLoading = true;
    });

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

      // Hide loading indicator
      setState(() {
        isLoading = false;
      });

      // Parse the response body
      final responseData = json.decode(response.body);

      // If we received an idToken, consider it a successful login
      if (response.statusCode == 200 || responseData.containsKey('idToken')) {
        // Store the token for later use (you might want to save it securely)
        // For example: await secureStorage.write(key: 'idToken', value: responseData['idToken']);

        print("Login successful!");

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Login successful!'),
          backgroundColor: Colors.green,
        ));

        // Navigate to the home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        // Parse the error response
        Map<String, dynamic> errorResponse = responseData;

        // Handle specific error cases
        if (response.statusCode == 401) {
          // Unauthorized - wrong credentials
          setState(() {
            generalError = "Invalid email or password. Please try again.";
          });
        } else if (response.statusCode == 404) {
          // User not found
          setState(() {
            emailError = "No account found with this email. Please sign up.";
          });
        } else if (errorResponse.containsKey('message')) {
          // Show the specific error message from the backend
          setState(() {
            generalError = errorResponse['message'];
          });
        } else {
          // Generic error
          setState(() {
            generalError = "Login failed. Please try again later.";
          });
        }

        print("Login failed. Error: ${response.body}");
      }
    } catch (e) {
      // Handle network or other errors
      setState(() {
        isLoading = false;
        generalError = "Network error. Please check your connection and try again.";
      });
      print("Error during login: $e");
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

                          builder: (context) => MainScreen()),
                    );
                  },
                  child: const Text(
                    "Temp",

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
                backgroundColor: isLoading ? Colors.grey : const Color(0xFF1E232C),
                textColor: Colors.white,
                onPressed: isLoading ? _doNothing : loginUser, // Disable button when loading
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
                        MaterialPageRoute(builder: (context) => const Mainsignup()),
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
                  Expanded(child: Divider(color: const Color(0xFFE8ECF4))),
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