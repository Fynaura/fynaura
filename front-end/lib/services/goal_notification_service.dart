
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fynaura/pages/goal-oriented-saving/model/Goal.dart';
import 'package:fynaura/pages/user-session/UserSession.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoalNotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final String baseUrl = 'http://192.168.8.172:3000/goals/notifications'; // Update with your server URL
  
  // Initialize the notification service
  Future<void> initialize() async {
    // Initialize Flutter Local Notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        _handleNotificationTap(response);
      },
    );
    
    // Initialize time zones
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Colombo')); // Set to Sri Lanka time zone
    
    // Request notification permissions
    _requestPermissions();
  }
  
  void _handleNotificationTap(NotificationResponse response) {
    // You can navigate to specific goal details page based on payload
    // For example, if payload contains goalId, you can navigate to that goal's detail page
    if (response.payload != null) {
      final payloadData = json.decode(response.payload!);
      // Navigator logic would go here
      print('Notification tapped with payload: ${response.payload}');
    }
  }
  
  Future<void> _requestPermissions() async {
    // Request notification permissions on Android
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }
  
  // Check for upcoming goal deadlines and schedule notifications
  Future<void> checkAndScheduleGoalNotifications() async {
    try {
      final userSession = UserSession();
      final userId = userSession.userId;
      
      if (userId == null) {
        print('User not logged in, cannot schedule goal notifications');
        return;
      }
      
      // Get urgent goal notifications (goals with deadlines approaching)
      final response = await http.get(
        Uri.parse('$baseUrl/urgent/$userId?daysThreshold=7'),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> urgentGoals = json.decode(response.body);
        
        // Clear existing scheduled notifications
        await flutterLocalNotificationsPlugin.cancelAll();
        
        // Schedule new notifications for urgent goals
        for (var goalData in urgentGoals) {
          if (goalData['isUrgentByTime'] && goalData['daysRemaining'] > 0) {
            // Check if we should show a notification (7 days or 3 days before)
            if (goalData['daysRemaining'] == 7 || goalData['daysRemaining'] == 3) {
              await _scheduleGoalDeadlineNotification(
                goalData['goalId'],
                goalData['goalName'],
                goalData['daysRemaining'],
                goalData['amountNeeded'],
                goalData['dailySavingNeeded'],
              );
            }
          }
        }
        
        // Save last check time
        _saveLastCheckTime();
      } else {
        print('Failed to fetch urgent goals: ${response.statusCode}');
      }
    } catch (e) {
      print('Error checking goal notifications: $e');
    }
  }
  
  // Schedule individual goal notification
  Future<void> _scheduleGoalDeadlineNotification(
    String goalId,
    String goalName,
    int daysRemaining,
    double amountNeeded,
    double dailySavingNeeded,
  ) async {
    // Create notification details
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'goal_deadline_channel',
      'Goal Deadlines',
      channelDescription: 'Notifications for upcoming goal deadlines',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );
    
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    
    // Create notification title and body
    final String title = 'Goal Deadline Approaching';
    final String body = daysRemaining == 1
        ? 'Your goal "$goalName" is due tomorrow! You still need LKR ${amountNeeded.toStringAsFixed(2)}'
        : 'Your goal "$goalName" is due in $daysRemaining days. You need LKR ${dailySavingNeeded.toStringAsFixed(2)} per day to reach your target.';
    
    // Create notification payload (to pass data when notification is tapped)
    final String payload = json.encode({
      'goalId': goalId,
      'goalName': goalName,
      'daysRemaining': daysRemaining,
    });
    
    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      int.parse(goalId.hashCode.toString().substring(0, 6)), // Use goalId hash as notification ID
      title,
      body,
      tz.TZDateTime.now(tz.local).add(Duration(seconds: 5)), // Schedule for testing (almost immediate)
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
    
    print('Scheduled notification for goal: $goalName in $daysRemaining days');
  }
  
  // Save the last time we checked for notifications
  Future<void> _saveLastCheckTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_notification_check', DateTime.now().millisecondsSinceEpoch);
  }
  
  // Check if we should check for notifications again (limit to once per day)
  Future<bool> shouldCheckNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCheck = prefs.getInt('last_notification_check');
    
    if (lastCheck == null) {
      return true; // First time checking
    }
    
    final lastCheckTime = DateTime.fromMillisecondsSinceEpoch(lastCheck);
    final now = DateTime.now();
    
    // Check if it's been at least 24 hours since last check
    return now.difference(lastCheckTime).inHours >= 24;
  }
  
  // Send a test notification (for debugging)
  Future<void> sendTestNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'test_channel',
      'Test Notifications',
      channelDescription: 'Test notification channel',
      importance: Importance.max,
      priority: Priority.high,
    );
    
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    
    await flutterLocalNotificationsPlugin.show(
      0,
      'Test Notification',
      'This is a test notification from Fynaura!',
      platformChannelSpecifics,
    );
  }
}