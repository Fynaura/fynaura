import 'package:flutter/material.dart';
import 'package:fynaura/widgets/backBtn.dart';
// Import the renamed custom button

class Scanqr extends StatefulWidget {
  const Scanqr({super.key});

  @override
  State<Scanqr> createState() => Scanqrstate();
}

class Scanqrstate extends State<Scanqr> {
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










            ],
          ),
        ),
      ),
    );
  }
}