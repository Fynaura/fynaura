import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoalEditorPage extends StatefulWidget {
  @override
  _GoalEditorPageState createState() => _GoalEditorPageState();
}

class _GoalEditorPageState extends State<GoalEditorPage> {
  List<String> goals = [];
  List<int> progressLevels = [];
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
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

  // Save the updated goals to shared preferences
  _saveGoals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('goals', goals);
    await prefs.setStringList('progressLevels', progressLevels.map((e) => e.toString()).toList());
  }

  // Function to delete a goal
  void _deleteGoal(int index) {
    setState(() {
      goals.removeAt(index);
      progressLevels.removeAt(index);
    });
    _saveGoals();  // Save updated goals after deletion
  }

  // Function to rename a goal
  void _renameGoal(int index) {
    controller.text = goals[index];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Rename Goal"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: "Goal Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  goals[index] = controller.text;
                });
                _saveGoals();  // Save updated goals
                Navigator.pop(context);
              },
              child: Text("Rename"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  // Function to change progress level for a goal
  void _setProgressLevel(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Set Progress Levels"),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Enter number of levels (max 5)"),
            onChanged: (value) {
              int? level = int.tryParse(value);
              if (level != null && level >= 0 && level <= 5) {
                setState(() {
                  progressLevels[index] = level;
                });
                _saveGoals();  // Save updated goals
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Set"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  // Function to add a new goal
  void _addGoal() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController newGoalController = TextEditingController();
        return AlertDialog(
          title: Text("Add New Goal"),
          content: TextField(
            controller: newGoalController,
            decoration: InputDecoration(labelText: "New Goal Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  goals.add(newGoalController.text);  // Add new goal to list
                  progressLevels.add(1);  // Default progress level is 1
                });
                _saveGoals();  // Save updated goals
                Navigator.pop(context);
              },
              child: Text("Add Goal"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Goal Editor")),
      body: ListView.builder(
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
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _renameGoal(index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteGoal(index),
                  ),
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () => _setProgressLevel(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGoal,  // Call the function to add a new goal
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF85C1E5),
      ),
    );
  }
}
