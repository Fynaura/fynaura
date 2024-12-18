import 'package:flutter/material.dart';
import 'package:fynaura/pages/forgotPwFirst.dart';
import 'package:fynaura/pages/mainSignUp.dart';
import '../widgets/CustomButton.dart';
import '../widgets/backBtn.dart';
import '../widgets/customInput.dart';


class Mainlogin extends StatefulWidget {
  const Mainlogin({super.key});

  @override
  State<Mainlogin> createState() => _MainloginState();
}

class _MainloginState extends State<Mainlogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(), // Custom back button
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              const SizedBox(height: 30),
              Center(
                child: Image.asset(
                  "images/fynaura-icon.png",
                  height: 120,
                ),
              ),
              const SizedBox(height: 20),

              // Welcome Back Text
              const Text(
                "Welcome back!",
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 8),

              // Subtext
              const Text(
                "Enter your email and password to login",
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: const Color(0xFF6A707C),
                ),
              ),
              const SizedBox(height: 32),

              // Email Input
              CustomInputField(
                hintText: "Enter your email",
                controller: TextEditingController(),
              ),
              const SizedBox(height: 20),

              // Forgot Password
                CustomInputField(
                  hintText: "Enter your password",
                  controller: TextEditingController(),
                  obscureText: true, // This will obscure the text for password input
                ),
              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Navigate sign up page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ForgotPwFirst()),
                    );
                    // Navigate to forgot password screen or trigger relevant functionality
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w600, // Semi-bold
                      fontSize: 14,
                      color: Color(0xFF6A707C), // Hex color #6A707C
                    ),
                  ),
                ),
              ),
                const SizedBox(height: 10),

              // Login Button
              CustomButton(
                text: "Login",
                backgroundColor: const Color(0xFF1E232C),
                textColor: Colors.white,
                onPressed: () {
                  print("Login pressed,open home");
                },
              ),
              const SizedBox(height: 20),


              // OR Divider
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
                //creates a horizontal line
                  Expanded(child: Divider(color: const Color(0xFFE8ECF4))),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Google Icon
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // Makes it round
                      border: Border.all(color: Color(0xFFEFF0F6), width: 2), // Stroke
                    ),
                    padding: EdgeInsets.all(10), // Space inside the border
                    child: Image.asset(
                      "images/google.png",
                      height: 24,
                      width: 24,
                    ),
                  ),
                  const SizedBox(width: 15), // Spacing between icons

                  // Facebook Icon
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFFEFF0F6), width: 2),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Image.asset(
                      "images/fb.png",
                      height: 24,
                      width: 24,
                    ),
                  ),
                  const SizedBox(width: 15),

                  // Apple Icon
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFFEFF0F6), width: 2),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Image.asset(
                      "images/apple.png",
                      height: 24,
                      width: 24,
                    ),
                  ),
                  const SizedBox(width: 15),

                  // Phone Icon
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFFEFF0F6), width: 2),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Image.asset(
                      "images/cellphone.png",
                      height: 24,
                      width: 24,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 100),

              // Register Now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don’t have an account?",
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  TextButton(
                    onPressed: () {   Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Mainsignup()),
                    );},
                    child: const Text(
                      "Register Now",
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

