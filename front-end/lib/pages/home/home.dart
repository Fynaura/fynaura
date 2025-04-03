import 'package:flutter/material.dart';
import 'package:fynaura/pages/user-session/UserSession.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fynaura/pages/goal-oriented-saving/model/Goal.dart';
import 'package:fynaura/services/budget_service.dart';
import 'package:fynaura/pages/collab-budgeting/budgetDetails.dart';

class DashboardScreen extends StatefulWidget {
  final String? displayName;
  final String? email;

  // Constructor to receive the user details and uid
  const DashboardScreen({
    Key? key,
    required this.displayName,
    required this.email,
  }) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  // Define app's color palette based on AnalyzePage
  static const Color primaryColor = Color(0xFF254e7a); // Primary blue
  static const Color accentColor = Color(0xFF85c1e5); // Light blue accent
  static const Color lightBgColor = Color(0xFFEBF1FD); // Light background
  static const Color whiteColor = Colors.white; // White background

  late Future<List<Goal>> _userGoals;
  late Future<Map<String, dynamic>> _totalIncomeAndExpense;
  late Future<List<Map<String, dynamic>>> _userBudgets;
  String selectedPeriod = 'today';
  final BudgetService _budgetService = BudgetService();
  late TabController _tabController;

  // Fetch the user's budgets
  Future<List<Map<String, dynamic>>> _fetchUserBudgets() async {
    try {
      return await _budgetService.getBudgets();
    } catch (e) {
      print("Error fetching budgets: $e");
      return [];
    }
  }

  Future<List<Goal>> _fetchUserGoals() async {
    final userSession = UserSession();
    final uid = userSession.userId;

    try {
      final response = await http.get(
        Uri.parse('http://192.168.110.53:3000/goals/user/$uid'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((goalJson) => Goal.fromJson(goalJson)).toList();
      } else {
        throw Exception('Failed to load user goals');
      }
    } catch (e) {
      throw Exception('Failed to fetch goals: $e');
    }
  }

  // Function to fetch total income and expense from the API
  Future<Map<String, dynamic>> _fetchTotalIncomeAndExpense(
      String period) async {
    final userSession = UserSession();
    final uid = userSession.userId;

    try {
      // Constructing the API URL based on the selected period
      String incomeUrl = '';
      String expenseUrl = '';
      String baseUrl =
          'http://192.168.110.53:3000/transaction'; // Make sure this matches your backend

      // Construct the URLs based on the period selected
      if (period == 'today') {
        incomeUrl = '$baseUrl/total-income/$uid/today';
        expenseUrl = '$baseUrl/total-expense/$uid/today';
      } else if (period == 'week') {
        incomeUrl = '$baseUrl/total-income/$uid/week';
        expenseUrl = '$baseUrl/total-expense/$uid/week';
      } else if (period == 'month') {
        incomeUrl = '$baseUrl/total-income/$uid/month';
        expenseUrl = '$baseUrl/total-expense/$uid/month';
      }

      // Fetching total income and expense data
      final incomeResponse = await http.get(Uri.parse(incomeUrl));
      final expenseResponse = await http.get(Uri.parse(expenseUrl));

      if (incomeResponse.statusCode == 200 &&
          expenseResponse.statusCode == 200) {
        final incomeData = json.decode(incomeResponse.body);
        final expenseData = json.decode(expenseResponse.body);

        return {
          'totalIncome': incomeData['totalIncome'],
          'totalExpense': expenseData['totalExpense'],
        };
      } else {
        throw Exception('Failed to load income and expense data');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Initialize data for 'today' period when the screen loads
    _totalIncomeAndExpense = _fetchTotalIncomeAndExpense('today');
    _userGoals = _fetchUserGoals();
    _userBudgets = _fetchUserBudgets();

    // Add listener to tab controller to update the period
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        String period;
        if (_tabController.index == 0) {
          period = 'today';
        } else if (_tabController.index == 1) {
          period = 'week';
        } else {
          period = 'month';
        }

        if (period != selectedPeriod) {
          setState(() {
            selectedPeriod = period;
            _totalIncomeAndExpense = _fetchTotalIncomeAndExpense(period);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Refresh function to trigger the data fetch again
  Future<void> _onRefresh() async {
    setState(() {
      _totalIncomeAndExpense = _fetchTotalIncomeAndExpense(selectedPeriod);
      _userGoals = _fetchUserGoals();
      _userBudgets = _fetchUserBudgets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Welcome ${widget.displayName ?? "No Name"}!',
          style: TextStyle(
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: TabBar(
            controller: _tabController,
            labelColor: whiteColor,
            unselectedLabelColor: whiteColor.withOpacity(0.7),
            indicatorColor: accentColor,
            indicatorWeight: 3.0,
            tabs: [
              Tab(text: 'Today'),
              Tab(text: 'Week'),
              Tab(text: 'Month'),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: whiteColor),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: whiteColor),
            onPressed: _onRefresh,
          ),
        ],
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
          child: RefreshIndicator(
            color: primaryColor,
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),

                  // Income and Expense Header
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.account_balance_wallet, color: whiteColor),
                        SizedBox(width: 8),
                        Text(
                          "Income & Expenses",
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

                  // Income and Expense Section
                  FutureBuilder<Map<String, dynamic>>(
                    future: _totalIncomeAndExpense,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child:
                                CircularProgressIndicator(color: primaryColor));
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text('Failed to load data',
                                style: TextStyle(color: Colors.red)));
                      } else if (snapshot.hasData) {
                        final data = snapshot.data!;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IncomeExpenseCard(
                              title: 'Income',
                              amount: 'LKR ${data['totalIncome']}',
                              color: primaryColor,
                              icon: Icons.arrow_upward,
                            ),
                            IncomeExpenseCard(
                              title: 'Expense',
                              amount: 'LKR ${data['totalExpense']}',
                              color: Colors.red.shade300,
                              icon: Icons.arrow_downward,
                            ),
                          ],
                        );
                      } else {
                        return Center(
                            child: Text('No data available',
                                style: TextStyle(color: Colors.grey)));
                      }
                    },
                  ),
                  SizedBox(height: 30),

                  // Budget Plan Header
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.pie_chart, color: whiteColor),
                        SizedBox(width: 8),
                        Text(
                          "Budget Plan",
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

                  // Budget Plan Section with FutureBuilder to display fetched budgets
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _userBudgets,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child:
                                CircularProgressIndicator(color: primaryColor));
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text('Failed to load budgets',
                                style: TextStyle(color: Colors.red)));
                      } else if (snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        final budgets = snapshot.data!;
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: budgets.map((budget) {
                              // Calculate spent amount based on remaining percentage
                              final budgetAmount = double.tryParse(
                                      budget["amount"].toString()) ??
                                  0.0;
                              final remainPercentage =
                                  (budget["remainPercentage"] ?? 100.0) / 100;
                              final spentPercentage = 1.0 -
                                  remainPercentage; // Inverse of remaining percentage
                              final spentAmount =
                                  budgetAmount * spentPercentage;

                              return Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigate to Budget Details page when card is tapped
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BudgetDetails(
                                          budgetName: budget["name"] ??
                                              "Unnamed Budget",
                                          budgetAmount:
                                              budget["amount"].toString(),
                                          budgetDate: budget["date"] ?? "",
                                          budgetId: budget["id"].toString(),
                                        ),
                                      ),
                                    ).then((_) =>
                                        _onRefresh()); // Refresh data when returning from details page
                                  },
                                  child: BudgetCard(
                                    title: budget["name"] ?? "Unnamed Budget",
                                    amount:
                                        "LKR ${spentAmount.toStringAsFixed(2)}",
                                    total:
                                        "LKR ${budgetAmount.toStringAsFixed(2)}",
                                    progress:
                                        spentPercentage, // Use the calculated spent percentage
                                    icon: Icons.account_balance_wallet,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      } else {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text('No budgets available',
                                style: TextStyle(color: Colors.grey)),
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 30),

