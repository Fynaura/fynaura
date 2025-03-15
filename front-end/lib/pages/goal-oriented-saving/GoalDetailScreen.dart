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

  // Method to prompt user for the amount to add
  Future<void> _addAmount() async {
    TextEditingController _amountController = TextEditingController();

    // Show an alert dialog for the user to input the amount
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Amount"),
          content: TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Amount',
              hintText: 'Enter the amount to add',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without adding anything
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Get the value from the input
                double amountToAdd = double.tryParse(_amountController.text) ?? 0.0;

                if (amountToAdd > 0) {
                  // Update the savedAmount with the entered value
                  setState(() {
                    goal.savedAmount += amountToAdd;
                    // Add a transaction to history
                    goal.history.add(Transaction(amount: amountToAdd, date: DateTime.now(), isAdded: true));
                  });
                }
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
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
                  onPressed: () {
                    // Show dialog to input amount when "+" is clicked
                    _addAmount();
                  },
                ),
                SizedBox(width: 20),
                IconButton(
                  icon: Icon(Icons.remove, color: Colors.red, size: 30),
                  onPressed: () {
                    // You can implement subtract functionality here (optional)
                  },
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
