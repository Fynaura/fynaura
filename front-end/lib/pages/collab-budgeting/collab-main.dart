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

class CollabMainState extends State<CollabMain> {
  List<Map<String, dynamic>> createdBudgets = []; // Store created budgets
  bool isLoading = true;
  String? errorMessage;
  final BudgetService _budgetService = BudgetService();

  @override
  void initState() {
    super.initState();
    _loadBudgets();
  }

  // Load budgets from the API
  Future<void> _loadBudgets() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final budgets = await _budgetService.getBudgets();
      setState(() {
        createdBudgets = budgets;
        isLoading = false;
      });
    } catch (e) {
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
      double parsedAmount = double.parse(amount);
      String? userId = uid; //sample user for now

      await _budgetService.createBudget(name, parsedAmount, date, userId);
      await _loadBudgets();
    } catch (e) {
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
      ),
      body: RefreshIndicator(
        onRefresh: _loadBudgets,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Budget Plan",
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Color(0xFF85C1E5),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Pinned Plans",
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFF85C1E5),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    "No plans pinned yet",
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFFDADADA),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Created Plans",
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFF85C1E5),
                  ),
                ),
                const SizedBox(height: 20),

                // Show error message if any
                if (errorMessage != null)
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),

                // Show loading indicator
                if (isLoading)
                  Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF85C1E5),
                    ),
                  ),

                // Show budgets if available
                if (!isLoading && createdBudgets.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        "No budgets created yet",
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFFDADADA),
                        ),
                      ),
                    ),
                  ),

                // Budget list
                if (!isLoading && createdBudgets.isNotEmpty)
                  Column(
                    children: createdBudgets.map((budget) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BudgetDetails(
                                budgetName: budget["name"] ?? "",
                                budgetAmount: budget["amount"].toString(),
                                budgetDate: budget["date"] ?? "",
                                budgetId: budget["id"]
                                    .toString(), // Add this parameter
                              ),
                            ),
                          ).then((_) => _loadBudgets());
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => BudgetDetails(
                          //       budgetName: budget["name"] ?? "",
                          //       budgetAmount: budget["amount"].toString(),
                          //       budgetDate: budget["date"] ?? "",
                          //     ),
                          //   ),
                          // ).then((_) => _loadBudgets()); // Reload after returning from details
                        },
                        child: Dismissible(
                          key: Key(budget["id"]?.toString() ??
                              UniqueKey().toString()),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Confirm"),
                                  content: Text(
                                      "Are you sure you want to delete this budget?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text("Delete",
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          onDismissed: (direction) {
                            _deleteBudget(budget["id"].toString());
                          },
                          child: Card(
                            elevation: 3,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    budget["name"] ?? "Unnamed Budget",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  LinearProgressIndicator(
                                    value: 1.0,
                                    backgroundColor: Color(0xFF85C1E5),
                                    color: Color(0xFF85C1E5),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "LKR ${budget["amount"].toString()}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          // Due date removed as requested
                                        ],
                                      ),
                                      Spacer(),
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundImage:
                                            AssetImage("images/user.png"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 20),

                CustomButton(
                  text: "Create a New Budget",
                  backgroundColor: const Color(0xFF85C1E5),
                  textColor: Colors.white,
                  onPressed: () {
                    _showCreateBudgetPopup(context);
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
