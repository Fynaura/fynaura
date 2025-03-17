import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background set to white
      appBar: AppBar(
        title: Text('Welcome Xuan !', style: TextStyle(fontSize: 20.0, color: Colors.white)),
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
                      labelColor: Color(0xFF254e7a), // White text for selected tab
                      unselectedLabelColor: Colors.black, // Black text for unselected tab
                      indicatorColor: Color(0xFF254e7a), // Blue indicator for the selected tab
                      indicatorWeight: 3.0, // Slightly thicker indicator line
                      tabs: [
                        Tab(text: 'This Week'),
                        Tab(text: 'This Month'),
                        Tab(text: 'This Year'),
                      ],
                    ),
                    Container(
                      height: 50, // For the tab content area
                      child: TabBarView(
                        children: [
                          // Content under the "This Week" tab (currently no content)
                          Center(child: SizedBox.shrink()),
                          // Content under the "This Month" tab (currently no content)
                          Center(child: SizedBox.shrink()),
                          // Content under the "This Year" tab (currently no content)
                          Center(child: SizedBox.shrink()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Income and Expense Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IncomeExpenseCard(
                    title: 'Income',
                    amount: 'LKR 49,500',
                    color: Color(0xFF254e7a),
                  ),
                  IncomeExpenseCard(
                    title: 'Expense',
                    amount: 'LKR 37,020',
                    color: Colors.red.shade300,
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Budget Plan Section with Horizontal Scroll
              Text('Budget Plan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF254e7a))),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    BudgetCard(title: 'Monthly Budget', amount: 'LKR 18,000', total: 'LKR 50,000', progress: 0.7),
                    SizedBox(width: 20),
                    BudgetCard(title: 'Conversation', amount: 'LKR 18,000', total: 'LKR 50,000', progress: 0.7),
                    SizedBox(width: 20),
                    BudgetCard(title: 'Anniversary', amount: 'LKR 18,000', total: 'LKR 50,000', progress: 0.7),
                    SizedBox(width: 20),
                    BudgetCard(title: "Mom's Birthday", amount: 'LKR 18,000', total: 'LKR 50,000', progress: 0.7),
                    SizedBox(width: 20),
                    BudgetCard(title: "Xian's Birthday", amount: 'LKR 18,000', total: 'LKR 50,000', progress: 0.7),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // Goals Section with Two Columns
              Text('Goals', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF254e7a))),
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
    );
  }
}

class IncomeExpenseCard extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;

  const IncomeExpenseCard({Key? key, required this.title, required this.amount, required this.color}) : super(key: key);

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
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          SizedBox(height: 10),
          Text(amount, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

class BudgetCard extends StatelessWidget {
  final String title;
  final String amount;
  final String total;
  final double progress;

  const BudgetCard({Key? key, required this.title, required this.amount, required this.total, required this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF254e7a).withOpacity(0.5), Color(0xFF254e7a).withOpacity(0.8)],
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
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 10),
          Text('$amount of $total', style: TextStyle(fontSize: 14, color: Colors.white)),
          SizedBox(height: 10),
          LinearProgressIndicator(value: progress, backgroundColor: Colors.white.withOpacity(0.4), color: Colors.white),
        ],
      ),
    );
  }
}

class GoalCard extends StatelessWidget {
  final String title;
  final double progress;

  const GoalCard({Key? key, required this.title, required this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF254e7a).withOpacity(0.5), Color(0xFF254e7a).withOpacity(0.8)],
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
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 10),
          CircularProgressIndicator(value: progress, strokeWidth: 8, backgroundColor: Colors.white.withOpacity(0.4), color: Colors.white),
        ],
      ),
    );
  }
}
