import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CustomBackButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Navigator.of(context).pop(),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white, // Filled background
          border: Border.all(
            color: const Color(0xFFE8ECF4), // Outline color
            width: 2, // Thickness of the outline
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.arrow_back,
            color: Colors.black, // Icon color
          ),
        ),
      ),
    );
  }
}
