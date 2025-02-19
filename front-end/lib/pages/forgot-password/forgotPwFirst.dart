import 'package:flutter/material.dart';
import 'package:fynaura/pages/forgot-password/forgotPwSecond.dart';
import 'package:fynaura/widgets/CustomButton.dart';
import 'package:fynaura/widgets/backBtn.dart';
import 'package:fynaura/pages/log-in/mainLogin.dart';
import 'package:fynaura/widgets/customInput.dart';// Import the renamed custom button

class ForgotPwFirst extends StatefulWidget {
  const ForgotPwFirst({super.key});

  @override
  State<ForgotPwFirst> createState() => _ForgotPwFirstState();
}

class _ForgotPwFirstState extends State<ForgotPwFirst> {
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
                "Forgot Password?",
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),

              const SizedBox(height: 10),
              // Subtext
              const Text(
                "Please enter the email address linked to your account.",
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: const Color(0xFF6A707C),
                ),
              ),

              const SizedBox(height: 30),
              // Email Input
              CustomInputField(
                hintText: "Enter your Email",
                controller: TextEditingController(),
              ),
              const SizedBox(height: 20),

              CustomButton(
                text: "Send Code",
                backgroundColor: const Color(0xFF1E232C),
                textColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ForgotPWSecond()),
                  );
                },
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
                    onPressed: () {   Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Mainlogin()),
                    );},
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
