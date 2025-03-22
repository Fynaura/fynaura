import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';  // Correct import

void main() {
  runApp(MyApp());  // Run the app
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState(); // Create state for the app
}

class _MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin(); // Instance for notifications plugin

  @override
  void initState() {
    super.initState();
    _initializeNotifications(); // Initialize notifications for Android
  }

  // Method to initialize notifications for Android only
  void _initializeNotifications() async {
    // Initialize Android settings with the app icon
    var androidInitialization = AndroidInitializationSettings('app_icon');  // Specify the icon for Android

    // Combine only Android initialization settings (no iOS initialization)
    var initializationSettings = InitializationSettings(
        android: androidInitialization); // Only Android initialization

    // Initialize the plugin with Android settings
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Method to show a notification
  Future<void> _showWelcomeNotification() async {
    var androidDetails = AndroidNotificationDetails(
      'default_channel_id', // Notification channel ID
      'Default Channel', // Channel name
      channelDescription: 'This is the default channel for notifications', // Description
      importance: Importance.high, // Set importance
      priority: Priority.high, // Set priority
    );

    var generalNotificationDetails = NotificationDetails(android: androidDetails); // Set notification details

    // Show the notification
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Welcome to FynAura App!', // Notification title
      'You have successfully logged in!', // Notification body
      generalNotificationDetails, // Notification details
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FynAura',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('FynAura App'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: _showWelcomeNotification, // Trigger notification on button press
            child: Text('Show Notification'),
          ),
        ),
      ),
    );
  }
}
