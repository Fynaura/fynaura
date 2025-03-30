import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fynaura/pages/Analize/TransactionModel.dart';
import 'package:fynaura/pages/user-session/UserSession.dart';
import 'package:fynaura/widgets/stats/bar_cart.dart';
import 'package:http/http.dart' as http;
import 'package:fynaura/widgets/analyze/money_chart.dart'; // Import MoneyChart
import 'package:fynaura/widgets/analyze/pie_chart.dart'; // Import PieChart
import 'package:intl/intl.dart'; // For date formatting

class AnalyzePage extends StatefulWidget {
  const AnalyzePage({super.key});

  @override
  State<AnalyzePage> createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage>
    with SingleTickerProviderStateMixin {
  List<Transaction> transactions = [];
  bool isLoading = true;
  List<Map<String, dynamic>> hourlyBalanceData = [];
  List<Transaction> filteredTransactions = [];
  String selectedFilter = 'Today'; // Default filter is Today
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 3, vsync: this); // Create a TabController with 3 tabs
    fetchHourlyBalanceData(); // Load hourly balance data when the page loads
    fetchTransactions(); // Fetch transactions for the list
  }

  // Fetch hourly balance data from the backend
  Future<void> fetchHourlyBalanceData() async {
    final response = await http.get(
        Uri.parse('http://192.168.110.53:3000/transaction/hourly-balance'));

    if (response.statusCode == 200) {
      // Parse the JSON response and cast it as List<Map<String, dynamic>>
      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(json.decode(response.body));

      setState(() {
        hourlyBalanceData = data; // Assigning the data directly
        isLoading = false;
      });
    } else {
      // Handle error
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load hourly balance data');
    }
  }

  // Fetch transactions for the list
  Future<void> fetchTransactions() async {
    final userSession = UserSession();
    final uid = userSession.userId;
    final response = await http
        .get(Uri.parse('http://192.168.110.53:3000/transaction/$uid'));

    if (response.statusCode == 200) {
      // Parse the JSON response and map it to Transaction model
      List<dynamic> data = json.decode(response.body);
      setState(() {
        transactions = data.map((json) => Transaction.fromJson(json)).toList();
        filterTransactions(selectedFilter); // Apply the selected filter
      });
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  // Refresh when the user pulls to refresh
  Future<void> _onRefresh() async {
    setState(() {
      isLoading = true;
    });
    await fetchHourlyBalanceData(); // Fetch hourly balance data again
    await fetchTransactions(); // Fetch transactions again
  }

  // Function to filter transactions based on the selected filter (Today, Week, Month)
  void filterTransactions(String filter) {
    DateTime now = DateTime.now();
    List<Transaction> filtered = [];

    if (filter == 'Today') {
      filtered = transactions.where((transaction) {
        return transaction.date.day == now.day &&
            transaction.date.month == now.month &&
            transaction.date.year == now.year;
      }).toList();
    } else if (filter == 'This Week') {
      filtered = transactions.where((transaction) {
        return transaction.date
                .isAfter(now.subtract(Duration(days: now.weekday - 1))) &&
            transaction.date.isBefore(now.add(Duration(days: 7 - now.weekday)));
      }).toList();
    } else if (filter == 'This Month') {
      filtered = transactions.where((transaction) {
        return transaction.date.month == now.month &&
            transaction.date.year == now.year;
      }).toList();
    }

    setState(() {
      filteredTransactions = filtered;
      selectedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        toolbarHeight: 2,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Manually trigger the refresh when the icon button is pressed
              setState(() {
                isLoading = true;
              });
              fetchHourlyBalanceData(); // Refresh the hourly balance data
              fetchTransactions(); // Refresh transactions
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Today'),
            Tab(text: 'This Week'),
            Tab(text: 'This Month'),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                filterTransactions('Today');
                break;
              case 1:
                filterTransactions('This Week');
                break;
              case 2:
                filterTransactions('This Month');
                break;
            }
          },
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _onRefresh, // Trigger the refresh when pulled
              child: CustomScrollView(
                slivers: [
                  // Header Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 10,
                      ),
                      child: Text(
                        "$selectedFilter Transactions",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  // List of Transactions
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final transaction = filteredTransactions[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 10,
                                      right: 10,
                                      top: 20,
                                    ),
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 253, 242, 195),
                                        borderRadius: BorderRadius.circular(60),
                                      ),
                                      child: Center(
                                        child: Icon(Icons
                                            .food_bank), // Replace with category icon
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        transaction.category,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${transaction.date.day}-${transaction.date.month}-${transaction.date.year} ${transaction.date.hour}:${transaction.date.minute}",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (transaction.description != null)
                                        Text(
                                          transaction.description!,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(width: 10),
                              Text(
                                transaction.type == 'income'
                                    ? "+ LKR ${transaction.amount.toStringAsFixed(2)}"
                                    : "- LKR ${transaction.amount.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: transaction.type == 'income'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: filteredTransactions.length,
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Income & Expenses",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            height: 400, // Adjust based on your needs
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: FinancialTrackerCharts(
                              transactions: filteredTransactions,
                              selectedFilter: selectedFilter,
                            ),
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),

                  // Adding PieChart (Expenses Statistics)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Expenses Statistics",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            height: 300 + (filteredTransactions.length * 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: PieChartSample2(
                                transactions:
                                    filteredTransactions), // Pass transactions to PieChartSample2
                          ),
                          SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
