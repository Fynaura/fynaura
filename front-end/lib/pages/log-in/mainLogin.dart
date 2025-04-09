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

    // Password visibility state
    bool _isPasswordVisible = false;

    final String apiUrl =
        'http://192.168.110.53:3000/user/login'; // API endpoint for login

    String? emailError;
    String? passwordError;
    String? generalError;
    bool isLoading = false;

    String? get currentUserId => userId;

    // Toggle password visibility
    void _togglePasswordVisibility() {
      setState(() {
        _isPasswordVisible = !_isPasswordVisible;
      });
    }

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
    // Updated loginUser method to correctly handle successful login responses
Future<void> loginUser() async {
  if (!validateForm()) {
    return;
  }

  setState(() {
    isLoading = true;
    emailError = null;
    passwordError = null;
    generalError = null;
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

    // Print response for debugging
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    // Parse the response
    Map<String, dynamic> responseData;
    try {
      responseData = json.decode(response.body);
    } catch (e) {
      setState(() {
        generalError = "Invalid response from server";
      });
      return;
    }


    // Handle successful response - check for idToken which indicates successful login
    if (response.statusCode == 200 || responseData.containsKey('idToken')) {
      String? idToken = responseData['idToken'];
      
      if (idToken != null) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Login Successful',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Color(0xFF254e7a),
          ),

        );

        // Fetch user details
        try {
          final userDetailsResponse = await http.get(
            Uri.parse('http://192.168.110.53:3000/user/me?idToken=$idToken'),
            headers: {"Authorization": "Bearer $idToken"},
          );

          final userDetails = json.decode(userDetailsResponse.body);
          final userSession = UserSession();
          
          if (userDetails != null) {
            userSession.userId = userDetails['uid'];
            userSession.displayName = userDetails['displayName'];
            userSession.email = userDetails['email'];

            // Save the session data for persistence
            await userSession.saveUserData();
            
            // Set the global user ID
            userId = userDetails['uid'];

            // Navigate after a short delay
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(),
                ),
                    (Route<dynamic> route) => false, // This ensures no previous routes are kept in the stack
              );
            });

          } else {
            setState(() {
              generalError = 'Failed to fetch user details.';
            });
          }
        } catch (e) {
          setState(() {
            generalError = "Error fetching user details. Please try again.";
          });
          print("Error fetching user details: $e");
        }
      } else {
        setState(() {
          generalError = "Login response missing authentication token";
        });
      }
    } else {
      // Handle login failure
      if (responseData.containsKey('message')) {
        final errorMessage = responseData['message'].toString();
        
        if (errorMessage.contains('INVALID_LOGIN_CREDENTIALS') || 
            errorMessage.contains('auth/wrong-password') ||
            errorMessage.contains('auth/invalid-credential')) {
          setState(() {
            passwordError = "Password is incorrect";
          });
        } else if (errorMessage.contains('auth/user-not-found') || 
                  errorMessage.contains('EMAIL_NOT_FOUND')) {
          setState(() {
            emailError = "No account found with this email";
          });
        } else {
          setState(() {
            generalError = errorMessage;
          });
        }
      } else {
        setState(() {
          generalError = "Login failed. Please try again later.";
        });
      }
    }
  } catch (e) {
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
                  obscureText: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Color(0xFF8391A1),
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
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