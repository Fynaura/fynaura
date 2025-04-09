import 'package:flutter/material.dart';
import 'package:fynaura/services/goal_notification_service.dart';
import 'dart:async';

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();
  final GoalNotificationService _notificationService = GoalNotificationService();
  bool _initialized = false;
  Timer? _dailyCheckTimer;
  
  // Singleton pattern
  factory NotificationManager() {
    return _instance;
  }
  
  NotificationManager._internal();
  
  // Initialize the notification manager
  Future<void> initialize(BuildContext? context) async {
    if (_initialized) return;
    
    print('📱 Notification Manager: Initializing...');
    
    // Initialize notification service
    await _notificationService.initialize();
    
    // Check for notifications immediately on app start
    await _checkNotifications();
    
    // Set up a periodic check every 12 hours while the app is running
    // This is a simpler alternative to Workmanager
    _scheduleDailyCheck();
    
    _initialized = true;
    print('📱 Notification Manager: Initialized successfully');
  }
  
  void _scheduleDailyCheck() {
    // Cancel any existing timer
    _dailyCheckTimer?.cancel();
    
    // Create a new timer that checks every 12 hours
    _dailyCheckTimer = Timer.periodic(
      Duration(hours: 12),
      (timer) async {
        print('📱 Notification Manager: Running scheduled check');
        await _checkNotifications();
      },
    );
    
    print('📱 Notification Manager: Scheduled periodic checks (every 12 hours)');
  }
  
  // Check for notifications
  Future<void> _checkNotifications() async {
    print('📱 Notification Manager: Checking notifications');
    
    // Check if we should check for notifications
    if (await _notificationService.shouldCheckNotifications()) {
      print('📱 Notification Manager: Time to check notifications');
      await _notificationService.checkAndScheduleGoalNotifications();
    } else {
      print('📱 Notification Manager: Skipping check (checked recently)');
    }
  }
  
  // Manually trigger notification check (can be called from UI)
  Future<void> checkNotifications() async {
    print('📱 Notification Manager: Manual check triggered');
    await _notificationService.forceCheckNotifications();
  }
  
  // Send a test notification
  Future<void> sendTestNotification() async {
    print('📱 Notification Manager: Sending test notification');
    await _notificationService.sendTestNotification();
  }
  
  // Test 90% progress notification
  Future<void> testProgressNotification(String goalName, double progress, double amountNeeded) async {
    print('📱 Notification Manager: Testing progress notification');
    await _notificationService.testProgressNotification(goalName, progress, amountNeeded);
  }
  
  // Clean up resources
  void dispose() {
    _dailyCheckTimer?.cancel();
    print('📱 Notification Manager: Disposed');
  }
  
  // Add to Settings/Profile page
  Widget buildNotificationTestButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navigate to the TestNotificationScreen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => _buildTestNotificationDialog(context),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF254e7a),
        foregroundColor: Colors.white,
      ),
      child: Text('Test Goal Notifications'),
    );
  }
  
  // Simple dialog for testing notifications
  Widget _buildTestNotificationDialog(BuildContext context) {
    return AlertDialog(
      title: Text('Test 90% Progress Notification'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('This will send a test notification for a goal that is 90% complete.'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await testProgressNotification(
                'Test Goal',
                90.0,
                10000.0,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Test notification sent!')),
              );
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
            ),
            child: Text('Send Test Notification'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}