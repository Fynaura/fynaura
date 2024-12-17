import 'package:flutter/material.dart';
import '../widgets/CustomButton.dart';
import '../widgets/backBtn.dart'; // Import the renamed custom button

class forgotPwFirst extends StatefulWidget {
  const forgotPwFirst({super.key});

  @override
  State<forgotPwFirst> createState() => ForgotPwFirst();
}

class ForgotPwFirst extends State<forgotPwFirst> {
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
