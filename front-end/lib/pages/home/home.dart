import 'package:flutter/material.dart';
import 'package:fynaura/pages/user-session/UserSession.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fynaura/pages/goal-oriented-saving/model/Goal.dart';

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

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<Goal>> _userGoals;
  late Future<Map<String, dynamic>> _totalIncomeAndExpense;
  String selectedPeriod = 'today';

  Future<List<Goal>> _fetchUserGoals() async {
    final userSession = UserSession();
    final uid = userSession.userId;

    try {
      final response = await http.get(
        Uri.parse('http://192.168.127.53:3000/goals/user/$uid'),
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
          'http://192.168.127.53:3000/transaction'; // Make sure this matches your backend

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
    // Initialize data for 'today' period when the screen loads
    _totalIncomeAndExpense = _fetchTotalIncomeAndExpense('today');
    _userGoals = _fetchUserGoals();
  }

  // Refresh function to trigger the data fetch again
  Future<void> _onRefresh() async {
    setState(() {
      _totalIncomeAndExpense =
          _fetchTotalIncomeAndExpense('today'); // Default to 'today'
      _userGoals = _fetchUserGoals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF254e7a),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text('Welcome ${widget.displayName ?? "No Name"}!'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: DefaultTabController(
              length: 3, // Number of tabs
              child: TabBar(
                labelColor: Colors.white, // White text for selected tab
                unselectedLabelColor:
                Colors.grey, // Grey text for unselected tabs
                indicatorColor: Colors.white, // White indicator for selected tab
                indicatorWeight: 3.0,
                onTap: (index) {
                  // Update selected period when a tab is selected
                  setState(() {
                    if (index == 0) {
                      selectedPeriod = 'today';
                    } else if (index == 1) {
                      selectedPeriod = 'week';
                    } else if (index == 2) {
                      selectedPeriod = 'month';
                    }
                    // Re-fetch income and expense data based on the selected period
                    _totalIncomeAndExpense =
                        _fetchTotalIncomeAndExpense(selectedPeriod);
                  });
                },
                tabs: [
                  Tab(text: 'Today'),
                  Tab(text: 'Week'),
                  Tab(text: 'Month'),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.grey),
              onPressed: () {},
            ),
          ],
        ),
        body: SafeArea(
          bottom: true,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), // Round top left corner
                topRight: Radius.circular(30), // Round top right corner
              ),
            ),
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Your other content remains unchanged
                    SizedBox(height: 20),

                    // Income and Expense Section
                    FutureBuilder<Map<String, dynamic>>(
                      future: _totalIncomeAndExpense,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Failed to load data'));
                        } else if (snapshot.hasData) {
                          final data = snapshot.data!;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IncomeExpenseCard(
                                title: 'Income',
                                amount: 'LKR ${data['totalIncome']}',
                                color: Color(0xFF254e7a),
                              ),
                              IncomeExpenseCard(
                                title: 'Expense',
                                amount: 'LKR ${data['totalExpense']}',
                                color: Colors.red.shade300,
                              ),
                            ],
                          );
                        } else {
                          return Center(child: Text('No data available'));
                        }
                      },
                    ),
                    SizedBox(height: 20),

                    // Budget Plan Section
                    Text('Budget Plan',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF254e7a))),
                    SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          BudgetCard(
                              title: 'Monthly Budget',
                              amount: 'LKR 18,000',
                              total: 'LKR 50,000',
                              progress: 0.7),
                          SizedBox(width: 20),
                          BudgetCard(
                              title: 'Conversation',
                              amount: 'LKR 18,000',
                              total: 'LKR 50,000',
                              progress: 0.7),
                          SizedBox(width: 20),
                          BudgetCard(
                              title: 'Anniversary',
                              amount: 'LKR 18,000',
                              total: 'LKR 50,000',
                              progress: 0.7),
                          SizedBox(width: 20),
                          BudgetCard(
                              title: "Mom's Birthday",
                              amount: 'LKR 18,000',
                              total: 'LKR 50,000',
                              progress: 0.7),
                          SizedBox(width: 20),
                          BudgetCard(
                              title: "Xian's Birthday",
                              amount: 'LKR 18,000',
                              total: 'LKR 50,000',
                              progress: 0.7),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),

                    // Goals Section with Two Columns
                    Text('Goals',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF254e7a))),
                    SizedBox(height: 20),
                    FutureBuilder<List<Goal>>(
                      future: _userGoals,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Failed to load goals'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('No goals found'));
                        }

                        final goals = snapshot.data!;

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 20.0,
                            mainAxisSpacing: 20.0,
                          ),
                          itemCount: goals.length,
                          itemBuilder: (context, index) {
                            final goal = goals[index];
                            final progress =
                            (goal.savedAmount / goal.targetAmount)
                                .clamp(0.0, 1.0);
                            return GoalCard(
                              title: goal.name,
                              progress: progress,
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
        )
    );
  }
}

// Income and Expense Card
class IncomeExpenseCard extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;

  const IncomeExpenseCard(
      {Key? key,
        required this.title,
        required this.amount,
        required this.color})
      : super(key: key);

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
          Text(title,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          SizedBox(height: 10),
          Text(amount,
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

// Budget Card
class BudgetCard extends StatelessWidget {
  final String title;
  final String amount;
  final String total;
  final double progress;

  const BudgetCard(
      {Key? key,
        required this.title,
        required this.amount,
        required this.total,
        required this.progress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF254e7a).withOpacity(0.5),
            Color(0xFF254e7a).withOpacity(0.8)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF254e7a).withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 3),
          ),
        ],
      ),
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(height: 10),
          Text('$amount of $total',
              style: TextStyle(fontSize: 14, color: Colors.white)),
          SizedBox(height: 10),
          LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.4),
              color: Colors.white),
        ],
      ),
    );
  }
}

// Goal Card
// Goal Card with enhanced design
class GoalCard extends StatelessWidget {
  final String title;
  final double progress;

  const GoalCard({Key? key, required this.title, required this.progress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
            18), // Increased corner radius for softer look
        boxShadow: [
          BoxShadow(
            color:
            Color(0xFF254e7a).withOpacity(0.2), // Subtle shadow for depth
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 4), // Slight downward offset for depth
          ),
        ],
        gradient: LinearGradient(
          colors: [
            Color(0xFF254e7a)
                .withOpacity(0.8), // Darker blue for a sophisticated look
            Color(0xFF6a9cbe).withOpacity(0.7) // Lighter blue for contrast
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      width: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2, // Slight spacing for a modern feel
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 10, // Thicker progress indicator
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white), // White progress bar for contrast
          ),
          SizedBox(height: 15),
          Text(
            "${(progress * 100).toStringAsFixed(0)}%", // Display percentage of progress
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
