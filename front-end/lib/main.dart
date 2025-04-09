import 'package:flutter/material.dart';
import 'package:fynaura/pages/Analize/analyze_page.dart';
import 'dart:async';
import 'package:fynaura/pages/log-in/mainLogin.dart';
import 'package:fynaura/pages/sign-up/mainSignUp.dart';
import 'package:fynaura/pages/home/main_screen.dart';
import 'package:fynaura/pages/user-session/UserSession.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:fynaura/services/notification_manager.dart';
import 'package:fynaura/services/goal_notification_service.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize time zones globally
  await initializeTimeZone();
  
  // Initialize notification service early
  final notificationManager = NotificationManager();
  await notificationManager.initialize(null);
  
  // Request permissions at app startup
  await requestPermissions();

  runApp(MyApp());
}

// Function to initialize time zones
Future<void> initializeTimeZone() async {
  tz.initializeTimeZones(); // Load all time zones
  tz.setLocalLocation(
      tz.getLocation("Asia/Colombo")); // Set to Sri Lanka time zone
  print('🕒 Time zones initialized: Asia/Colombo');
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
    // Request alarm permission
    await requestAlarmPermission();

    // Initialize notifications
    final notificationManager = NotificationManager();
    await notificationManager.initialize(null);

    // Check login status
    final userSession = UserSession();
    bool isLoggedIn = await userSession.loadUserData();

    // Wait for 2-3 seconds to show splash screen
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Initialize the NotificationManager after the context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationManager().initialize(context);
      
      // Check for goal notifications that might be at 90%
      _checkForGoalNotifications();
    });
  }
  
  Future<void> _checkForGoalNotifications() async {
    try {
      final notificationManager = NotificationManager();
      await notificationManager.checkNotifications();
      print('📱 Initial notification check complete');
    } catch (e) {
      print('Error checking notifications: $e');
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

Future<void> requestPermissions() async {
  // Request notification permission
  final notificationStatus = await Permission.notification.request();
  print('📱 Notification permission status: $notificationStatus');
  
  // Request exact alarms permission (for scheduling notifications)
  if (await Permission.scheduleExactAlarm.isDenied) {
    final alarmStatus = await Permission.scheduleExactAlarm.request();
    print('📱 Schedule exact alarm permission status: $alarmStatus');
  }
}

Future<void> requestAlarmPermission() async {
  // Request notification permission
  final notificationStatus = await Permission.notification.request();
  print('📱 Notification permission status: $notificationStatus');
  
  // Request exact alarms permission (for scheduling notifications)
  if (await Permission.scheduleExactAlarm.isDenied) {
    final alarmStatus = await Permission.scheduleExactAlarm.request();
    print('📱 Schedule exact alarm permission status: $alarmStatus');
  }
}