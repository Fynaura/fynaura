

import 'package:fynaura/services/goal_notification_service.dart';

class GoalNotificationHelper {
  static final GoalNotificationService _notificationService = GoalNotificationService();
  static bool _isInitialized = false;

  // Initialize notification service
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    await _notificationService.initialize();
    _isInitialized = true;
    
    // Perform first notification check after initialization
    await checkNotifications();
  }
  
  // Check for notifications (can be called periodically)
  static Future<void> checkNotifications() async {
    if (!_isInitialized) {
      await initialize();
      return;
    }
    
    // Check if we should check for notifications (to prevent too frequent checks)
    final shouldCheck = await _notificationService.shouldCheckNotifications();
    if (shouldCheck) {
      await _notificationService.checkAndScheduleGoalNotifications();
    }
  }
  
  // Send a test notification for debugging
  static Future<void> sendTestNotification() async {
    if (!_isInitialized) {
      await initialize();
    }
    
    await _notificationService.sendTestNotification();
  }
}