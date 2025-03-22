import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:fynaura/pages/goal-oriented-saving/model/Goal.dart';
import 'package:fynaura/pages/goal-oriented-saving/service/GoalService.dart'
as service; // Add the confetti package

// Import GoalPage for Goal class

class GoalDetailScreen extends StatefulWidget {
  final Goal goal;

  GoalDetailScreen({required this.goal});

  @override
  _GoalDetailScreenState createState() => _GoalDetailScreenState();
}

class _GoalDetailScreenState extends State<GoalDetailScreen> {
  late Goal goal;
  late ConfettiController _confettiController; // For confetti effect

  @override
  void initState() {
    super.initState();
    goal = widget.goal;
    _confettiController = ConfettiController(
        duration: const Duration(seconds: 1)); // Initialize confetti controller
  }

  // Method to prompt user for the amount to add
  Future<void> _addAmount() async {
    if (goal.isCompleted) return; // Prevent adding if goal is completed

    TextEditingController _amountController = TextEditingController();

    // Show an alert dialog for the user to input the amount
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Amount", style: TextStyle(color: Color(0xFF254e7a))),
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
                Navigator.pop(
                    context); // Close the dialog without adding anything
              },
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () async {
                double amountToAdd =
                    double.tryParse(_amountController.text) ?? 0.0;

                if (amountToAdd > 0) {
                  setState(() {
                    goal.savedAmount += amountToAdd;
                    goal.history.add(Transaction(
                        amount: amountToAdd,
                        date: DateTime.now(),
                        isAdded: true));
                    service.GoalService().addAmount(goal.id, amountToAdd);
                    service.GoalService().addTransaction(goal.id, amountToAdd, DateTime.now().toString(), true);

                  });


                  // Check if goal is completed
                  if (goal.savedAmount >= goal.targetAmount) {
                    goal.isCompleted = true;
                    _confettiController
                        .play(); // Trigger confetti animation on completion
                    // Mark the goal as completed on the backend
                    try {
                      await service.GoalService()
                          .markGoalAsCompleted(goal.id);
                    } catch (e) {
                      print('Failed to mark goal as completed: $e');
                    }

                    setState(() {});
                  };
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
    if (goal.isCompleted) return; // Prevent subtracting if goal is completed

    TextEditingController _amountController = TextEditingController();

    // Show an alert dialog for the user to input the amount
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Subtract Amount",
              style: TextStyle(color: Color(0xFF254e7a))),
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
                Navigator.pop(
                    context); // Close the dialog without subtracting anything
              },
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                double amountToSubtract =
                    double.tryParse(_amountController.text) ?? 0.0;

                if (amountToSubtract > 0 &&
                    goal.savedAmount - amountToSubtract >= 0) {

                  goal.savedAmount -= amountToSubtract;
                  goal.history.add(Transaction(
                      amount: amountToSubtract,
                      date: DateTime.now(),
                      isAdded: false));

                  // Check if goal is completed
                  if (goal.savedAmount >= goal.targetAmount) {
                    goal.isCompleted = true;
                    _confettiController
                        .play(); // Trigger confetti animation on completion
                  }

                } else if (amountToSubtract <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Please enter a positive amount")));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                      Text("Cannot subtract more than current progress")));
                }
                Navigator.pop(context); // Close the dialog
              },
              child:
              Text('Subtract', style: TextStyle(color: Color(0xFF254e7a))),
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
        title: Text(
          goal.name,
          style: TextStyle(color: Colors.white), // White text for goal name
        ),
        backgroundColor: Color(0xFF254e7a),
        leading: IconButton(
          icon:
          Icon(Icons.arrow_back, color: Colors.white), // White back button
          onPressed: () {
            Navigator.pop(context, goal);
          },
        ),
      ),
      body: SingleChildScrollView(
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
              child: Center(
                  child: Icon(Icons.image, size: 100, color: Colors.grey[600])),
            ),
            SizedBox(height: 20),

            // Enhanced Progress Bar with a Gradient and Percentage Label
            Text(
              'Progress',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF254e7a)), // Blue color
            ),
            SizedBox(height: 5),
            Container(
              width: double.infinity,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[300],
              ),
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    width: MediaQuery.of(context).size.width * progress,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF254e7a), // Start color (blue)
                          Colors.green, // End color (green)
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Center(
                    child: Text(
                      '${(progress * 100).toStringAsFixed(1)}%', // Show percentage inside the bar
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              '\$${goal.savedAmount.toStringAsFixed(2)} / \$${goal.targetAmount.toStringAsFixed(2)}',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF254e7a)), // Blue color
            ),

            // Display 'Completed' message if the goal is finished
            if (goal.isCompleted)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF254e7a), // Blue color
                        Colors.green, // Green color
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline,
                          color: Colors.white, size: 30), // Check icon
                      SizedBox(width: 10),
                      Text(
                        'Goal Completed!',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
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
                    onPressed: goal.isCompleted
                        ? null
                        : _addAmount, // Disable if goal is completed
                    backgroundColor: Color(0xFF254e7a),
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                  SizedBox(width: 30),
                  // Floating action button for subtracting money
                  FloatingActionButton(
                    onPressed: goal.isCompleted
                        ? null
                        : _subtractAmount, // Disable if goal is completed
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
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF254e7a)), // Blue color
            ),
            SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.height *
                  0.3, // Ensure the history section is scrollable
              child: ListView.builder(
                itemCount: goal.history.length,
                itemBuilder: (context, index) {
                  final transaction = goal.history[index];
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
                      subtitle: Text(transaction.date.toString(),
                          style: TextStyle(
                              color: Color(0xFF254e7a))), // Blue color
                      trailing: Icon(
                        transaction.isAdded
                            ? Icons.add_circle
                            : Icons.remove_circle,
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
      floatingActionButton: ConfettiWidget(
        confettiController: _confettiController,
        blastDirectionality: BlastDirectionality.explosive,
        emissionFrequency: 0.05,
        numberOfParticles: 20,
      ),
    );
  }
}
