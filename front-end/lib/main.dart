// Modify front-end/lib/main.dart

import 'package:flutter/material.dart';
import 'package:fynaura/pages/Analize/analyze_page.dart';
import 'dart:async';
import 'package:fynaura/pages/log-in/mainLogin.dart';
import 'package:fynaura/pages/sign-up/mainSignUp.dart';
import 'package:fynaura/pages/home/main_screen.dart'; // Add this import
import 'package:fynaura/pages/user-session/UserSession.dart'; // Add this import
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Add this line
  initializeTimeZone(); // Initialize time zones globally
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);  // Add const constructor here

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),  // Set the home screen to the SplashScreen
    );
  }
}

// Function to initialize time zones
void initializeTimeZone() {
  tz.initializeTimeZones(); // Load all time zones
  tz.setLocalLocation(
      tz.getLocation("Asia/Kolkata")); // Change to your preferred default
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    requestAlarmPermission();  // Request permission when app starts
    _checkLoginStatus(); // Check if user is already logged in
  }

  // Add method to check login status
  Future<void> _checkLoginStatus() async {
    final userSession = UserSession();
    bool isLoggedIn = await userSession.loadUserData();

    // Give a short delay for splash screen to be visible
    await Future.delayed(Duration(seconds: 2));

    if (isLoggedIn) {
      // User is already logged in, go to MainScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } else {
      // User is not logged in, go to SignUp screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Mainsignup()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF85C1E5),  // Set the background color
      body: Center(
        child: Image.asset('images/fynaura.png'),  // Display the splash screen image
      ),
    );
  }
}


void requestAlarmPermission() async {
  if (await Permission.scheduleExactAlarm.isDenied) {
    await Permission.scheduleExactAlarm.request();
  }
}