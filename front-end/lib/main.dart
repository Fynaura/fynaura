import 'package:flutter/material.dart';

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

  // Index to control the selected bottom navigation bar item
  int _selectedIndex = 0;

  // Function to handle bottom navigation bar item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('images/profile_icon.png'), // Profile image
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
        elevation: 0,  // Remove the shadow from AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Period Toggle (This Week, This Month, This Year)
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),  // Smooth switching animation
                child: Container(
                  key: ValueKey<String>(selectedPeriod),
                  child: ToggleButtons(
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('This Week', style: TextStyle(fontSize: 14)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('This Month', style: TextStyle(fontSize: 14)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('This Year', style: TextStyle(fontSize: 14)),
                      ),
                    ],
                    color: Colors.black,
                    selectedColor: Colors.white,
                    fillColor: Colors.blue[200],
                    borderRadius: BorderRadius.circular(10),
                    borderWidth: 2,
                  ),
                ),
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

              // Budget Plan Section (Updated to be scrollable horizontally)
              Text('Budget Plan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    BudgetPlanWidget(
                      label: 'Monthly Budget',
                      remainingPercentage: 70,
                      icon: Icons.calendar_today,
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BudgetPlanPage())),
                    ),
                    BudgetPlanWidget(
                      label: 'Conversation',
                      remainingPercentage: 50,
                      icon: Icons.chat_bubble,
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BudgetPlanPage())),
                    ),
                    BudgetPlanWidget(
                      label: 'Party',
                      remainingPercentage: 30,
                      icon: Icons.party_mode,
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BudgetPlanPage())),
                    ),
                    BudgetPlanWidget(
                      label: 'Birthday',
                      remainingPercentage: 90,
                      icon: Icons.cake,
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BudgetPlanPage())),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Goals Section (Unchanged)
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
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
        borderRadius: BorderRadius.circular(15),  // More rounded corners for modern look
        boxShadow: [  // Add shadow for modern, elevated look
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
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
  final IconData icon;

  const BudgetPlanWidget({Key? key, required this.label, required this.remainingPercentage, required this.onPressed, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),  // Rounded corners
        elevation: 8,  // Shadow effect for modern design
        child: Container(
          width: 180,  // Set fixed width for consistent size
          decoration: BoxDecoration(
            gradient: LinearGradient(  // Gradient for modern look
              colors: [Colors.blue[200]!, Colors.blue[300]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),  // Icon representing the budget plan
              SizedBox(height: 10),
              Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: remainingPercentage / 100,
                    backgroundColor: Colors.grey[200],
                    strokeWidth: 12,  // Thicker progress ring
                  ),
                  Text(
                    "${remainingPercentage.toInt()}%",  // Display percentage inside the ring
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.check, color: Colors.white),
        ),
        title: Text(goal, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: LinearProgressIndicator(
          value: remainingPercentage / 100,
          backgroundColor: Colors.grey[200],
          color: Colors.green,
        ),
      ),
    );
  }
}

// Budget Plan Page (Unchanged)
class BudgetPlanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Budget Plan')),
      body: Center(child: Text('This is where the Budget Plan details will go.')),
    );
  }
}
