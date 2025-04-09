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
  // Define app's color palette (matching the design from dashboard and analyze pages)
  static const Color primaryColor = Color(0xFF254e7a);   // Primary blue
  static const Color accentColor = Color(0xFF85c1e5);    // Light blue accent
  static const Color lightBgColor = Color(0xFFEBF1FD);   // Light background
  static const Color whiteColor = Colors.white;          // White background
  
  late List<Goal> goals;
  late TabController _tabController;
  int _selectedTabIndex = 0;
  final GoalService _goalService = GoalService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    goals = widget.goals;
    _tabController = TabController(length: 3, vsync: this);
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    setState(() {
      isLoading = true;
    });

    final userSession = UserSession();
    final uid = userSession.userId;
    try {
      List<Goal> fetchedGoals = await _goalService.getGoalsByUser(uid!);
      setState(() {
        goals = fetchedGoals;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading goals: $e");
      setState(() {
        isLoading = false;
      });
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
        SnackBar(
          content: Text("Error deleting goal"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Determine icon based on goal name keywords
  IconData getGoalIcon(String goalName) {
    final name = goalName.toLowerCase();
    if (name.contains('house') || name.contains('home')) {
      return Icons.home;
    } else if (name.contains('car') || name.contains('vehicle')) {
      return Icons.directions_car;
    } else if (name.contains('education') || name.contains('school') || name.contains('college')) {
      return Icons.school;
    } else if (name.contains('travel') || name.contains('vacation') || name.contains('trip')) {
      return Icons.flight;
    } else if (name.contains('wedding') || name.contains('marriage')) {
      return Icons.favorite;
    } else if (name.contains('device') || name.contains('phone') || name.contains('tech')) {
      return Icons.devices;
    } else if (name.contains('emergency') || name.contains('medical')) {
      return Icons.medical_services;
    }
    return Icons.emoji_events;
  }

  @override
  Widget build(BuildContext context) {
    List<Goal> filteredGoals = _selectedTabIndex == 0
        ? goals
        : goals.where((g) => _selectedTabIndex == 1 ? g.isCompleted : !g.isCompleted).toList();

    filteredGoals.sort((a, b) => b.startDate.compareTo(a.startDate));

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text(
          'Financial Goals', 
          style: TextStyle(
            color: whiteColor, 
            fontWeight: FontWeight.bold
          )
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: whiteColor),
          onPressed: () => Navigator.pop(context, goals),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: whiteColor),
            onPressed: _loadGoals,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) => setState(() => _selectedTabIndex = index),
          labelColor: whiteColor,
          unselectedLabelColor: whiteColor.withOpacity(0.7),
          indicatorColor: accentColor,
          indicatorWeight: 3.0,
          tabs: [
            Tab(text: 'All Goals'),
            Tab(text: 'Completed'),
            Tab(text: 'In Progress'),
          ],
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: Container(
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                // Title section with icon
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.flag, color: whiteColor),
                      SizedBox(width: 8),
                      Text(
                        "Your Financial Goals",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: whiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Expanded(
                  child: isLoading
                    ? Center(child: CircularProgressIndicator(color: primaryColor))
                    : RefreshIndicator(
                      color: primaryColor,
                      onRefresh: _loadGoals,
                      child: filteredGoals.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.sentiment_neutral, size: 60, color: primaryColor.withOpacity(0.5)),
                                SizedBox(height: 20),
                                Text(
                                  'No goals found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: primaryColor.withOpacity(0.7),
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Create your first financial goal to get started',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                          itemCount: filteredGoals.length,
                          itemBuilder: (context, index) {
                            final goal = filteredGoals[index];
                            double progress = (goal.savedAmount / goal.targetAmount).clamp(0.0, 1.0);
                            
                            // Determine status color based on progress
                            Color statusColor = Colors.orange;
                            if (progress >= 0.9 || goal.isCompleted) {
                              statusColor = Colors.green;
                            } else if (progress >= 0.6) {
                              statusColor = Colors.amber;
                            } else if (progress < 0.3) {
                              statusColor = Colors.deepOrange;
                            }
                            
                            // Status text based on progress
                            String statusText = "In Progress";
                            if (goal.isCompleted) {
                              statusText = "Completed!";
                            } else if (progress >= 0.75) {
                              statusText = "Almost There!";
                            } else if (progress >= 0.5) {
                              statusText = "Halfway";
                            } else if (progress >= 0.25) {
                              statusText = "Started";
                            } else {
                              statusText = "Just Started";
                            }

                            return Dismissible(
                              key: Key(goal.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Icon(Icons.delete, color: whiteColor),
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
                                  SnackBar(
                                    content: Text("${goal.name} deleted"),
                                    backgroundColor: primaryColor,
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 3,
                                margin: EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: goal.isCompleted ? Colors.green.withOpacity(0.5) : primaryColor.withOpacity(0.2),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            // Icon or Image
                                            Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                color: lightBgColor,
                                                borderRadius: BorderRadius.circular(25),
                                              ),
                                              child: Center(
                                                child: goal.image != null
                                                  ? ClipRRect(
                                                      borderRadius: BorderRadius.circular(25),
                                                      child: Image.network(
                                                        goal.image!,
                                                        height: 50,
                                                        width: 50,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  : Icon(
                                                      getGoalIcon(goal.name),
                                                      color: primaryColor,
                                                    ),
                                              ),
                                            ),
                                            SizedBox(width: 15),
                                            // Goal details
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    goal.name,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                      color: primaryColor,
                                                    ),
                                                  ),
                                                  SizedBox(height: 3),
                                                  Text(
                                                    'Target: LKR ${goal.targetAmount.toStringAsFixed(2)}',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Status badge
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                              decoration: BoxDecoration(
                                                color: statusColor.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: statusColor.withOpacity(0.5),
                                                  width: 1,
                                                ),
                                              ),
                                              child: Text(
                                                statusText,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: statusColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 15),
                                        // Progress bar
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'Progress: ${(progress * 100).toStringAsFixed(1)}%',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: primaryColor,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                Text(
                                                  'Saved: LKR ${goal.savedAmount.toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    color: Colors.grey[700],
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            // Enhanced progress bar
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: Container(
                                                height: 12,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.withOpacity(0.2),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Stack(
                                                  children: [
                                                    // Progress fill
                                                    AnimatedContainer(
                                                      duration: Duration(milliseconds: 500),
                                                      width: MediaQuery.of(context).size.width * progress,
                                                      decoration: BoxDecoration(
                                                        gradient: goal.isCompleted
                                                          ? LinearGradient(
                                                              colors: [Colors.green.shade700, Colors.green.shade300],
                                                              begin: Alignment.centerLeft,
                                                              end: Alignment.centerRight,
                                                            )
                                                          : LinearGradient(
                                                              colors: [primaryColor, accentColor],
                                                              begin: Alignment.centerLeft,
                                                              end: Alignment.centerRight,
                                                            ),
                                                      ),
                                                    ),
                                                    // Progress text
                                                    if (progress > 0.1) // Only show text if there's enough space
                                                      Positioned.fill(
                                                        child: Center(
                                                          child: Text(
                                                            '${(progress * 100).toStringAsFixed(0)}%',
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 10,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        // View details button
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            TextButton.icon(
                                              style: TextButton.styleFrom(
                                                foregroundColor: primaryColor,
                                                backgroundColor: lightBgColor,
                                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              icon: Icon(Icons.visibility, size: 16),
                                              label: Text('View Details'),
                                              onPressed: () {
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
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    ),
                ),
                SizedBox(height: 20),
                // Add goal button with enhanced styling
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: whiteColor,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 4,
                    ),
                    icon: Icon(Icons.add_circle, size: 20),
                    label: Text(
                      'Create New Goal', 
                      style: TextStyle(
                        color: whiteColor, 
                        fontSize: 16, 
                        fontWeight: FontWeight.bold
                      )
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
                    
                  ),
                  
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}