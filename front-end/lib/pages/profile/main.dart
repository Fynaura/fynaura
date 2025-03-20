import 'package:flutter/material.dart';
import 'ProfilePage.dart'; // Import ProfilePage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfilePage(), // Start with ProfilePage
    );
  }
}
