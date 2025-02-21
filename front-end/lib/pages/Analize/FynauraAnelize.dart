import 'package:flutter/material.dart';

void main() {
  runApp(FinancialTrackerApp());
}

class FinancialTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RecentTransactionsScreen(),
    );
  }
}

class RecentTransactionsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> transactions = [
    {
      "title": "Breakfast",
      "time": "08:00 AM",
      "date": "24 January 2024",
      "amount": "-LKR 580",
      "isIncome": false,
      "icon": Icons.breakfast_dining,
    },
    {
      "title": "Salary - JAN",
      "time": "08:20 AM",
      "date": "24 January 2024",
      "amount": "+LKR 580,000",
      "isIncome": true,
      "icon": Icons.account_balance_wallet,
    },
    {
      "title": "Crypto Trade",
      "time": "11:21 AM",
      "date": "24 January 2024",
      "amount": "+LKR 5,400",
      "isIncome": true,
      "icon": Icons.currency_bitcoin,
    },
    {
      "title": "Crypto Trade",
      "time": "11:50 AM",
      "date": "24 January 2024",
      "amount": "+LKR 500",
      "isIncome": true,
      "icon": Icons.currency_bitcoin,
    },
    {
      "title": "Lunch",
      "time": "02:00 PM",
      "date": "24 January 2024",
      "amount": "-LKR 1,200",
      "isIncome": false,
      "icon": Icons.lunch_dining,
    },
    {
      "title": "Rental Income",
      "time": "03:20 PM",
      "date": "24 January 2024",
      "amount": "+LKR 45,000",
      "isIncome": true,
      "icon": Icons.home_work,
    },
    {
      "title": "Electric Bill",
      "time": "05:00 PM",
      "date": "24 January 2024",
      "amount": "-LKR 50,000",
      "isIncome": false,
      "icon": Icons.electric_bolt,
    },
    {
      "title": "Grocery",
      "time": "06:30 PM",
      "date": "24 January 2024",
      "amount": "-LKR 4,500",
      "isIncome": false,
      "icon": Icons.shopping_cart,
    },
    {
      "title": "Books",
      "time": "06:30 PM",
      "date": "24 January 2024",
      "amount": "-LKR 2,400",
      "isIncome": false,
      "icon": Icons.book,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('assets/profile_picture.png'),
                  ),
                  SizedBox(width: 16),
                  Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.notifications),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Filters
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FilterButton(label: "Today", isActive: true),
                  FilterButton(label: "This Week", isActive: false),
                  FilterButton(label: "This Month", isActive: false),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Recent Transactions Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Recent Transactions",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),

            // Transactions List
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return TransactionTile(
                    title: transaction['title'],
                    time: transaction['time'],
                    date: transaction['date'],
                    amount: transaction['amount'],
                    isIncome: transaction['isIncome'],
                    icon: transaction['icon'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.pie_chart),
              onPressed: () {},
            ),
            SizedBox(width: 48), // Space for FAB
            IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool isActive;

  const FilterButton({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? Colors.blueAccent : Colors.white,
        foregroundColor: isActive ? Colors.white : Colors.black,
        side: BorderSide(color: Colors.blueAccent),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: () {},
      child: Text(label),
    );
  }
}

class TransactionTile extends StatelessWidget {
  final String title;
  final String time;
  final String date;
  final String amount;
  final bool isIncome;
  final IconData icon;

  const TransactionTile({
    required this.title,
    required this.time,
    required this.date,
    required this.amount,
    required this.isIncome,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isIncome ? Colors.green : Colors.red,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title),
        subtitle: Text("$time | $date"),
        trailing: Text(
          amount,
          style: TextStyle(
            color: isIncome ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
