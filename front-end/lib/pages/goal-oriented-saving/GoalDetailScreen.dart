import 'package:flutter/material.dart';

import 'package:confetti/confetti.dart';
import 'package:fynaura/pages/goal-oriented-saving/model/Goal.dart';
import 'package:fynaura/pages/goal-oriented-saving/service/GoalService.dart'
    as service;
import 'package:uuid/uuid.dart'; // Add the confetti package

bool isMongoId(String id) {
  final regex = RegExp(r'^[a-f\d]{24}$');
  return regex.hasMatch(id);
}


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
                double amountToAdd = double.tryParse(_amountController.text) ?? 0.0;

                if (amountToAdd > 0 && amountToAdd.isFinite && !amountToAdd.isNaN) {
                  final String tempId = const Uuid().v4();

                  setState(() {
                    goal.savedAmount += amountToAdd;
                    goal.history.add(Transaction(
                      id: tempId,
                      amount: amountToAdd,
                      date: DateTime.now(),
                      isAdded: true,
                    ));
                  });

                  await service.GoalService().addAmount(goal.id, amountToAdd);
                  print('Sending amountToAdd: $amountToAdd');

                  await service.GoalService().addTransaction(
                    goal.id,
                    amountToAdd,
                    DateTime.now().toString(),
                    true,
                  );

                  if (goal.savedAmount >= goal.targetAmount) {
                    goal.isCompleted = true;
                    _confettiController.play();
                    await service.GoalService().markGoalAsCompleted(goal.id);
                    setState(() {});
                  }
                }


                Navigator.pop(context);
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
  if (goal.isCompleted) return;

  TextEditingController _amountController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Subtract Amount", style: TextStyle(color: Color(0xFF254e7a))),
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
              Navigator.pop(context);
            },
            child: Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () async {
              double amountToSubtract = double.tryParse(_amountController.text) ?? 0.0;

              if (amountToSubtract > 0 && goal.savedAmount >= amountToSubtract) {
                final String tempId = const Uuid().v4();

                setState(() {
                  goal.savedAmount -= amountToSubtract;
                  goal.history.add(Transaction(
                    id: tempId,
                    amount: amountToSubtract,
                    date: DateTime.now(),
                    isAdded: false,
                  ));
                });

                await service.GoalService().subtractAmount(goal.id, amountToSubtract);
                await service.GoalService().addTransaction(
                  goal.id,
                  amountToSubtract,
                  DateTime.now().toString(),
                  false,
                );

                Navigator.pop(context);
              } else if (amountToSubtract <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please enter a positive amount")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Cannot subtract more than saved amount")),
                );
              }
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
                  return Dismissible(
                    key: Key(transaction.id), // make sure each transaction has a unique id
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20),
                      color: Colors.red,
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Delete Transaction'),
                          content: Text('Are you sure you want to delete this transaction?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text('Delete', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                    onDismissed: (direction) async {
                      final removedTransaction = goal.history[index];

                      // Check if transaction is synced with backend
                      if (isMongoId(removedTransaction.id)) {
                        try {
                          await service.GoalService().deleteTransaction(goal.id, removedTransaction.id);
                          setState(() {
                            goal.history.removeAt(index);
                            goal.savedAmount -= removedTransaction.isAdded
                                ? removedTransaction.amount
                                : -removedTransaction.amount;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Transaction deleted")),
                          );
                        } catch (e) {
                          print("Delete failed: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Failed to delete transaction")),
                          );
                        }
                      } else {
                        // Local-only transaction, just remove from UI
                        setState(() {
                          goal.history.removeAt(index);
                          goal.savedAmount -= removedTransaction.isAdded
                              ? removedTransaction.amount
                              : -removedTransaction.amount;
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Local transaction deleted")),
                        );
                      }
                    },

                    child: Card(
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
                        subtitle: Text(
                          transaction.date.toString(),
                          style: TextStyle(color: Color(0xFF254e7a)),
                        ),
                        trailing: Icon(
                          transaction.isAdded ? Icons.add_circle : Icons.remove_circle,
                          color: transaction.isAdded ? Colors.green : Colors.red,
                        ),
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