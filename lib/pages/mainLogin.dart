import 'package:flutter/material.dart';
import '../widgets/CustomButton.dart';
import '../widgets/backBtn.dart';

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
        leading: CustomBackButton(), // Use your custom back button
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image at the top
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0), // Adjust top padding
                child: Image.asset(
                  "images/fynaura-icon.png",
                  height: 120, // Adjust the height of the image
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Additional widgets or text can go here
            Center(
              child: Text(
                "Welcome Back !",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

