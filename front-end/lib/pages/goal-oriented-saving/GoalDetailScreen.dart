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
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF254e7a)),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without adding anything
              },
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                double amountToAdd = double.tryParse(_amountController.text) ?? 0.0;

                if (amountToAdd > 0) {
                  setState(() {
                    goal.savedAmount += amountToAdd;
                    goal.history.add(Transaction(amount: amountToAdd, date: DateTime.now(), isAdded: true));

                    if (goal.savedAmount >= goal.targetAmount) {
                      goal.isCompleted = true;
                    }
                  });
                }
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Add', style: TextStyle(color: Color(0xFF254e7a))),
            ),
          ],
        );
      },
    );
  }

  // Method to prompt user for the amount to subtract
  Future<void> _subtractAmount() async {
    TextEditingController _amountController = TextEditingController();

    // Show an alert dialog for the user to input the amount
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Subtract Amount"),
          content: TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Amount',
              hintText: 'Enter the amount to subtract',
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF254e7a)),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without subtracting anything
              },
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                double amountToSubtract = double.tryParse(_amountController.text) ?? 0.0;

                if (amountToSubtract > 0 && goal.savedAmount - amountToSubtract >= 0) {
                  setState(() {
                    goal.savedAmount -= amountToSubtract;
                    goal.history.add(Transaction(amount: amountToSubtract, date: DateTime.now(), isAdded: false));

                    if (goal.savedAmount >= goal.targetAmount) {
                      goal.isCompleted = true;
                    }
                  });
                } else if (amountToSubtract <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter a positive amount")));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Cannot subtract more than current progress")));
                }
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Subtract', style: TextStyle(color: Color(0xFF254e7a))),
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
      body: SingleChildScrollView( // Wrap the entire body content in a SingleChildScrollView
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder with rounded corners
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Icon(Icons.image, size: 100, color: Colors.grey[600])),
            ),
            SizedBox(height: 20),

            // Goal progress section with rounded progress bar
            Text(
              'Progress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.grey[300],
                color: goal.isCompleted ? Colors.green : Color(0xFF254e7a),
              ),
            ),
            SizedBox(height: 10),
            Text(
              '\$${goal.savedAmount.toStringAsFixed(2)} / \$${goal.targetAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            // Display 'Completed' message if the goal is finished
            if (goal.isCompleted)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'Goal Completed!',
                  style: TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),

            // Action buttons for adding and subtracting money
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Floating action button for adding money
                  FloatingActionButton(
                    onPressed: _addAmount,
                    backgroundColor: Color(0xFF254e7a),
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                  SizedBox(width: 30),
                  // Floating action button for subtracting money
                  FloatingActionButton(
                    onPressed: _subtractAmount,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.remove, color: Colors.white),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Transaction history section with a modern card design
            Text(
              'History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // Added padding to avoid overflow
            SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.height * 0.3, // Ensure the history section is scrollable
              child: ListView.builder(
                itemCount: goal.history.length,
                itemBuilder: (context, index) {
                  // Reversed list: this ensures that the most recent transaction is displayed at the top
                  final transaction = goal.history.reversed.toList()[index];

                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      title: Text(
                        '\$${transaction.amount.toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(transaction.date.toString()),
                      trailing: Icon(
                        transaction.isAdded ? Icons.add_circle : Icons.remove_circle,
                        color: transaction.isAdded ? Colors.green : Colors.red,
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
}
