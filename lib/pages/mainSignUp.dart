import 'package:flutter/material.dart';
import 'package:fynaura/pages/mainLogin.dart';
import '../widgets/CustomButton.dart';
import '../widgets/backBtn.dart';
import 'package:fynaura/pages/forgotPwFirst.dart';
import '../widgets/customInput.dart';

class Mainsignup extends StatefulWidget {
  const Mainsignup({super.key});

  @override
  State<Mainsignup> createState() => _MainSignupState();
}

class _MainSignupState extends State<Mainsignup> {
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


              // Subtext
              // const Text(
              //   "Enter your email and password to login",
              //   style: TextStyle(
              //     fontFamily: 'Urbanist',
              //     fontWeight: FontWeight.w600,
              //     fontSize: 14,
              //     color: const Color(0xFF6A707C),
              //   ),
              // ),
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
                    onPressed: () {   Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Mainlogin()),
                    );},
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
                hintText: "Username",
                controller: TextEditingController(),
              ),
              const SizedBox(height: 20),
              // Email Input
              CustomInputField(
                hintText: "Email",
                controller: TextEditingController(),
              ),
              const SizedBox(height: 20),

              // Forgot Password
              CustomInputField(
                hintText: "Password",
                controller: TextEditingController(),
                obscureText: true, // This will obscure the text for password input
              ),
              const SizedBox(height: 20),
              CustomInputField(
                hintText: "Confirm your Password",
                controller: TextEditingController(),
                obscureText: true, // This will obscure the text for password input
              ),
              // Forgot Password
         
              const SizedBox(height: 20),


              CustomButton(
                text: "Register",
                backgroundColor: const Color(0xFF1E232C),
                textColor: Colors.white,
                onPressed: () {
                  print("Login pressed,open home");
                },
              ),
              const SizedBox(height: 180),


              // OR Divider
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




            ],
          ),
        ),
      ),
    );
  }
}
