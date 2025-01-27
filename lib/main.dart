import 'package:flutter/material.dart';
import 'temporary_home_page.dart'; // Import the temporary home page

void main() {
  runApp(FinancialTrackerApp());
}

class FinancialTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TemporaryHomePage(), // Set the temporary home page
    );
  }
}
