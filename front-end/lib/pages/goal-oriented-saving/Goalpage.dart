import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart'; // Import confetti package
import 'AddGoalScreen.dart';
import 'GoalDetailScreen.dart';

class Goal {
  String name;
  double targetAmount;
  double savedAmount;
  DateTime startDate;
  DateTime endDate;
  bool isCompleted;
  String? image; // Add this line to store the image URL or path
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

class _GoalPageState extends State<GoalPage> with SingleTickerProviderStateMixin {
  late List<Goal> goals;
  late TabController _tabController;
  int _selectedTabIndex = 0; // 0 = All, 1 = Completed, 2 = Progressing
  late ConfettiController _confettiController; // For confetti effect

  @override
  void initState() {
    super.initState();
    goals = widget.goals;
    _tabController = TabController(length: 3, vsync: this); // 3 tabs: All, Completed, Progressing
    _confettiController = ConfettiController(duration: const Duration(seconds: 1)); // Initialize confetti controller
  }

  void _addGoal(Goal goal) {
    setState(() {
      goals.add(goal);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter the goals based on selected tab
    List<Goal> filteredGoals = [];
    if (_selectedTabIndex == 0) {
      filteredGoals = goals; // All goals
    } else if (_selectedTabIndex == 1) {
      filteredGoals = goals.where((goal) => goal.isCompleted).toList(); // Completed goals
    } else if (_selectedTabIndex == 2) {
      filteredGoals = goals.where((goal) => !goal.isCompleted).toList(); // Progressing goals
    }

    // Sort goals by date (recent first)
    filteredGoals.sort((a, b) => b.startDate.compareTo(a.startDate));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Goals',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF254e7a),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, goals);
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            setState(() {
              _selectedTabIndex = index;
            });
          },
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: 'All'),
            Tab(text: 'Completed'),
            Tab(text: 'In Progress'),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: filteredGoals.length,
                itemBuilder: (context, index) {
                  final goal = filteredGoals[index];
                  double progress = (goal.savedAmount / goal.targetAmount).clamp(0.0, 1.0);

                  // Trigger confetti animation on completion
                  if (goal.isCompleted && !goal.history.any((t) => t.isAdded)) {
                    _confettiController.play(); // Trigger confetti animation on completion
                  }

                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      leading: goal.image != null
                          ? CircleAvatar(
                        backgroundImage: NetworkImage(goal.image!),
                        radius: 30,
                      )
                          : Icon(Icons.image, size: 40, color: Colors.blue),
                      title: Text(goal.name, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF254e7a))),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Target: \$${goal.targetAmount.toStringAsFixed(2)}', style: TextStyle(color: Color(0xFF254e7a))),
                          Text('Saved: \$${goal.savedAmount.toStringAsFixed(2)}', style: TextStyle(color: Color(0xFF254e7a))),
                          // Progress Bar with Gradient
                          Container(
                            height: 15,  // Adjust the height to give it more visibility
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[300],
                            ),
                            child: Stack(
                              children: [
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 500),
                                  width: MediaQuery.of(context).size.width * progress,
                                  decoration: BoxDecoration(
                                    gradient: goal.isCompleted
                                        ? LinearGradient(
                                      colors: [Colors.green, Colors.greenAccent],  // Gold-to-green gradient for completed goals
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    )
                                        : LinearGradient(
                                      colors: [Color(0xFF254e7a), Colors.green],  // Blue-to-green gradient for in-progress goals
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    '${(progress * 100).toStringAsFixed(1)}%', // Show percentage inside the bar
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5),
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
                              goals[goals.indexOf(goal)] = updatedGoal;
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
      floatingActionButton: ConfettiWidget(
        confettiController: _confettiController,
        blastDirectionality: BlastDirectionality.explosive,
        emissionFrequency: 0.05,
        numberOfParticles: 20,
      ),
    );
  }
}
