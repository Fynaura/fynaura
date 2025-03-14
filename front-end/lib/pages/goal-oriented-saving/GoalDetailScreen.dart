import 'package:flutter/material.dart';
import 'GoalPage.dart';

class GoalDetailScreen extends StatefulWidget {
  final Goal goal;

  GoalDetailScreen({required this.goal});

  @override
  _GoalDetailScreenState createState() => _GoalDetailScreenState();
}

class _GoalDetailScreenState extends State<GoalDetailScreen> {
  late Goal goal;

  @override
  void initState() {
    super.initState();
    goal = widget.goal;
  }

  void _updateAmount(double amount, bool isAdded) {
    setState(() {
      if (isAdded) {
        goal.savedAmount += amount;
      } else {
        goal.savedAmount = (goal.savedAmount - amount).clamp(0, goal.targetAmount);
      }
      goal.history.add(Transaction(amount: amount, date: DateTime.now(), isAdded: isAdded));
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = (goal.savedAmount / goal.targetAmount).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(goal.name),
        backgroundColor: Color(0xFF254e7a),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, goal);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Placeholder
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Icon(Icons.image, size: 100, color: Colors.grey[600])),
            ),
            SizedBox(height: 10),

            // Progress
            Text(
              'Progress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            LinearProgressIndicator(value: progress, minHeight: 10),
            SizedBox(height: 10),
            Text(
              '\$${goal.savedAmount.toStringAsFixed(2)} / \$${goal.targetAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.add, color: Colors.green, size: 30),
                  onPressed: () => _updateAmount(100, true),
                ),
                SizedBox(width: 20),
                IconButton(
                  icon: Icon(Icons.remove, color: Colors.red, size: 30),
                  onPressed: () => _updateAmount(100, false),
                ),
              ],
            ),

            SizedBox(height: 20),

            // History
            Text(
              'History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: goal.history.length,
                itemBuilder: (context, index) {
                  final transaction = goal.history[index];
                  return ListTile(
                    title: Text('\$${transaction.amount.toStringAsFixed(2)}'),
                    subtitle: Text(transaction.date.toString()),
                    trailing: Icon(
                      transaction.isAdded ? Icons.add_circle : Icons.remove_circle,
                      color: transaction.isAdded ? Colors.green : Colors.red,
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
}
