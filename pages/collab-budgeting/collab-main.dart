import 'package:flutter/material.dart';
import 'package:fynaura/pages/collab-budgeting/budgetDetails.dart';
import 'package:fynaura/pages/user-session/UserSession.dart';
import 'package:fynaura/widgets/CustomButton.dart';
import 'package:fynaura/widgets/backBtn.dart';
import 'package:fynaura/services/budget_service.dart';
import 'package:fynaura/widgets/CustomPopup.dart';

class CollabMain extends StatefulWidget {
  const CollabMain({super.key});

  @override
  State<CollabMain> createState() => CollabMainState();
}

class CollabMainState extends State<CollabMain> with SingleTickerProviderStateMixin {
  // Define app's color palette based on other screens
  static const Color primaryColor = Color(0xFF254e7a);     // Primary blue
  static const Color accentColor = Color(0xFF85c1e5);      // Light blue accent
  static const Color lightBgColor = Color(0xFFEBF1FD);     // Light background
  static const Color whiteColor = Colors.white;            // White background

  List<Map<String, dynamic>> createdBudgets = []; // Store created budgets
  List<Map<String, dynamic>> pinnedBudgets = []; // Store pinned budgets
  bool isLoading = true;
  String? errorMessage;
  final BudgetService _budgetService = BudgetService();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // For All/Pinned tabs
    _loadBudgets();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Load budgets from the API
  Future<void> _loadBudgets() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final budgets = await _budgetService.getBudgets();
      print('Loaded budgets: $budgets');

