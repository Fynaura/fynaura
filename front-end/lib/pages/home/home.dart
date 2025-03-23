import 'package:flutter/material.dart';
import 'package:fynaura/pages/user-session/UserSession.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  late Future<Map<String, dynamic>> _totalIncomeAndExpense;

  // Function to fetch total income and expense from the API
  Future<Map<String, dynamic>> _fetchTotalIncomeAndExpense(String period) async {
    final userSession = UserSession();
    final uid = userSession.userId;

    try {
      // Constructing the API URL based on the selected period
      String incomeUrl = '';
      String expenseUrl = '';
      String baseUrl = 'http://192.168.127.53:3000/transaction'; // Make sure this matches your backend

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

      if (incomeResponse.statusCode == 200 && expenseResponse.statusCode == 200) {
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
  }

  // Refresh function to trigger the data fetch again
  Future<void> _onRefresh() async {
    setState(() {
      _totalIncomeAndExpense = _fetchTotalIncomeAndExpense('today'); // Default to 'today'
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background set to white
      appBar: AppBar(
        title: Text('Welcome ${widget.displayName ?? "No Name"}!'),
        centerTitle: true,
        backgroundColor: Color(0xFF254e7a),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh, // Trigger refresh when the user pulls down
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tab for Time Period Selection: This Week, This Month, This Year
                DefaultTabController(
                  length: 3, // Number of tabs
                  child: Column(
                    children: [
                      TabBar(
                        labelColor:
                            Color(0xFF254e7a), // White text for selected tab
                        unselectedLabelColor:
                            Colors.black, // Black text for unselected tab
                        indicatorColor: Color(
                            0xFF254e7a), // Blue indicator for the selected tab
                        indicatorWeight: 3.0, // Slightly thicker indicator line
                        tabs: [
                          Tab(text: 'Today'),
                          Tab(text: 'Week'),
                          Tab(text: 'Month'),
                        ],
                        onTap: (index) {
                          // Fetch data when a tab is selected
                          String period = '';
                          if (index == 0) {
                            period = 'today';
                          } else if (index == 1) {
                            period = 'week';
                          } else if (index == 2) {
                            period = 'month';
                          }

                          setState(() {
                            _totalIncomeAndExpense =
                                _fetchTotalIncomeAndExpense(period);
                          });
                        },
                      ),
                      Container(
                        height: 10, // For the tab content area
                        child: TabBarView(
                          children: [
                            // Content under the "Today" tab
                            Center(child: SizedBox.shrink()),
                            // Content under the "This Week" tab
                            Center(child: SizedBox.shrink()),
                            // Content under the "This Month" tab
                            Center(child: SizedBox.shrink()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

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

                // Budget Plan Section with Horizontal Scroll
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
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two columns
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                  ),
                  itemCount: 4, // Number of goals
                  itemBuilder: (BuildContext context, int index) {
                    return GoalCard(
                      title: index == 0
                          ? 'Bicycle'
                          : index == 1
                              ? 'Earphone'
                              : index == 2
                                  ? 'Cricket Bat'
                                  : 'iPhone 14',
                      progress: index == 0
                          ? 0.7
                          : index == 1
                              ? 0.7
                              : index == 2
                                  ? 0.7
                                  : 0.2,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
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
class GoalCard extends StatelessWidget {
  final String title;
  final double progress;

  const GoalCard({Key? key, required this.title, required this.progress})
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
      width: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(height: 10),
          CircularProgressIndicator(
              value: progress,
              strokeWidth: 8,
              backgroundColor: Colors.white.withOpacity(0.4),
              color: Colors.white),
        ],
      ),
    );
  }
}
