import 'package:flutter/material.dart';

class ExtractedTextScreen extends StatelessWidget {
  final String text;

  const ExtractedTextScreen({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.blue[300],
        backgroundColor: Colors.grey[200],
        title: const Text("Extracted Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Text(
            text,
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
