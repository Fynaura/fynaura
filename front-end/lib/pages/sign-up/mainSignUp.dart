import 'package:flutter/material.dart';
import 'package:fynaura/pages/log-in/mainLogin.dart';
import 'package:fynaura/widgets/CustomButton.dart';
import 'package:fynaura/widgets/backBtn.dart';
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

  final String apiUrl = 'http://192.168.127.53:3000/user/register'; // Replace with your backend URL

  // Register user method
  Future<void> registerUser() async {
    // Ensure passwords match before proceeding
    if (passwordController.text != confirmPasswordController.text) {
      print("Passwords do not match!");
      return;
    }

    // Prepare the data to send to the backend
    final Map<String, dynamic> data = {
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'email': emailController.text,

      'password': passwordController.text,
      'confirmPassword': confirmPasswordController.text,
    };

    // Send a POST request to the backend
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );

    // Handle the response from the backend
    if (response.statusCode == 200) {
      // If the registration was successful
      print("Registration successful!");
      // Navigate to login page or home page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Mainlogin()),
      );
    } else {
      // If there was an error
      print("Failed to register. Error: ${response.body}");
      // Show an error message or handle accordingly
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${response.body}'),
        backgroundColor: Colors.red,
      ));
    }
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

              const SizedBox(height: 20),
              CustomInputField(
                hintText: "Password",
                controller: passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              CustomInputField(
                hintText: "Confirm Password",
                controller: confirmPasswordController,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: "Register",
                backgroundColor: const Color(0xFF1E232C),
                textColor: Colors.white,
                onPressed: registerUser, // Register user when the button is pressed
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
