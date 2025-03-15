import 'package:flutter/material.dart';
import 'AddGoalScreen.dart';
import 'GoalDetailScreen.dart';

class Goal {
  String name;
  double targetAmount;
  double savedAmount;
  DateTime startDate;
  DateTime endDate;
  bool isCompleted;
  String? image;  // Add this line to store the image URL or path
  List<Transaction> history;

  Goal({
    required this.name,
    required this.targetAmount,
    this.savedAmount = 0,
    required this.startDate,
    required this.endDate,
    this.isCompleted = false,
    this.image,
    List<Transaction>? history,
  }) : history = history ?? [];
}

class Transaction {
  final double amount;
  final DateTime date;
  final bool isAdded;

  Transaction({required this.amount, required this.date, required this.isAdded});
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
    goals = widget.goals;  // Assuming widget.goals is passed correctly
  }

  void _addGoal(Goal goal) {
    setState(() {
      goals.add(goal);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Goals'),
        backgroundColor: Color(0xFF254e7a),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Goals',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Goal List
            Expanded(
              child: ListView.builder(
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  final goal = goals[index];
                  double progress = (goal.savedAmount / goal.targetAmount).clamp(0.0, 1.0);

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      leading: goal.image != null // Display image if available
                          ? CircleAvatar(
                        backgroundImage: NetworkImage(goal.image!), // Use image URL here
                        radius: 30,
                      )
                          : Icon(Icons.image, size: 40), // Placeholder image
                      title: Text(goal.name, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Target: \$${goal.targetAmount.toStringAsFixed(2)}'),
                          Text('Saved: \$${goal.savedAmount.toStringAsFixed(2)}'),
                          LinearProgressIndicator(value: progress, minHeight: 10),
                          SizedBox(height: 5),
                          Text(
                            'Progress: ${(progress * 100).toStringAsFixed(1)}%',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      trailing: goal.isCompleted
                          ? Icon(Icons.check_circle, color: Colors.green)
                          : Icon(Icons.arrow_forward, color: Colors.blue),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GoalDetailScreen(goal: goal),
                          ),
                        ).then((updatedGoal) {
                          if (updatedGoal != null) {
                            setState(() {
                              goals[index] = updatedGoal;
                            });
                          }
                        });
                      },
                    ),
                  );
                },
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

                  if (newGoal != null) {
                    setState(() {
                      goals.add(newGoal);
                    });
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
}