                  // Goals Header
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
                          "Goals",
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

                  // Goals Section with Grid
                  FutureBuilder<List<Goal>>(
                    future: _userGoals,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child:
                                CircularProgressIndicator(color: primaryColor));
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text('Failed to load goals',
                                style: TextStyle(color: Colors.red)));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text('No goals found',
                                style: TextStyle(color: Colors.grey)),
                          ),
                        );
                      }

                      final goals = snapshot.data!;

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20.0,
                          mainAxisSpacing: 20.0,
                          childAspectRatio:
                              0.58, // Further adjusted to prevent overflow
                        ),
                        itemCount: goals.length,
                        itemBuilder: (context, index) {
                          final goal = goals[index];
                          final progress =
                              (goal.savedAmount / goal.targetAmount)
                                  .clamp(0.0, 1.0);

                          // Determine icon based on goal name keywords
                          IconData goalIcon = Icons.emoji_events;
                          final goalName = goal.name.toLowerCase();
                          if (goalName.contains('house') ||
                              goalName.contains('home')) {
                            goalIcon = Icons.home;
                          } else if (goalName.contains('car') ||
                              goalName.contains('vehicle')) {
                            goalIcon = Icons.directions_car;
                          } else if (goalName.contains('education') ||
                              goalName.contains('school') ||
                              goalName.contains('college')) {
                            goalIcon = Icons.school;
                          } else if (goalName.contains('travel') ||
                              goalName.contains('vacation') ||
                              goalName.contains('trip')) {
                            goalIcon = Icons.flight;
                          } else if (goalName.contains('wedding') ||
                              goalName.contains('marriage')) {
                            goalIcon = Icons.favorite;
                          } else if (goalName.contains('device') ||
                              goalName.contains('phone') ||
                              goalName.contains('tech')) {
                            goalIcon = Icons.devices;
                          } else if (goalName.contains('emergency') ||
                              goalName.contains('medical')) {
                            goalIcon = Icons.medical_services;
                          }

                          return GoalCard(
                            title: goal.name,
                            progress: progress,
                            savedAmount: goal.savedAmount,
                            targetAmount: goal.targetAmount,
                            targetDate: goal.endDate,
                            icon: goalIcon,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Income and Expense Card with improved design
class IncomeExpenseCard extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;
  final IconData icon;

  const IncomeExpenseCard({
    Key? key,
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 3),
          ),
        ],
      ),
      width: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 16),
              SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            amount,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// Budget Card Widget with enhanced design
