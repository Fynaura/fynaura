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
        backgroundColor: Color(0xFF85C1E5),
        title: Text("Your Goals", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _goToGoalEditor,  // Go to Goal Editor when clicked
            tooltip: "Edit Goals",
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Aura Points: $auraPoints", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text("Your Goals", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.7))),
            SizedBox(height: 16),

            // Display each goal in a more modern way
            Expanded(
              child: ListView.builder(
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4.0,
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade200, Colors.blue.shade500],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(goals[index], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                SizedBox(height: 8),
                                Text("Progress Levels: ${progressLevels[index]}", style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          // Progress Bar
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                width: 100,
                                height: 5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade200,
                                ),
                                child: LinearProgressIndicator(
                                  value: progressLevels[index] / 5,  // Assuming max progress level is 5
                                  backgroundColor: Colors.grey.shade200,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text("${progressLevels[index] * 50} points", style: TextStyle(color: Colors.white)),
                            ],
                          ),
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