      setState(() {
        createdBudgets = budgets;
        // For demo purposes, let's simulate having pinned budgets
        pinnedBudgets = budgets.length > 1 
            ? [budgets[0]] 
            : [];
        isLoading = false;
      });
    } catch (e) {
      print('Error loading budgets: $e');
      setState(() {
        errorMessage = "Failed to load budgets: ${e.toString()}";
        isLoading = false;
      });
    }
  }

  Future<void> _addBudget(String name, String amount, String date) async {
    try {
      final userSession = UserSession();
      final uid = userSession.userId;

      if (amount.isEmpty) {
        setState(() {
          errorMessage = "Amount cannot be empty";
        });
        return;
      }

      double parsedAmount;
      try {
        parsedAmount = double.parse(amount);
      } catch (e) {
        setState(() {
          errorMessage = "Invalid amount format";
        });
        return;
      }

      String? userId = uid;

      final newBudget = await _budgetService.createBudget(name, parsedAmount, date, userId);
      print('Budget created successfully: $newBudget');

      await _loadBudgets();
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Budget created successfully!"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      print('Error in _addBudget: $e');
      setState(() {
        errorMessage = "Failed to create budget: ${e.toString()}";
      });
    }
  }

  Future<void> _deleteBudget(String? id) async {
    if (id == null || id == "null" || id.isEmpty) {
      setState(() {
        errorMessage = "Cannot delete: Invalid budget ID";
      });
      return;
    }

    try {
      print("Attempting to delete budget with ID: $id");
      // If the ID includes the ObjectId wrapper, extract just the hex string
      if (id.startsWith("ObjectId('") && id.endsWith("')")) {
        id = id.substring(10, id.length - 2);
      }
      await _budgetService.deleteBudget(id);
      await _loadBudgets();
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Budget deleted successfully"),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      setState(() {
        errorMessage = "Failed to delete budget: ${e.toString()}";
      });
    }
  }

  void _showCreateBudgetPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomPopup(onBudgetCreated: _addBudget);
      },
    ).then((_) {
      // Force reload budgets when dialog is closed
      _loadBudgets();
    });
  }

  // Determine icon based on budget name keywords
  IconData _getBudgetIcon(String budgetName) {
    final name = budgetName.toLowerCase();
    if (name.contains('house') || name.contains('home') || name.contains('rent')) {
      return Icons.home;
    } else if (name.contains('car') || name.contains('vehicle') || name.contains('transport')) {
      return Icons.directions_car;
    } else if (name.contains('education') || name.contains('school') || name.contains('college')) {
      return Icons.school;
    } else if (name.contains('travel') || name.contains('vacation') || name.contains('trip')) {
      return Icons.flight;
    } else if (name.contains('wedding') || name.contains('marriage')) {
      return Icons.favorite;
    } else if (name.contains('device') || name.contains('phone') || name.contains('tech')) {
      return Icons.devices;
    } else if (name.contains('food') || name.contains('grocery') || name.contains('restaurant')) {
      return Icons.restaurant;
    } else if (name.contains('health') || name.contains('medical')) {
      return Icons.medical_services;
    } else if (name.contains('bills') || name.contains('utilities')) {
      return Icons.receipt;
    }
    return Icons.account_balance_wallet;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Collaborative Budgeting',
          style: TextStyle(
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: whiteColor),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: whiteColor),
            onPressed: _loadBudgets,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: TabBar(
            controller: _tabController,
            labelColor: whiteColor,
            unselectedLabelColor: whiteColor.withOpacity(0.7),
            indicatorColor: accentColor,
            indicatorWeight: 3.0,
            tabs: [
              Tab(text: 'All Budgets'),
              Tab(text: 'Pinned'),
            ],
          ),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: Container(
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: RefreshIndicator(
            color: primaryColor,
            onRefresh: _loadBudgets,
            child: TabBarView(
              controller: _tabController,
              children: [
                // All Budgets Tab
                _buildBudgetList(createdBudgets),
                
                // Pinned Budgets Tab
                _buildBudgetList(pinnedBudgets, isPinnedTab: true),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateBudgetPopup(context),
        backgroundColor: primaryColor,
        foregroundColor: whiteColor,
        elevation: 4,
        icon: Icon(Icons.add),
        label: Text("Create Budget"),
      ),
    );
  }

  // Corrected parts of the CollabMain class to show remaining percentage in progress bars

  Widget _buildBudgetList(List<Map<String, dynamic>> budgets, {bool isPinnedTab = false}) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header for the section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPinnedTab ? Icons.push_pin : Icons.account_balance_wallet,
                  color: whiteColor
                ),
                SizedBox(width: 8),
                Text(
                  isPinnedTab ? "Pinned Budgets" : "Your Budgets",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: whiteColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // Error message if any
          if (errorMessage != null)
            Container(
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.red.shade300, width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red.shade800),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red.shade800),
                    onPressed: () {
                      setState(() {
                        errorMessage = null;
                      });
                    },
                  )
                ],
              ),
            ),

          // Loading indicator
          if (isLoading)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  CircularProgressIndicator(color: primaryColor),
                  SizedBox(height: 20),
                  Text(
                    "Loading budgets...",
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          // Empty state
          if (!isLoading && budgets.isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  Icon(
                    isPinnedTab ? Icons.push_pin_outlined : Icons.account_balance_wallet_outlined,
                    size: 70,
                    color: accentColor.withOpacity(0.5),
                  ),
                  SizedBox(height: 20),
                  Text(
                    isPinnedTab ? "No pinned budgets yet" : "No budgets created yet",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    isPinnedTab 
                        ? "Pin your important budgets for quick access"
                        : "Create your first budget to start managing your finances",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (!isPinnedTab) SizedBox(height: 30),
                  if (!isPinnedTab) 
                    ElevatedButton.icon(
                      onPressed: () => _showCreateBudgetPopup(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: whiteColor,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      icon: Icon(Icons.add_circle),
                      label: Text("Create First Budget"),
                    ),
                ],
              ),
            ),

          // Budget list
          if (!isLoading && budgets.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: budgets.length,
              itemBuilder: (context, index) {
                final budget = budgets[index];
                final budgetName = budget["name"] ?? "Unnamed Budget";
                final budgetAmount = double.tryParse(budget["amount"].toString()) ?? 0.0;
                
                // Use the percentage from the server (or default to 100% if not available)
                // Divide by 100 to get a value between 0 and 1 for the progress indicator
                final remainPercentage = (budget["remainPercentage"] ?? 100.0) / 100;
                // Calculate the spent percentage (inverse of remaining percentage)
                final spentPercentage = 1.0 - remainPercentage;
                // Calculate the spent amount
                final spentAmount = budgetAmount * spentPercentage;
                // Calculate the remaining amount
                final remainingAmount = budgetAmount * remainPercentage;
                
                return Dismissible(
                  key: Key(budget["id"]?.toString() ?? UniqueKey().toString()),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(Icons.delete, color: whiteColor),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Confirm Deletion"),
                          content: Text("Are you sure you want to delete this budget?"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text("Delete", style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (direction) {
                    _deleteBudget(budget["id"].toString());
                  },
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BudgetDetails(
                            budgetName: budgetName,
                            budgetAmount: budget["amount"].toString(),
                            budgetDate: budget["date"] ?? "",
                            budgetId: budget["id"].toString(),
                          ),
                        ),
                      ).then((_) => _loadBudgets());
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primaryColor.withOpacity(0.8),
                            primaryColor,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Budget header with title and owner
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: whiteColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      _getBudgetIcon(budgetName),
                                      color: whiteColor,
                                      size: 22,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        budgetName,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: whiteColor,
                                        ),
                                      ),
                                      Text(
                                        "Due: ${budget["date"] ?? "Not set"}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: whiteColor.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage("images/user.png"),
                                backgroundColor: whiteColor,
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          
                          // Budget amount display
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Total Budget",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: whiteColor.withOpacity(0.7),
                                    ),
                                  ),
                                  Text(
                                    "LKR ${budgetAmount.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    isPinnedTab ? Icons.push_pin : Icons.push_pin_outlined,
                                    color: whiteColor.withOpacity(0.7),
                                    size: 18,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    isPinnedTab ? "Pinned" : "Pin",
                                    style: TextStyle(
                                      color: whiteColor.withOpacity(0.7),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 14),
                          
                          // Progress bar with REMAINING percentage
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Spent: LKR ${spentAmount.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: whiteColor.withOpacity(0.8),
                                    ),
                                  ),
                                  Text(
                                    "Remaining: LKR ${remainingAmount.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: whiteColor.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: remainPercentage, // Use the REMAINING percentage value
                                  backgroundColor: whiteColor.withOpacity(0.2),
                                  color: remainPercentage < 0.2
                                      ? Colors.red.shade300
                                      : remainPercentage < 0.4
                                          ? Colors.orange.shade300
                                          : Colors.green.shade300,
                                  minHeight: 10,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "${(remainPercentage * 100).toStringAsFixed(0)}% remaining",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: whiteColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          
                          // Actions
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                icon: Icon(Icons.visibility, size: 16),
                                label: Text("View Details"),
                                style: TextButton.styleFrom(
                                  foregroundColor: whiteColor,
                                  backgroundColor: whiteColor.withOpacity(0.2),
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BudgetDetails(
                                        budgetName: budgetName,
                                        budgetAmount: budget["amount"].toString(),
                                        budgetDate: budget["date"] ?? "",
                                        budgetId: budget["id"].toString(),
                                      ),
                                    ),
                                  ).then((_) => _loadBudgets());
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          
          // Space at bottom for FAB
          SizedBox(height: 80),
        ],
      ),
    );
  }
}