import 'package:flutter/material.dart';
import 'AddGoalScreen.dart';

class Goal {
  String name;
  double amount;
  DateTime startDate;
  DateTime endDate;
  bool isCompleted;

  Goal({
    required this.name,
    required this.amount,
    required this.startDate,
    required this.endDate,
    this.isCompleted = false,
  });
}

class GoalPage extends StatefulWidget {
  final List<Goal> goals;

  GoalPage({Key? key, required this.goals}) : super(key: key);

  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  late List<Goal> goals;

  @override
  void initState() {
    super.initState();
    goals = widget.goals;
  }

  void _addGoal(Goal goal) {
    setState(() {
      goals.add(goal);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Goal> inProgressGoals = goals.where((goal) => !goal.isCompleted).toList();
    List<Goal> completedGoals = goals.where((goal) => goal.isCompleted).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Goals'),
        backgroundColor: Color(0xFF254e7a),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Goals',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            if (inProgressGoals.isNotEmpty) ...[
              Text('In Progress', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              _buildGoalList(inProgressGoals),
              SizedBox(height: 20),
            ],
            if (completedGoals.isNotEmpty) ...[
              Text('Completed', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              _buildGoalList(completedGoals),
            ],
            if (goals.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'No goals added yet!',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF254e7a),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  final newGoal = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddGoalScreen()),
                  ) as Goal?;

                  // Automatically add and display the goal if one was created
                  if (newGoal != null) {
                    _addGoal(newGoal);
                  }
                },
                child: Text(
                  'Add Goal',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalList(List<Goal> goalList) {
    return Column(
      children: goalList.map((goal) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(goal.name, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Target: \$${goal.amount.toStringAsFixed(2)}'),
            trailing: goal.isCompleted
                ? Icon(Icons.check_circle, color: Colors.green)
                : IconButton(
              icon: Icon(Icons.check, color: Colors.blue),
              onPressed: () {
                setState(() {
                  goal.isCompleted = true;
                });
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}
