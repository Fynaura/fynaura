import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',  // Modern font family
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
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
        backgroundColor: Color(0xFF4A90E2),  // Soft muted blue
        title: Text('Expense Tracker', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, size: 30),
            onPressed: () {},
          ),
        ],
        elevation: 4,  // Slight shadow for the AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                    fillColor: Color(0xFFF5F5F5),  // Soft light grey for selected background
                    borderRadius: BorderRadius.circular(30),
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
                    color: Color(0xFFA9D18E),  // Gentle green for income (growth)
                  ),
                  IncomeExpenseWidget(
                    label: 'Expense',
                    value: expenses,
                    color: Color(0xFF4A90E2),  // Soft muted blue for expenses
                  ),
                ],
              ),
              SizedBox(height: 30),

              // Budget Plan Section (Updated to be scrollable horizontally)
              Text('Budget Plan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                height: 200,
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

              // Goals Section (Updated with Round UI and Soft Color Scheme)
              Text('Goals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                height: 250,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    GoalWidget(goal: 'Bicycle', remainingPercentage: 70, icon: Icons.directions_bike),
                    GoalWidget(goal: 'Earphone', remainingPercentage: 80, icon: Icons.headphones),
                    GoalWidget(goal: 'Laptop', remainingPercentage: 40, icon: Icons.laptop),
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
        selectedItemColor: Color(0xFFA9D18E),  // Gentle green for selected items
        unselectedItemColor: Colors.grey,
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
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
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
            color: Color(0xFFF5F5F5),  // Light soft background color
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Creating a big circular progress ring
              Stack(
                alignment: Alignment.center,
                children: [
                  // Progress ring (background circle)
                  CircularProgressIndicator(
                    value: remainingPercentage / 100,
                    backgroundColor: Colors.grey[300],
                    strokeWidth: 15,  // Thicker progress ring
                  ),
                  // Icon in the center of the ring
                  Icon(icon, size: 40, color: Color(0xFF4A90E2)),
                  // Percentage inside the ring
                  Text(
                    "${remainingPercentage.toInt()}%",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A90E2),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A90E2),
                ),
              ),
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
  final IconData icon;

  const GoalWidget({Key? key, required this.goal, required this.remainingPercentage, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,  // Add elevation for floating effect
      child: Container(
        width: 200,  // Set width for consistency
        decoration: BoxDecoration(
          color: Color(0xFFF5F5F5),  // Soft background color for goals
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(icon, color: Color(0xFF4A90E2), size: 30),
          ),
          title: Text(goal, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4A90E2))),
          subtitle: LinearProgressIndicator(
            value: remainingPercentage / 100,
            backgroundColor: Colors.grey[300],
            color: Color(0xFF6DBE45),  // Gentle green for goal progress
            minHeight: 8,
          ),
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
