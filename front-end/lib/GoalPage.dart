import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'goal_editor_page.dart'; // Correct import for GoalEditorPage

class GoalPage extends StatefulWidget {
  final int auraPoints;
  final Function(int) onUpdatePoints;

  GoalPage({required this.auraPoints, required this.onUpdatePoints});

  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  int auraPoints = 0;
  List<String> goals = [];
  List<int> progressLevels = [];

  @override
  void initState() {
    super.initState();
    auraPoints = widget.auraPoints;
    _loadGoals();  // Load saved goals when the page is initialized
  }

  // Load goals from shared preferences
  _loadGoals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      goals = prefs.getStringList('goals') ?? ["Login to the app", "Invite friends to the app", "Save for a bicycle"];
      progressLevels = List<int>.from(prefs.getStringList('progressLevels')?.map(int.parse) ?? [1, 1, 1]);
    });
  }

  // Navigate to Goal Editor Page
  _goToGoalEditor() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GoalEditorPage()),
    );
    _loadGoals();  // Reload the goals after editing
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Goals"),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _goToGoalEditor,  // Go to Goal Editor when clicked
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Aura Points: $auraPoints", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text("Your Goals", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),

            // Display each goal in the list with progress bar
            Expanded(
              child: ListView.builder(
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      title: Text(goals[index]),
                      subtitle: Text("Progress Levels: ${progressLevels[index]}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Progress Bar for the goal
                          Container(
                            width: 100,
                            height: 5,
                            color: Colors.grey[300],
                            child: LinearProgressIndicator(
                              value: progressLevels[index] / 5,  // Assuming max progress level is 5
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          ),
                          SizedBox(width: 8),
                          // Points indicator for this goal
                          Text("${progressLevels[index] * 50} points"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Save the goals to shared preferences
  _saveGoals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('goals', goals);
    await prefs.setStringList('progressLevels', progressLevels.map((e) => e.toString()).toList());
  }
}
