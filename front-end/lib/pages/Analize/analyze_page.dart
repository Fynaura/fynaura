import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fynaura/pages/Analize/TransactionModel.dart';
import 'package:fynaura/pages/user-session/UserSession.dart';
import 'package:fynaura/widgets/stats/bar_cart.dart';
import 'package:http/http.dart' as http;
import 'package:fynaura/widgets/analyze/money_chart.dart'; // Import MoneyChart
import 'package:fynaura/widgets/analyze/pie_chart.dart'; // Import PieChart
import 'package:intl/intl.dart'; // For date formatting
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// Define Sri Lanka time zone constant
const String SRI_LANKA_TIMEZONE = 'Asia/Colombo';

class AnalyzePage extends StatefulWidget {
  const AnalyzePage({super.key});

  @override
  State<AnalyzePage> createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage>
    with SingleTickerProviderStateMixin {
  // Define app's color palette based on TransactionDetailsPage
  static const Color primaryColor = Color(0xFF254e7a);     // Primary blue
  static const Color accentColor = Color(0xFF85c1e5);      // Light blue accent
  static const Color lightBgColor = Color(0xFFEBF1FD);     // Light background
  static const Color whiteColor = Colors.white;            // White background
  
  List<Transaction> transactions = [];
  bool isLoading = true;
  List<Map<String, dynamic>> hourlyBalanceData = [];
  List<Transaction> filteredTransactions = [];
  String selectedFilter = 'Today'; // Default filter is Today
  late TabController _tabController;
  
  // Create date formatter for Sri Lanka time
  final DateFormat timeFormatter = DateFormat('dd-MM-yyyy HH:mm');
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 3, vsync: this); // Create a TabController with 3 tabs
    
    // Initialize time zones
    _initTimeZones();
    
    fetchHourlyBalanceData(); // Load hourly balance data when the page loads
    fetchTransactions(); // Fetch transactions for the list
  }
  
  // Initialize time zones
  void _initTimeZones() {
    try {
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation(SRI_LANKA_TIMEZONE));
    } catch (e) {
      print('Error initializing time zones: $e');
    }
  }

  // Get current Sri Lanka time
  tz.TZDateTime get sriLankaTime => tz.TZDateTime.now(tz.getLocation(SRI_LANKA_TIMEZONE));

  // Convert DateTime to a formatted string with Sri Lanka time zone
  String formatSriLankaTime(DateTime dateTime) {
    // Convert to Sri Lanka time zone
    final sriLankaDateTime = tz.TZDateTime.from(
      dateTime, 
      tz.getLocation(SRI_LANKA_TIMEZONE)
    );
    
    return timeFormatter.format(sriLankaDateTime);
  }

  // Fetch hourly balance data from the backend
  Future<void> fetchHourlyBalanceData() async {

    final response = await http.get(
        Uri.parse('http://ec2-13-213-44-124.ap-southeast-1.compute.amazonaws.com:3000/transaction/hourly-balance'));

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
        .get(Uri.parse('http://ec2-13-213-44-124.ap-southeast-1.compute.amazonaws.com:3000/transaction/$uid'));


    if (response.statusCode == 200) {
      // Parse the JSON response and map it to Transaction model
      List<dynamic> data = json.decode(response.body);
      setState(() {
        transactions = data.map((json) => Transaction.fromJson(json)).toList();
        // Sort all transactions by date (newest first) right after fetching
        transactions.sort((a, b) => b.date.compareTo(a.date));
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
    // Get current date in Sri Lanka time zone
    tz.TZDateTime now = sriLankaTime;
    List<Transaction> filtered = [];

    if (filter == 'Today') {
      filtered = transactions.where((transaction) {
        // Convert transaction date to Sri Lanka time zone
        final txDate = tz.TZDateTime.from(transaction.date, tz.getLocation(SRI_LANKA_TIMEZONE));
        return txDate.day == now.day &&
            txDate.month == now.month &&
            txDate.year == now.year;
      }).toList();
    } else if (filter == 'This Week') {
      // Calculate the start of the week (Sunday) and end of the week (Saturday) in Sri Lanka time
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday % 7));
      startOfWeek = tz.TZDateTime(
        tz.getLocation(SRI_LANKA_TIMEZONE),
        startOfWeek.year, 
        startOfWeek.month, 
        startOfWeek.day
      );
      
      DateTime endOfWeek = tz.TZDateTime(
        tz.getLocation(SRI_LANKA_TIMEZONE),
        startOfWeek.year, 
        startOfWeek.month, 
        startOfWeek.day + 6,
        23, 59, 59
      );
      
      filtered = transactions.where((transaction) {
        // Convert transaction date to Sri Lanka time zone
        final txDate = tz.TZDateTime.from(transaction.date, tz.getLocation(SRI_LANKA_TIMEZONE));
        return txDate.isAfter(startOfWeek.subtract(Duration(seconds: 1))) && 
               txDate.isBefore(endOfWeek.add(Duration(seconds: 1)));
      }).toList();
    } else if (filter == 'This Month') {
      filtered = transactions.where((transaction) {
        // Convert transaction date to Sri Lanka time zone
        final txDate = tz.TZDateTime.from(transaction.date, tz.getLocation(SRI_LANKA_TIMEZONE));
        return txDate.month == now.month &&
            txDate.year == now.year;
      }).toList();
    }

    // Sort the filtered transactions by date (newest first)
    filtered.sort((a, b) => b.date.compareTo(a.date));

    setState(() {
      filteredTransactions = filtered;
      selectedFilter = filter;
    });
  }

  // Helper function to get an icon for the transaction category
  IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'grocery':
        return Icons.shopping_basket;
      case 'food':
        return Icons.restaurant;
      case 'entertainment':
        return Icons.movie;
      case 'transport':
        return Icons.directions_car;
      case 'utilities':
        return Icons.power;
      case 'shopping':
        return Icons.shopping_bag;
      case 'education':
        return Icons.school;
      case 'health':
        return Icons.medical_services;
      case 'subscriptions':
        return Icons.subscriptions;
      case 'salary':
        return Icons.account_balance_wallet;
      case 'rent':
        return Icons.home;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: whiteColor,
        toolbarHeight: 2,
        centerTitle: true,
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: whiteColor),
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
          indicatorColor: accentColor,
          labelColor: whiteColor,
          unselectedLabelColor: whiteColor.withOpacity(0.7),
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
      backgroundColor: whiteColor,
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : RefreshIndicator(
              color: primaryColor,
              onRefresh: _onRefresh, // Trigger the refresh when pulled
              child: CustomScrollView(
                slivers: [
                  // Header Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 15,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.access_time, color: whiteColor),
                            SizedBox(width: 8),
                            Text(
                              "$selectedFilter Transactions",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // List of Transactions
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final transaction = filteredTransactions[index];
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: lightBgColor,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          getCategoryIcon(transaction.category),
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          transaction.category,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                          ),
                                        ),
                                        Text(
                                          formatSriLankaTime(transaction.date),
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        if (transaction.description != null)
                                          Text(
                                            transaction.description!,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
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
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.insert_chart, color: whiteColor),
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
                          Container(
                            height: 400, // Adjust based on your needs
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: whiteColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0, 1),
                                ),
                              ],
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
                                  "Expenses Statistics",
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
                          Container(
                            height: 350 + (filteredTransactions.length * 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: whiteColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0, 1),
                                ),
                              ],
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