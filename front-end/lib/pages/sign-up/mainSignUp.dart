import 'package:flutter/material.dart';
import 'package:fynaura/pages/log-in/mainLogin.dart';
import 'package:fynaura/widgets/CustomButton.dart';
import 'package:fynaura/widgets/customInput.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Mainsignup extends StatefulWidget {
  const Mainsignup({super.key});

  @override
  State<Mainsignup> createState() => _MainSignupState();
}

class _MainSignupState extends State<Mainsignup> {
  // Controllers for the input fields
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // Password visibility state
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final String apiUrl = 'http://192.168.127.53:3000/user/register';

  // Error and success message state variables
  String? passwordError;
  String? emailError;
  String? generalError;
  String? successMessage;
  bool isLoading = false;

  // Validate form before submission
  bool validateForm() {
    bool isValid = true;

    // Reset error messages
    setState(() {
      passwordError = null;
      emailError = null;
      generalError = null;
    });

    // Check if any field is empty
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      setState(() {
        generalError = "All fields are required";
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

    // Check password matching
    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        passwordError = "Passwords do not match";
      });
      isValid = false;
    }

    // Check password strength (at least 6 characters)
    if (passwordController.text.isNotEmpty && passwordController.text.length < 6) {
      setState(() {
        passwordError = "Password must be at least 6 characters long";
      });
      isValid = false;
    }

    return isValid;
  }

  // Register user method
  Future<void> registerUser() async {
    // Validate form
    if (!validateForm()) {
      return;
    }

    // Show loading indicator
    setState(() {
      isLoading = true;
      generalError = null;
      successMessage = null;
    });

    // Prepare the data to send to the backend
    final Map<String, dynamic> data = {
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'confirmPassword': confirmPasswordController.text,
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

      // Parse the JSON response
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Check if the response indicates success
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Registration successful
        setState(() {
          successMessage = responseData['message'] ?? 'Registration successful!';
          generalError = null; // Clear any existing error
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(successMessage!),
          backgroundColor: Colors.green,
        ));

        // Add a small delay before navigation
        Future.delayed(const Duration(seconds: 2), () {
          // Navigate to login page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Mainlogin()),
          );
        });
      } else {
        // Handle error response
        setState(() {
          generalError = responseData['message'] ?? "Registration failed";
          successMessage = null; // Clear any existing success message
        });
      }
    } catch (e) {
      // Hide loading indicator
      setState(() {
        isLoading = false;
        generalError = "Network error. Please check your connection and try again.";
        successMessage = null; // Clear any existing success message
      });
      print("Exception occurred: $e");
    }
  }

  // Empty function to use when button should be disabled
  void _doNothing() {
    // This function intentionally does nothing
  }

  // Toggle password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  // Toggle confirm password visibility
  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 10,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Register!",
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Already have an account?",
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
                      "Login with",
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF254E7A),
                      ),
                    ),
                  ),
                ],
              ),

              // General error message
              if (generalError != null)
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(top: 10),
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

              // Success message
              if (successMessage != null)
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          successMessage!,
                          style: const TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 32),
              CustomInputField(
                hintText: "First Name",
                controller: firstNameController,
              ),
              const SizedBox(height: 20),
              CustomInputField(
                hintText: "Last Name",
                controller: lastNameController,
              ),
              const SizedBox(height: 20),
              CustomInputField(
                hintText: "Email",
                controller: emailController,
              ),

              // Email error message
              if (emailError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    emailError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 20),
              // Password field with eye icon
              CustomInputField(
                hintText: "Password",
                controller: passwordController,
                obscureText: !_isPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Color(0xFF8391A1),
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
              
              const SizedBox(height: 20),
              // Confirm password field with eye icon
              CustomInputField(
                hintText: "Confirm Password",
                controller: confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Color(0xFF8391A1),
                  ),
                  onPressed: _toggleConfirmPasswordVisibility,
                ),
              ),

              // Password error message
              if (passwordError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    passwordError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 20),
              CustomButton(
                text: isLoading ? "Please wait..." : "Register",
                backgroundColor: isLoading ? Colors.grey : Color(0xFF254e7a),
                textColor: Colors.white,
                onPressed: isLoading ? _doNothing : registerUser,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Or Register with",
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
              // Social media login buttons (Google, Facebook, etc.)
            ],
          ),
        ),
      ),
    );
  }
}