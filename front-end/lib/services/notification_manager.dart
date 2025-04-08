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
  Future<void> initialize(BuildContext context) async {
    if (_initialized) return;
    
    // Initialize notification service
    await _notificationService.initialize();
    
    // Check for notifications immediately on app start
    await _checkNotifications();
    
    // Set up a periodic check every 12 hours while the app is running
    // This is a simpler alternative to Workmanager
    _scheduleDailyCheck();
    
    _initialized = true;
  }
  
  void _scheduleDailyCheck() {
    // Cancel any existing timer
    _dailyCheckTimer?.cancel();
    
    // Create a new timer that checks every 12 hours
    _dailyCheckTimer = Timer.periodic(
      Duration(hours: 12),
      (timer) async {
        await _checkNotifications();
      },
    );
  }
  
  // Check for notifications
  Future<void> _checkNotifications() async {
    // Check if we should check for notifications
    if (await _notificationService.shouldCheckNotifications()) {
      await _notificationService.checkAndScheduleGoalNotifications();
    }
  }
  
  // Manually trigger notification check (can be called from UI)
  Future<void> checkNotifications() async {
    await _notificationService.checkAndScheduleGoalNotifications();
  }
  
  // Send a test notification
  Future<void> sendTestNotification() async {
    await _notificationService.sendTestNotification();
  }
  
  // Clean up resources
  void dispose() {
    _dailyCheckTimer?.cancel();
  }
}