// Enhanced Budget Card Widget
class BudgetCard extends StatelessWidget {
  final String title;
  final String amount;
  final String total;
  final double progress;
  final String? category;
  final IconData? icon;

  const BudgetCard({
    Key? key,
    required this.title,
    required this.amount,
    required this.total,
    required this.progress,
    this.category,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine status color based on progress
    Color statusColor = Colors.green;
    if (progress >= 0.9) {
      statusColor = Colors.red;
    } else if (progress >= 0.7) {
      statusColor = Colors.orange;
    }

    // Status text based on progress
    String statusText = "On Track";
    if (progress >= 0.9) {
      statusText = "Critical";
    } else if (progress >= 0.7) {
      statusText = "Warning";
    }

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF254e7a).withOpacity(0.6),
            Color(0xFF254e7a).withOpacity(0.9)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF254e7a).withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Budget title and icon row
          Row(
            children: [
              if (icon != null)
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              SizedBox(width: icon != null ? 8 : 0),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          if (category != null) ...[
            SizedBox(height: 6),
            Text(
              category!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],

          SizedBox(height: 12),

          // Amount info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Spent',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    amount,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Budget',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    total,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 12),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Stack(
              children: [
                // Progress bar background
                Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),

                // Progress bar fill
                Container(
                  height: 12,
                  width: 218 * progress, // Width of the container * progress
                  decoration: BoxDecoration(
                    // Color transitions from green to yellow to red as progress increases
                    gradient: LinearGradient(
                      colors: [
                        progress < 0.7
                            ? Colors.green
                            : progress < 0.9
                                ? Colors.orange
                                : Colors.red,
                        progress < 0.7
                            ? Colors.green.shade300
                            : progress < 0.9
                                ? Colors.orangeAccent
                                : Colors.redAccent,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: (progress < 0.7
                                ? Colors.green
                                : progress < 0.9
                                    ? Colors.orange
                                    : Colors.red)
                            .withOpacity(0.4),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),

                // Progress percentage
                Positioned.fill(
                  child: Center(
                    child: Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12),

          // Remaining amount
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'LKR ${(double.parse(total.replaceAll('LKR ', '')) - double.parse(amount.replaceAll('LKR ', ''))).toStringAsFixed(2)} remaining',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Enhanced Goal Card with rich visualization and detailed information
class GoalCard extends StatelessWidget {
  final String title;
  final double progress;
  // Additional optional parameters for enhanced UI
  final double? targetAmount;
  final double? savedAmount;
  final DateTime? targetDate;
  final IconData icon;

  const GoalCard({
    Key? key,
    required this.title,
    required this.progress,
    this.targetAmount,
    this.savedAmount,
    this.targetDate,
    this.icon = Icons.emoji_events,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate days remaining if target date exists
    int? daysRemaining;
    if (targetDate != null) {
      daysRemaining = targetDate!.difference(DateTime.now()).inDays;
    }

    // Determine status color based on progress
    Color statusColor = Colors.orange;
    if (progress >= 0.9) {
      statusColor = Colors.green;
    } else if (progress >= 0.6) {
      statusColor = Colors.amber;
    } else if (progress < 0.3) {
      statusColor = Colors.deepOrange;
    }

    // Status text based on progress
    String statusText = "In Progress";
    if (progress >= 1.0) {
      statusText = "Completed!";
    } else if (progress >= 0.75) {
      statusText = "Almost There!";
    } else if (progress >= 0.5) {
      statusText = "Halfway There";
    } else if (progress >= 0.25) {
      statusText = "Getting Started";
    } else {
      statusText = "Just Started";
    }

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF254e7a).withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        gradient: LinearGradient(
          colors: [
            Color(0xFF254e7a),
            Color(0xFF3a6ea5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Goal icon and title
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          SizedBox(height: 15),

          // Progress indicator
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 10,
                    backgroundColor: Colors.white.withOpacity(0.15),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    "${(progress * 100).toStringAsFixed(0)}%",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (savedAmount != null && targetAmount != null)
            Text(
              "Rs.${savedAmount?.toStringAsFixed(0)} / Rs.${targetAmount?.toStringAsFixed(0)}",
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withOpacity(0.9),
              ),
            ),

          SizedBox(height: 12),

          // Status and days remaining
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: statusColor.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              if (daysRemaining != null) ...[
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    SizedBox(width: 4),
                    Text(
                      "$daysRemaining days left",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
