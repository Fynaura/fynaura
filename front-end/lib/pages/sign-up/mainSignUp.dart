// import 'package:flutter/material.dart';
// import 'package:fynaura/pages/log-in/mainLogin.dart';
// import 'package:fynaura/widgets/CustomButton.dart';
// import 'package:fynaura/widgets/backBtn.dart';
// import 'package:fynaura/widgets/customInput.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class Mainsignup extends StatefulWidget {
//   const Mainsignup({super.key});
//
//   @override
//   State<Mainsignup> createState() => _MainSignupState();
// }
//
// class _MainSignupState extends State<Mainsignup> {
//   // Controllers for the input fields
//   TextEditingController firstNameController = TextEditingController();
//   TextEditingController lastNameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController confirmPasswordController = TextEditingController();
//
//   // final String apiUrl = 'http://192.168.127.53:3000/user/register';
//   final String apiUrl = ' "http://10.0.2.2:3000/user/register';
//
//   // Register user method
//   Future<void> registerUser() async {
//     // Ensure passwords match before proceeding
//     if (passwordController.text != confirmPasswordController.text) {
//       print("Passwords do not match!");
//       return;
//     }
//
//     // Prepare the data to send to the backend
//     final Map<String, dynamic> data = {
//       'firstName': firstNameController.text,
//       'lastName': lastNameController.text,
//       'email': emailController.text,
//
//       'password': passwordController.text,
//       'confirmPassword': confirmPasswordController.text,
//     };
//
//     // Send a POST request to the backend
//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: {"Content-Type": "application/json"},
//       body: json.encode(data),
//     );
//
//     // Handle the response from the backend
//     if (response.statusCode == 200) {
//       // If the registration was successful
//       print("Registration successful!");
//       // Navigate to login page or home page
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const Mainlogin()),
//       );
//     } else {
//       // If there was an error
//       print("Failed to register. Error: ${response.body}");
//       // Show an error message or handle accordingly
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Error: ${response.body}'),
//         backgroundColor: Colors.red,
//       ));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: 10,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Register!",
//                 style: TextStyle(
//                   fontFamily: 'Urbanist',
//                   fontWeight: FontWeight.bold,
//                   fontSize: 30,
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Already have an account?",
//                     style: TextStyle(
//                       fontFamily: 'Urbanist',
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14,
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => const Mainlogin()),
//                       );
//                     },
//                     child: const Text(
//                       "Login with",
//                       style: TextStyle(
//                         fontFamily: 'Urbanist',
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF254E7A),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 32),
//               CustomInputField(
//                 hintText: "First Name",
//                 controller: firstNameController,
//               ),
//               const SizedBox(height: 20),
//               CustomInputField(
//                 hintText: "Last Name",
//                 controller: lastNameController,
//               ),
//               const SizedBox(height: 20),
//               CustomInputField(
//                 hintText: "Email",
//                 controller: emailController,
//               ),
//
//               const SizedBox(height: 20),
//               CustomInputField(
//                 hintText: "Password",
//                 controller: passwordController,
//                 obscureText: true,
//               ),
//               const SizedBox(height: 20),
//               CustomInputField(
//                 hintText: "Confirm Password",
//                 controller: confirmPasswordController,
//                 obscureText: true,
//               ),
//               const SizedBox(height: 20),
//               CustomButton(
//                 text: "Register",
//                 backgroundColor: const Color(0xFF1E232C),
//                 textColor: Colors.white,
//                 onPressed: registerUser, // Register user when the button is pressed
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Expanded(child: Divider(color: Colors.grey.shade300)),
//                   const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Text(
//                       "Or Register with",
//                       style: TextStyle(
//                         fontFamily: 'Urbanist',
//                         fontWeight: FontWeight.w600,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ),
//                   Expanded(child: Divider(color: const Color(0xFFE8ECF4))),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               // Social media login buttons (Google, Facebook, etc.)
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
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


  final String apiUrl = 'http://10.0.2.2:3000/user/register';

  // Error message state variables
  String? passwordError;
  String? emailError;
  String? generalError;
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

      // Handle the response from the backend
      if (response.statusCode == 200) {
        // If the registration was successful
        print("Registration successful!");

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Registration successful! Please log in.'),
          backgroundColor: Colors.green,
        ));

        // Navigate to login page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Mainlogin()),
        );
      } else {
        // Parse the error response
        Map<String, dynamic> errorResponse = {};
        try {
          errorResponse = json.decode(response.body);
        } catch (e) {
          print("Error parsing response: $e");
        }

        // Handle specific error cases
        if (response.statusCode == 409) {
          // User already exists
          setState(() {
            emailError = "Email already registered. Please use a different email or login.";
          });
        } else if (errorResponse.containsKey('message')) {
          // Show the specific error message from the backend
          setState(() {
            generalError = errorResponse['message'];
          });
        } else {
          // Generic error
          setState(() {
            generalError = "Registration failed. Please try again later.";
          });
        }

        print("Failed to register. Error: ${response.body}");
      }
    } catch (e) {
      // Hide loading indicator
      setState(() {
        isLoading = false;
        generalError = "Network error. Please check your connection and try again.";
      });
      print("Exception occurred: $e");
    }
  }

  // Empty function to use when button should be disabled
  void _doNothing() {
    // This function intentionally does nothing
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
                backgroundColor: isLoading ? Colors.grey : const Color(0xFF1E232C),
                textColor: Colors.white,
                onPressed: isLoading ? _doNothing : registerUser, // Use a dummy function instead of null
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