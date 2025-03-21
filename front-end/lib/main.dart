import 'package:flutter/material.dart';
import 'package:fynaura/pages/Analize/analyze_page.dart';
import 'dart:async';
import 'package:fynaura/pages/log-in/mainLogin.dart';
import 'package:fynaura/pages/sign-up/mainSignUp.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        // MaterialPageRoute(builder: (context) => AnalyzePage()),
        MaterialPageRoute(builder: (context) => Mainsignup()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF85C1E5), // Set the background color
      body: Center(
        child: Image.asset('images/fynaura.png'),
      ),
    );
  }
}
void requestAlarmPermission() async {
  if (await Permission.scheduleExactAlarm.isDenied) {
    await Permission.scheduleExactAlarm.request();
  }
}