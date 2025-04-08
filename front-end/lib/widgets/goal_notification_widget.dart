import 'package:flutter/material.dart';
import 'package:fynaura/pages/goal-oriented-saving/model/Goal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoalNotificationWidget extends StatefulWidget {
  final Goal goal;

  const GoalNotificationWidget({Key? key, required this.goal}) : super(key: key);

  @override
  _GoalNotificationWidgetState createState() => _GoalNotificationWidgetState();
}

class _GoalNotificationWidgetState extends State<GoalNotificationWidget> {
  bool _isLoading = true;
  Map<String, dynamic> _notificationData = {};
  final String baseUrl = 'http://192.168.8.172:3000/goals/notifications'; // Update with your server URL

  @override
  void initState() {
    super.initState();
    _fetchNotificationData();
  }

  Future<void> _fetchNotificationData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/${widget.goal.id}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _notificationData = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        print('Failed to fetch notification data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching notification data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Color(0xFF254e7a),
        ),
      );
    }

    // Check if there's notification data and days remaining
    final hasData = _notificationData.containsKey('daysRemaining');
    final daysRemaining = hasData ? _notificationData['daysRemaining'] as int : 0;
    final amountNeeded = hasData ? _notificationData['amountNeeded'] as double : 0.0;

    // Don't show anything if goal is completed or no days remaining
    if (widget.goal.isCompleted || !hasData || daysRemaining <= 0) {
      return SizedBox.shrink(); // Return empty widget
    }

    // Determine urgency level based on days remaining
    Color urgencyColor = Colors.green;
    String urgencyText = "On Track";
    IconData urgencyIcon = Icons.check_circle;

    if (daysRemaining <= 3) {
      urgencyColor = Colors.red;
      urgencyText = "Critical!";
      urgencyIcon = Icons.warning;
    } else if (daysRemaining <= 7) {
      urgencyColor = Colors.orange;
      urgencyText = "Urgent";
      urgencyIcon = Icons.access_time;
    }

    // Calculate daily saving needed
    final dailySavingNeeded = daysRemaining > 0 ? (amountNeeded / daysRemaining) : amountNeeded;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            urgencyColor.withOpacity(0.8),
            urgencyColor.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: urgencyColor.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                urgencyIcon,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                urgencyText,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            daysRemaining == 1
                ? "Your goal is due tomorrow!"
                : "Your goal is due in $daysRemaining days",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "You still need: LKR ${amountNeeded.toStringAsFixed(2)}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Daily saving needed: LKR ${dailySavingNeeded.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  // Navigate to add amount screen or show add amount dialog
                  // This will depend on your app's navigation
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                ),
                child: Text('Add Now'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}