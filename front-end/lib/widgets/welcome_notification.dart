// welcome_notification.dart
import 'package:flutter/material.dart';

class WelcomeNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green,  // Customize the color
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'Welcome to the FynAura App!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
