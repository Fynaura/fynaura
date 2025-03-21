import 'package:flutter/material.dart';
import 'package:fynaura/widgets/CustomButton.dart';
import 'package:fynaura/widgets/backBtn.dart';
import 'package:fynaura/pages/log-in/mainLogin.dart';
import 'package:fynaura/widgets/customInput.dart';// Import the renamed custom button

class ForgotPWSecond extends StatefulWidget {
  const ForgotPWSecond({super.key});

  @override
  State<ForgotPWSecond> createState() => ForgotPWSecondstate();
}

class ForgotPWSecondstate extends State<ForgotPWSecond> {
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
                "Enter OTP Code",
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),

              const SizedBox(height: 10),
              // Subtext
              const Text(
                "Check your email to see the verification code",
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
                    "Didn't get the Code?",
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
                      "Send Again",
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
