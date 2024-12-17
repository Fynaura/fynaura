import 'package:flutter/material.dart';
import '../widgets/CustomButton.dart';
import '../widgets/backBtn.dart'; // Import the renamed custom button

class forgotPwSecond extends StatefulWidget {
  const forgotPwSecond({super.key});

  @override
  State<forgotPwSecond> createState() => ForgotPwSecond();
}

class ForgotPwSecond extends State<forgotPwSecond> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        leading: CustomBackButton(), // Use your custom button here
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to the Login Page!",
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            CustomBackButton(), // Use the custom button here again
          ],
        ),
      ),
    );
  }
}
