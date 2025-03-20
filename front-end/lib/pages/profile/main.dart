import 'package:flutter/material.dart';
import 'ProfilePage.dart';  // Correct import for ProfilePage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Financial Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfilePage(),  // Set ProfilePage as the home page
    );
  }
}
