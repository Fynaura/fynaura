import 'package:flutter/material.dart';

class GoalPage extends StatefulWidget {
  final int auraPoints;
  final Function(int) onUpdatePoints;

  GoalPage({required this.auraPoints, required this.onUpdatePoints});

  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  int auraPoints = 0;

  // Progress values for each goal (initially 0, will increase as goals are completed)
  double loginProgress = 0.0;
  double inviteProgress = 0.0;
  double saveProgress = 0.0;

  @override
  void initState() {
    super.initState();
    auraPoints = widget.auraPoints;
  }

  // Function to show the progress bar for each goal
  void _completeGoal(String goal, double goalProgress) {
    setState(() {
      // Update the goal's progress to 100%
      if (goal == "Login to the app") {
        loginProgress = 1.0;
      } else if (goal == "Invite friends to the app") {
        inviteProgress = 1.0;
      } else if (goal == "Save for a bicycle") {
        saveProgress = 1.0;
      }
      auraPoints += 50; // Add points after goal completion
    });

    widget.onUpdatePoints(auraPoints); // Update profile points

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$goal Completed! You earned 50 Aura points!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Goals")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Aura Points: $auraPoints", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text("Your Goals", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),

            // Goal 1: Login
            ListTile(
              title: Text("Login to the app"),
              trailing: ElevatedButton(
                onPressed: () => _completeGoal("Login to the app", loginProgress),
                child: Text("Complete"),
              ),
            ),
            LinearProgressIndicator(
              value: loginProgress,  // Show progress for this goal
              backgroundColor: Colors.grey[200],
              color: Colors.green,
            ),

            SizedBox(height: 10),

            // Goal 2: Invite Friends
            ListTile(
              title: Text("Invite friends to the app"),
              trailing: ElevatedButton(
                onPressed: () => _completeGoal("Invite friends to the app", inviteProgress),
                child: Text("Complete"),
              ),
            ),
            LinearProgressIndicator(
              value: inviteProgress,  // Show progress for this goal
              backgroundColor: Colors.grey[200],
              color: Colors.green,
            ),

            SizedBox(height: 10),

            // Goal 3: Save for Bicycle
            ListTile(
              title: Text("Save for a bicycle"),
              trailing: ElevatedButton(
                onPressed: () => _completeGoal("Save for a bicycle", saveProgress),
                child: Text("Complete"),
              ),
            ),
            LinearProgressIndicator(
              value: saveProgress,  // Show progress for this goal
              backgroundColor: Colors.grey[200],
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
