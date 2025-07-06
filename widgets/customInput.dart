import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String hintText; // Placeholder text
  final TextEditingController? controller; // Optional: Input controller
  final bool obscureText; // For password fields
  final TextInputType keyboardType; // Type of keyboard
  final Widget? suffixIcon; // Added for eye icon

  const CustomInputField({
    Key? key,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon, // New parameter for eye icon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8F9), // Background color
        borderRadius: BorderRadius.circular(8), // Rounded corners
        border: Border.all(
          color: const Color(0xFFE8ECF4), // Border stroke color
          width: 1.0,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontFamily: 'Urbanist',
          fontWeight: FontWeight.w500,
          color: Color(0xFF8391A1),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w500,
            color: Color(0xFF8391A1), // Hint text color
          ),
          border: InputBorder.none, // Remove default border
          suffixIcon: suffixIcon, // Add the suffix icon
        ),
      ),
    );
  }
}