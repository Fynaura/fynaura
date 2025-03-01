import 'package:flutter/material.dart';
import 'budget-plan.dart';  // Import for the budget plan page

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedPeriod = 'This Week'; // Default selected period

  // Income and Expenses data (default values for testing)
  String income = 'LKR 49,500';
  String expenses = 'LKR 37,020';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        leading: CircleAvatar(
          backgroundImage: AssetImage('images/profile_icon.png'), // Profile image
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Period Toggle (This Week, This Month, This Year)
              ToggleButtons(
                isSelected: ['This Week', 'This Month', 'This Year']
                    .map((e) => e == selectedPeriod)
                    .toList(),
                onPressed: (index) {
                  setState(() {
                    selectedPeriod = ['This Week', 'This Month', 'This Year'][index];
                    // You can update income and expense values based on the selected period
                    if (selectedPeriod == 'This Week') {
                      income = 'LKR 49,500';
                      expenses = 'LKR 37,020';
                    } else if (selectedPeriod == 'This Month') {
                      income = 'LKR 150,000';
                      expenses = 'LKR 100,000';
                    } else {
                      income = 'LKR 600,000';
                      expenses = 'LKR 400,000';
                    }
                  });
                },
                children: [
                  Text('This Week'),
                  Text('This Month'),
                  Text('This Year'),
                ],
              ),
              SizedBox(height: 20),

              // Income and Expense Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IncomeExpenseWidget(
                    label: 'Income',
                    value: income,
                    color: Colors.green[100]!,
                  ),
                  IncomeExpenseWidget(
                    label: 'Expense',
                    value: expenses,
                    color: Colors.red[100]!,
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Budget Plan Section
              Text('Budget Plan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    BudgetPlanWidget(
                      label: 'Monthly Budget',
                      remainingPercentage: 70,
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BudgetPlanPage())),
                    ),
                    BudgetPlanWidget(
                      label: 'Conversation',
                      remainingPercentage: 50,
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BudgetPlanPage())),
                    ),
                    BudgetPlanWidget(
                      label: 'Party',
                      remainingPercentage: 30,
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BudgetPlanPage())),
                    ),
                    BudgetPlanWidget(
                      label: 'Birthday',
                      remainingPercentage: 90,
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BudgetPlanPage())),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Goals Section (Scrollable)
              Text('Goals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    GoalWidget(goal: 'Bicycle', remainingPercentage: 70),
                    GoalWidget(goal: 'Earphone', remainingPercentage: 80),
                    GoalWidget(goal: 'Laptop', remainingPercentage: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Analyze'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Plan'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class IncomeExpenseWidget extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const IncomeExpenseWidget({Key? key, required this.label, required this.value, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(value, style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}

class BudgetPlanWidget extends StatelessWidget {
  final String label;
  final double remainingPercentage;
  final VoidCallback onPressed;

  const BudgetPlanWidget({Key? key, required this.label, required this.remainingPercentage, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            CircularProgressIndicator(
              value: remainingPercentage / 100,
              backgroundColor: Colors.grey[200],
            ),
            SizedBox(height: 5),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class GoalWidget extends StatelessWidget {
  final String goal;
  final double remainingPercentage;

  const GoalWidget({Key? key, required this.goal, required this.remainingPercentage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.check),
        ),
        title: Text(goal),
        subtitle: LinearProgressIndicator(
          value: remainingPercentage / 100,
        ),
      ),
    );
  }
}
