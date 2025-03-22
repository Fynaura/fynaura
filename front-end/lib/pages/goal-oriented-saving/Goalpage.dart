// imports stay the same
import 'package:flutter/material.dart';
import 'package:fynaura/pages/goal-oriented-saving/AddGoalScreen.dart';
import 'package:fynaura/pages/goal-oriented-saving/GoalDetailScreen.dart';
import 'package:fynaura/pages/goal-oriented-saving/model/Goal.dart';
import 'package:fynaura/pages/goal-oriented-saving/service/GoalService.dart';
import 'package:fynaura/pages/user-session/UserSession.dart';

class GoalPage extends StatefulWidget {
  final List<Goal> goals;

  GoalPage({Key? key, required this.goals}) : super(key: key);

  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> with SingleTickerProviderStateMixin {
  late List<Goal> goals;
  late TabController _tabController;
  int _selectedTabIndex = 0;
  final GoalService _goalService = GoalService();

  @override
  void initState() {
    super.initState();
    goals = widget.goals;
    _tabController = TabController(length: 3, vsync: this);
    _loadGoals();
  }

  Future<void> _loadGoals() async {

        final userSession = UserSession();
    final uid = userSession.userId;
    try {
      List<Goal> fetchedGoals = await _goalService.getGoalsByUser(uid!);
      setState(() {
        goals = fetchedGoals;
      });
    } catch (e) {
      print("Error loading goals: $e");
    }
  }

  void _addGoal(Goal goal) {
    setState(() {
      goals.add(goal);
    });
  }

  Future<void> _deleteGoal(String id) async {
    try {
      await _goalService.deleteGoal(id);
      await _loadGoals(); // refresh the list
    } catch (e) {
      print("Failed to delete goal: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting goal")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Goal> filteredGoals = _selectedTabIndex == 0
        ? goals
        : goals.where((g) => _selectedTabIndex == 1 ? g.isCompleted : !g.isCompleted).toList();

    filteredGoals.sort((a, b) => b.startDate.compareTo(a.startDate));

    return Scaffold(
      appBar: AppBar(
        title: Text('Goals', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF254e7a),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context, goals),
        ),
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) => setState(() => _selectedTabIndex = index),
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
              child: RefreshIndicator(
                onRefresh: _loadGoals,
                child: ListView.builder(
                  itemCount: filteredGoals.length,
                  itemBuilder: (context, index) {
                    final goal = filteredGoals[index];
                    double progress = (goal.savedAmount / goal.targetAmount).clamp(0.0, 1.0);

                    return Dismissible(
                      key: Key(goal.id), // use a unique id from goal
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
                            title: Text("Delete Goal"),
                            content: Text("Are you sure you want to delete this goal?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: Text("Delete", style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                      onDismissed: (direction) async {
                        await _deleteGoal(goal.id);
                        setState(() => goals.removeWhere((g) => g.id == goal.id));

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${goal.name} deleted")),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(10),
                          leading: goal.image != null
                              ? CircleAvatar(backgroundImage: NetworkImage(goal.image!), radius: 30)
                              : Icon(Icons.image, size: 40, color: Colors.blue),
                          title: Text(goal.name, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF254e7a))),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Target: \$${goal.targetAmount.toStringAsFixed(2)}',
                                  style: TextStyle(color: Color(0xFF254e7a))),
                              Text('Saved: \$${goal.savedAmount.toStringAsFixed(2)}',
                                  style: TextStyle(color: Color(0xFF254e7a))),
                              Container(
                                height: 15,
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
                                                colors: [Colors.green, Colors.greenAccent],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                              )
                                            : LinearGradient(
                                                colors: [Color(0xFF254e7a), Colors.green],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                              ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        '${(progress * 100).toStringAsFixed(1)}%',
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
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF254e7a),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                child: Text('Add Goal', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
