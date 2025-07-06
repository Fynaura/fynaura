import 'dart:ui';

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
  final String baseUrl = 'http://192.168.110.53:3000/goals/notifications'; // Update with your server URL
  
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
    await _requestPermissions();
    
    print('🔔 Notification service initialized');
  }
  
  void _handleNotificationTap(NotificationResponse response) {
    // You can navigate to specific goal details page based on payload
    // For example, if payload contains goalId, you can navigate to that goal's detail page
    if (response.payload != null) {
      final payloadData = json.decode(response.payload!);
      // Navigator logic would go here
      print('🔔 Notification tapped with payload: ${response.payload}');
    }
  }
  
  Future<void> _requestPermissions() async {
    // Request notification permissions on Android
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
      final bool? granted = await androidImplementation.areNotificationsEnabled();
      print('🔔 Notification permissions granted: $granted');
    }
  }
  
  // Check for upcoming goal deadlines and schedule notifications
  Future<void> checkAndScheduleGoalNotifications() async {
    try {
      final userSession = UserSession();
      final userId = userSession.userId;
      
      if (userId == null) {
        print('🔔 User not logged in, cannot schedule goal notifications');
        return;
      }
      
      print('🔔 Checking notifications for user: $userId');
      
      // Get urgent goal notifications (goals with deadlines approaching)
      final response = await http.get(
        Uri.parse('$baseUrl/urgent/$userId?daysThreshold=7'),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> urgentGoals = json.decode(response.body);
        print('🔔 Found ${urgentGoals.length} urgent goals');
        
        // Clear existing scheduled notifications
        await flutterLocalNotificationsPlugin.cancelAll();
        
        int progressNotificationsCount = 0;
        int deadlineNotificationsCount = 0;
        
        // Schedule new notifications for urgent goals
        for (var goalData in urgentGoals) {
          // Check for time-based urgency (deadline approaching)
          if (goalData['isUrgentByTime'] == true && goalData['daysRemaining'] > 0) {
            // Check if we should show a notification (7 days or 3 days before)
            if (goalData['daysRemaining'] == 7 || goalData['daysRemaining'] == 3) {
              await _scheduleGoalDeadlineNotification(
                goalData['goalId'],
                goalData['goalName'],
                goalData['daysRemaining'],
                goalData['amountNeeded'],
                goalData['dailySavingNeeded'],
              );
              deadlineNotificationsCount++;
            }
          }
          
          // Check for progress-based urgency (10% remaining to reach target)
          if (goalData['progressPercentage'] != null && goalData['isUrgentByProgress'] == true) {
            double progress = goalData['progressPercentage'];
            // If progress is between 90% and 95% (just crossed the 90% threshold)
            if (progress >= 90.0 && progress < 95.0) {
              await _scheduleProgressNotification(
                goalData['goalId'],
                goalData['goalName'],
                progress,
                goalData['amountNeeded'],
              );
              progressNotificationsCount++;
              print('🔔 Scheduled progress notification for goal: ${goalData['goalName']} (${progress.toStringAsFixed(1)}%)');
            }
          }
        }
        
        print('🔔 Scheduled $deadlineNotificationsCount deadline notifications and $progressNotificationsCount progress notifications');
        
        // Save last check time
        _saveLastCheckTime();
      } else {
        print('🔔 Failed to fetch urgent goals: ${response.statusCode}');
        print('🔔 Response body: ${response.body}');
      }
    } catch (e) {
      print('🔔 Error checking goal notifications: $e');
    }
  }
  
  // Schedule deadline-based notification
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
      enableVibration: true,
      enableLights: true,
      color: Color(0xFF254e7a),
      ledColor: Color(0xFF254e7a),
      ledOnMs: 1000,
      ledOffMs: 500,
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
      'notificationType': 'deadline',
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
    
    print('🔔 Scheduled deadline notification for goal: $goalName in $daysRemaining days');
  }
  
  // Schedule progress-based notification (10% remaining)
  Future<void> _scheduleProgressNotification(
    String goalId,
    String goalName,
    double progress,
    double amountNeeded,
  ) async {
    // Create notification details
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'goal_progress_channel',
      'Goal Progress Milestones',
      channelDescription: 'Notifications for goal progress milestones',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      enableLights: true,
      color: Color(0xFF9C27B0), // Purple color for progress notifications
      ledColor: Color(0xFF9C27B0),
      ledOnMs: 1000,
      ledOffMs: 500,
    );
    
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    
    // Create notification title and body
    final String title = 'Almost there! 🎯';
    final String body = 'You\'re only ${(100 - progress).toStringAsFixed(1)}% away from completing your "$goalName" goal! Just LKR ${amountNeeded.toStringAsFixed(2)} more to go.';
    
    // Create notification payload (to pass data when notification is tapped)
    final String payload = json.encode({
      'goalId': goalId,
      'goalName': goalName,
      'progress': progress,
      'notificationType': 'progress',
    });
    
    // Generate a unique ID for progress notifications that won't conflict with deadline notifications
    final int notificationId = int.parse(goalId.hashCode.toString().substring(0, 5)) + 100000;
    
    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(Duration(seconds: 5)), // Schedule for testing (almost immediate)
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
    
    print('🔔 Scheduled progress notification for goal: $goalName at ${progress.toStringAsFixed(1)}%');
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
  
  // Force check for notifications (ignoring time limit)
  Future<void> forceCheckNotifications() async {
    print('🔔 Forcing notification check');
    await checkAndScheduleGoalNotifications();
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
      enableVibration: true,
    );
    
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    
    await flutterLocalNotificationsPlugin.show(
      0,
      'Test Notification',
      'This is a test notification from Fynaura!',
      platformChannelSpecifics,
    );
    
    print('🔔 Sent test notification');
  }
  
  // Test the 90% progress notification specifically
  Future<void> testProgressNotification(String goalName, double progress, double amountNeeded) async {
    final String testGoalId = 'test-goal-${DateTime.now().millisecondsSinceEpoch}';
    await _scheduleProgressNotification(
      testGoalId,
      goalName,
      progress,
      amountNeeded,
    );
    print('🔔 Sent test progress notification for 90% completion');
  }
}