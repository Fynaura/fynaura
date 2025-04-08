import 'package:flutter/material.dart';
import 'package:fynaura/pages/Analize/analyze_page.dart';
import 'dart:async';
import 'package:fynaura/pages/log-in/mainLogin.dart';
import 'package:fynaura/pages/sign-up/mainSignUp.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:fynaura/services/notification_manager.dart';

void main() {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  initializeTimeZone(); // Initialize time zones globally
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      tz.getLocation("Asia/Colombo")); // Set to Sri Lanka time zone
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }
  
  Future<void> _initialize() async {
    // Request required permissions
    await requestPermissions();
    
    // Navigate to the next screen after a 5-second delay
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Mainsignup()), // Navigate to SignUp page after 5 seconds
      );
    });
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Initialize the NotificationManager after the context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationManager().initialize(context);
    });
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

Future<void> requestPermissions() async {
  // Request notification permission
  await Permission.notification.request();
  
  // Request exact alarms permission (for scheduling notifications)
  if (await Permission.scheduleExactAlarm.isDenied) {
    await Permission.scheduleExactAlarm.request();
  }
}