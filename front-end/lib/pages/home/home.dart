
import 'package:flutter/material.dart';
class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;  // Track the selected index

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome Xuan !',
          style: TextStyle(fontSize: 20.0),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Income and Expense
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IncomeExpenseCard(title: 'Income', amount: 'LKR 49,500', color: Colors.blue),
                IncomeExpenseCard(title: 'Expense', amount: 'LKR 37,020', color: Colors.red),
              ],
            ),
            SizedBox(height: 20),

            // Budget Plan
            Text('Budget Plan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BudgetCard(title: 'Monthly Budget', amount: 'LKR 10,000', total: 'LKR 50,000', progress: 0.7),
                BudgetCard(title: 'Conversation', amount: 'LKR 10,000', total: 'LKR 50,000', progress: 0.7),
              ],
            ),
            SizedBox(height: 20),

            // Goals
            Text('Goals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GoalCard(title: 'Bicycle', progress: 0.7),
                GoalCard(title: 'Earphone', progress: 0.7),
              ],
            ),
            Spacer(),

            
          ],
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
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      width: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(amount, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      width: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('$amount of $total', style: TextStyle(fontSize: 14)),
          SizedBox(height: 10),
          LinearProgressIndicator(value: progress),
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
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      width: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          LinearProgressIndicator(value: progress),
        ],
      ),
    );
  }
}

