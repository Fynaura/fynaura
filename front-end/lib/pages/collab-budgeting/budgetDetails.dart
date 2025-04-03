import 'package:flutter/material.dart';
import 'package:fynaura/widgets/backBtn.dart';
import 'package:fynaura/services/budget_service.dart';
import 'package:fynaura/pages/user-session/UserSession.dart';
import 'package:intl/intl.dart';

class BudgetDetails extends StatefulWidget {
  final String budgetName;
  final String budgetAmount;
  final String budgetDate;
  final String budgetId;

  const BudgetDetails({
    super.key,
    required this.budgetName,
    required this.budgetAmount,
    required this.budgetDate,
    required this.budgetId,
  });

  @override
  State<BudgetDetails> createState() => _BudgetDetailsState();
}

class _BudgetDetailsState extends State<BudgetDetails> {
  // Define app's color palette based on other screens
  static const Color primaryColor = Color(0xFF254e7a);     // Primary blue
  static const Color accentColor = Color(0xFF85c1e5);      // Light blue accent
  static const Color lightBgColor = Color(0xFFEBF1FD);     // Light background
  static const Color whiteColor = Colors.white;            // White background
  static const Color darkColor = Color(0xFF26252A);        // Dark background for cards
  
  List<String> avatars = ["images/user.png"]; // Initial avatar list
  final BudgetService _budgetService = BudgetService();
  final UserSession _userSession = UserSession();
  
  // Format currency
  final currencyFormatter = NumberFormat("#,##0", "en_US");

  // Track the current balance and activities
  late double currentAmount;
  late double initialAmount;
  double percentageRemaining = 100;
  
  // List to store activities
  List<Map<String, dynamic>> activities = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    // Initialize the current amount from the budget amount passed from collab main
    currentAmount = double.tryParse(widget.budgetAmount.replaceAll(',', '')) ?? 50000;
    initialAmount = currentAmount; // Store initial amount to calculate percentage

    // Load budget details including percentage
    _loadBudgetDetails();
    
    // Load transactions
    _loadTransactions();
  }
  
  // Load full budget details including the percentage remaining
  Future<void> _loadBudgetDetails() async {
    try {
      final budgetDetails = await _budgetService.getBudgetDetails(widget.budgetId);
      
      setState(() {
        // Update percentage remaining from the server
        percentageRemaining = budgetDetails['remainPercentage'] ?? 100;
        
        // Update current amount based on the percentage
        currentAmount = initialAmount * (percentageRemaining / 100);
      });
    } catch (e) {
      print('Failed to load budget details: $e');
      // Fall back to calculating percentage locally if server fails
      _calculatePercentageLocally();
    }
  }
  
  // Calculate percentage remaining locally based on transactions
  void _calculatePercentageLocally() {
    double totalExpenses = 0;
    double totalIncome = 0;
    
    for (var activity in activities) {
      final amount = double.tryParse(activity['amount'].toString().replaceAll('LKR ', '')) ?? 0;
      if (activity['isExpense']) {
        totalExpenses += amount;
      } else {
        totalIncome += amount;
      }
    }
    
    final currentAmount = initialAmount - totalExpenses + totalIncome;
    final percentage = (currentAmount / initialAmount) * 100;
    
    setState(() {
      this.currentAmount = currentAmount;
      percentageRemaining = percentage.clamp(0, 100);
    });
  }

  Future<void> _loadCollaborators() async {
    try {
      final collaborators = await _budgetService.getCollaborators(widget.budgetId);
      setState(() {
        // Update avatars based on collaborators
        avatars = collaborators.map((collaborator) => "images/user.png").toList();
        if (!avatars.contains("images/user.png")) {
          avatars.add("images/user.png"); // Ensure at least one avatar
        }
      });
    } catch (e) {
      print('Failed to load collaborators: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCollaborators();
  }

  Future<void> _loadTransactions() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    
    try {
      final transactions = await _budgetService.getTransactions(widget.budgetId);

      setState(() {
        activities = transactions.map((transaction) {
          return {
            "avatar": "images/user.png",
            "name": transaction["addedBy"] ?? "Unknown",
            "description": transaction["description"] ?? "",
            "amount": "LKR ${transaction["amount"].toString()}",
            "isExpense": transaction["isExpense"] ?? true,
            "timestamp": transaction["timestamp"] ?? DateTime.now().toString(),
          };
        }).toList();
        
        // Sort activities by timestamp if available
        activities.sort((a, b) {
          try {
            final aTime = DateTime.parse(a["timestamp"]);
            final bTime = DateTime.parse(b["timestamp"]);
            return bTime.compareTo(aTime); // Most recent first
          } catch (e) {
            return 0;
          }
        });
        
        isLoading = false;
      });
      
      // Get the latest percentage after loading transactions
      _refreshPercentage();
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load transactions: $e";
        isLoading = false;
      });
      print("Failed to load transactions: $e");
    }
  }
  
  // Refresh the percentage from the server
  Future<void> _refreshPercentage() async {
    try {
      final percentage = await _budgetService.getRemainingPercentage(widget.budgetId);
      setState(() {
        percentageRemaining = percentage;
        // Update current amount based on the percentage
        currentAmount = initialAmount * (percentageRemaining / 100);
      });
    } catch (e) {
      print('Failed to refresh percentage: $e');
      // If server fails, calculate locally as fallback
      _calculatePercentageLocally();
    }
  }

  // Refresh all data
  Future<void> _refreshAllData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    
    try {
      await _loadBudgetDetails();
      await _loadTransactions();
      await _loadCollaborators();
      
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to refresh data: $e";
        isLoading = false;
      });
    }
  }

  void _addAvatar() {
    final TextEditingController searchController = TextEditingController();
    final TextEditingController userIdController = TextEditingController();
    bool isLoading = false;
    String? errorMessage;
    List<Map<String, dynamic>> searchResults = [];
    bool isSearching = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Get screen size to ensure dialog fits
        final screenSize = MediaQuery.of(context).size;
        final maxHeight = screenSize.height * 0.8; // 80% of screen height

        return StatefulBuilder(
          builder: (context, setState) {
            // Search function
            Future<void> performSearch(String query) async {
              if (query.isEmpty) {
                setState(() {
                  searchResults = [];
                  isSearching = false;
                  errorMessage = null;
                });
                return;
              }

              // Only search when there are at least 2 characters
              if (query.length < 2) return;

              setState(() {
                isLoading = true;
                isSearching = true;
                errorMessage = null;
              });

              try {
                final results = await _budgetService.searchUsers(query);

                // Filter out current user
                final filteredResults = results.where(
                        (user) => user["userId"] != _userSession.userId
                ).toList();

                setState(() {
                  searchResults = filteredResults;
                  isLoading = false;
                });
              } catch (e) {
                setState(() {
                  errorMessage = "Error searching: $e";
                  isLoading = false;
                });
              }
            }

            // Add collaborator function
            Future<void> addCollaborator(String userId) async {
              if (userId.isEmpty) {
                setState(() {
                  errorMessage = "Please enter a user ID";
                });
                return;
              }

              // Don't allow adding yourself as a collaborator
              if (userId == _userSession.userId) {
                setState(() {
                  errorMessage = "You cannot add yourself as a collaborator";
                });
                return;
              }

              setState(() {
                isLoading = true;
                errorMessage = null;
              });

              try {
                // Check if user exists
                final userExists = await _budgetService.checkUserExists(userId);

                if (!userExists) {
                  setState(() {
                    isLoading = false;
                    errorMessage = "User does not exist";
                  });
                  return;
                }

                // Add collaborator to budget
                await _budgetService.addCollaborator(
                  widget.budgetId,
                  userId,
                );

                // Update the UI state
                this.setState(() {
                  avatars.add("images/user.png"); // Add new avatar
                  _loadCollaborators(); // Reload collaborators
                });

                Navigator.pop(context); // Close the popup

                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 10),
                        Text("Collaborator added successfully"),
                      ],
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    duration: Duration(seconds: 3),
                  ),
                );
              } catch (e) {
                setState(() {
                  isLoading = false;
                  errorMessage = "Failed to add collaborator: $e";
                });
              }
            }

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 5,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: maxHeight,
                  maxWidth: 380, // Reduced width to prevent horizontal overflow
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Fixed header section
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryColor, primaryColor.withOpacity(0.8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: whiteColor.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person_add,
                              color: whiteColor,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Invite Collaborators",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: whiteColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: whiteColor),
                            onPressed: () => Navigator.pop(context),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                    
                    // Scrollable content
                    Flexible(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Description text
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: lightBgColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline, color: primaryColor, size: 20),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "Invite friends to collaborate on \"${widget.budgetName}\" budget",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),

                            // Search section
                            Text(
                              "Search by name or user ID",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: primaryColor,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: searchController,
                                decoration: InputDecoration(
                                  hintText: "Type to search...",
                                  prefixIcon: Icon(Icons.search, color: primaryColor),
                                  suffixIcon: searchController.text.isNotEmpty
                                      ? IconButton(
                                    icon: Icon(Icons.clear, color: Colors.grey),
                                    onPressed: () {
                                      searchController.clear();
                                      setState(() {
                                        searchResults = [];
                                        errorMessage = null;
                                      });
                                    },
                                  )
                                      : null,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: whiteColor,
                                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                ),
                                onChanged: performSearch,
                              ),
                            ),

                            // Error message if any
                            if (errorMessage != null)
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.error_outline, color: Colors.red, size: 16),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        errorMessage!,
                                        style: TextStyle(color: Colors.red.shade800, fontSize: 12),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.close, color: Colors.red.shade800, size: 14),
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                      onPressed: () {
                                        setState(() {
                                          errorMessage = null;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),

                            SizedBox(height: 12),

                            // Search results with loading state
                            if (isLoading)
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  child: Column(
                                    children: [
                                      CircularProgressIndicator(color: primaryColor),
                                      SizedBox(height: 10),
                                      Text(
                                        "Searching...",
                                        style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else if (isSearching && searchResults.isEmpty)
                              Container(
                                padding: EdgeInsets.all(16),
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: lightBgColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(Icons.search_off, color: Colors.grey, size: 30),
                                      SizedBox(height: 8),
                                      Text(
                                        "No matching users found",
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Try a different search term",
                                        style: TextStyle(color: Colors.grey, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else if (searchResults.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4, bottom: 8),
                                    child: Text(
                                      "Search Results (${searchResults.length})",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: primaryColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: lightBgColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    // Limit the height to avoid overflow
                                    constraints: BoxConstraints(
                                      maxHeight: 180, // Limit the height of search results
                                    ),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: searchResults.length,
                                      itemBuilder: (context, index) {
                                        final user = searchResults[index];
                                        return Container(
                                          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                          decoration: BoxDecoration(
                                            color: whiteColor,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.03),
                                                blurRadius: 2,
                                                offset: Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: ListTile(
                                            contentPadding: EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 4, // Reduced vertical padding
                                            ),
                                            leading: CircleAvatar(
                                              backgroundImage: AssetImage("images/user.png"),
                                              backgroundColor: accentColor.withOpacity(0.2),
                                              radius: 18, // Smaller avatar
                                              child: user["displayName"] != null && user["displayName"].isNotEmpty
                                                  ? null
                                                  : Icon(Icons.person, color: primaryColor, size: 18),
                                            ),
                                            title: Text(
                                              user["displayName"] ?? "User ${user["userId"]}",
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                            ),
                                            subtitle: user["email"] != null && user["email"].isNotEmpty
                                                ? Text(user["email"], style: TextStyle(fontSize: 12))
                                                : Text("ID: ${user["userId"]}", style: TextStyle(fontSize: 12)),
                                            trailing: ElevatedButton.icon(
                                              icon: Icon(Icons.add, size: 14),
                                              label: Text("Add", style: TextStyle(fontSize: 12)),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: primaryColor,
                                                foregroundColor: whiteColor,
                                                elevation: 0,
                                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                                minimumSize: Size(60, 30), // Smaller button
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              onPressed: () => addCollaborator(user["userId"]),
                                            ),
                                            onTap: () => addCollaborator(user["userId"]),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),

                            Divider(height: 24, thickness: 1, color: Colors.grey.withOpacity(0.2)),

                            // Direct entry section - more compact
                            Text(
                              "Add by User ID",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: primaryColor,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 5,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: TextField(
                                      controller: userIdController,
                                      decoration: InputDecoration(
                                        hintText: "Enter user ID",
                                        prefixIcon: Icon(Icons.person_outline, color: primaryColor),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        fillColor: whiteColor,
                                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                ElevatedButton(
                                  child: Text("Add"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: whiteColor,
                                    elevation: 2,
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (userIdController.text.isNotEmpty) {
                                      addCollaborator(userIdController.text);
                                    } else {
                                      setState(() {
                                        errorMessage = "Please enter a user ID";
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Updated method to add transaction
  // Updated method to add transaction
  void _showAddTransactionDialog() {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    bool isExpense = true;

    // Get current user's name from UserSession
    final String currentUserName = _userSession.displayName ?? "Anonymous";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isExpense ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            isExpense ? Icons.remove_circle : Icons.add_circle,
                            size: 24,
                            color: isExpense ? Colors.red : Colors.green,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          isExpense ? "Add Expense" : "Add Income",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.black54),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    
                    // Transaction type toggle
                    Container(
                      decoration: BoxDecoration(
                        color: lightBgColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isExpense = true;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isExpense ? primaryColor : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    "Expense",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isExpense ? whiteColor : primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isExpense = false;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: !isExpense ? primaryColor : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    "Income",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: !isExpense ? whiteColor : primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    
                    // Amount field
                    Text(
                      "Amount",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            "LKR",
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        hintText: "0.00",
                        filled: true,
                        fillColor: lightBgColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // Description field
                    Text(
                      "Description",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        hintText: "What is this for?",
                        filled: true,
                        fillColor: lightBgColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    
                    // Add button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: whiteColor,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () async {
                        // Get amount from controller
                        double amount = double.tryParse(amountController.text) ?? 0;
                        if (amount <= 0 || descriptionController.text.isEmpty) {
                          // Show error
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please enter valid amount and description"),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                          return;
                        }

                        try {
                          // Add transaction and get updated budget data
                          final updatedBudget = await _budgetService.addTransaction(
                              widget.budgetId,
                              descriptionController.text,
                              amount,
                              isExpense,
                              currentUserName
                          );
                          
                          // Update percentage from server
                          this.setState(() {
                            // Get percentage from server response
                            percentageRemaining = updatedBudget['remainPercentage'] ?? 100;
                            
                            // Calculate current amount based on percentage
                            currentAmount = initialAmount * (percentageRemaining / 100);
                          });
                          
                          // Reload transactions
                          _loadTransactions();

                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Failed to add transaction: $e"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Add Transaction",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((_) async {
      // After dialog is closed, refresh percentage from server
      await _refreshPercentage();
    });
  }

  String _getCategoryIcon(String description) {
    final desc = description.toLowerCase();
    if (desc.contains('food') || desc.contains('restaurant') || desc.contains('eat')) {
      return '🍔';
    } else if (desc.contains('travel') || desc.contains('gas') || desc.contains('taxi')) {
      return '🚗';
    } else if (desc.contains('shopping') || desc.contains('clothes') || desc.contains('buy')) {
      return '🛍️';
    } else if (desc.contains('bill') || desc.contains('utility') || desc.contains('rent')) {
      return '📃';
    } else if (desc.contains('health') || desc.contains('medical') || desc.contains('doctor')) {
      return '🏥';
    } else if (desc.contains('entertainment') || desc.contains('movie') || desc.contains('fun')) {
      return '🎭';
    } else if (desc.contains('education') || desc.contains('book') || desc.contains('school')) {
      return '📚';
    } else if (desc.contains('gift') || desc.contains('present')) {
      return '🎁';
    } else if (desc.contains('salary') || desc.contains('income') || desc.contains('payment')) {
      return '💸';
    }
    return '💰';
  }

  @override
  Widget build(BuildContext context) {
    // Format the current amount for display
    String formattedCurrentAmount = currencyFormatter.format(currentAmount);

    return Scaffold(
      backgroundColor: lightBgColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CustomBackButton(),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: primaryColor),
            onPressed: _loadTransactions,
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Budget Card - Redesigned with gradient and better layout
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, Color(0xFF1a3b5c)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Budget Name and Date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: whiteColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.account_balance_wallet,
                                    color: whiteColor,
                                    size: 16,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    widget.budgetName,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: whiteColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: whiteColor,
                                    size: 14,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    widget.budgetDate,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25),
                        
                        // Balance Row with Percentage
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Current Balance",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: whiteColor.withOpacity(0.7),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "LKR $formattedCurrentAmount",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: whiteColor,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Initial Budget: LKR ${currencyFormatter.format(initialAmount)}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: whiteColor.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      child: CircularProgressIndicator(
                                        value: percentageRemaining / 100,
                                        strokeWidth: 6,
                                        backgroundColor: whiteColor.withOpacity(0.2),
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          percentageRemaining > 60 
                                              ? Colors.greenAccent 
                                              : percentageRemaining > 25 
                                                  ? Colors.orangeAccent 
                                                  : Colors.redAccent
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: primaryColor.withOpacity(0.8),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "${percentageRemaining.toInt()}%",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: whiteColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Remaining",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: whiteColor.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Collaborators Section - Redesigned with better spacing and visuals
              // Collaborators Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Collaborators",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: accentColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "${avatars.length} members",
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ...avatars.map((avatar) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundImage: AssetImage(avatar),
                                      backgroundColor: accentColor.withOpacity(0.2),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      "User",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            GestureDetector(
                              onTap: _addAvatar,
                              child: Column(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: lightBgColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: accentColor,
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: primaryColor,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    "Add",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 20),
              
              // Recent Activities Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent Activity",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: lightBgColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.filter_list,
                                size: 14,
                                color: primaryColor,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Filter",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    
                    // Activities list with error and loading states
                    if (isLoading)
                      Center(
                        child: Column(
                          children: [
                            SizedBox(height: 30),
                            CircularProgressIndicator(color: primaryColor),
                            SizedBox(height: 16),
                            Text(
                              "Loading transactions...",
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (errorMessage != null)
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                errorMessage!,
                                style: TextStyle(color: Colors.red.shade800),
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (activities.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 40),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: lightBgColor,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long,
                              size: 50,
                              color: accentColor.withOpacity(0.5),
                            ),
                            SizedBox(height: 16),
                            Text(
                              "No transactions yet",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: primaryColor.withOpacity(0.7),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Add your first transaction using the + button",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 20),
                            TextButton.icon(
                              onPressed: _showAddTransactionDialog,
                              icon: Icon(Icons.add_circle),
                              label: Text("Add Transaction"),
                              style: TextButton.styleFrom(
                                backgroundColor: accentColor.withOpacity(0.2),
                                foregroundColor: primaryColor,
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: activities.length,
                        itemBuilder: (context, index) {
                          final activity = activities[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              leading: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: activity["isExpense"]
                                      ? Colors.red.withOpacity(0.1)
                                      : Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    _getCategoryIcon(activity["description"]),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      activity["description"],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    activity["amount"],
                                    style: TextStyle(
                                      color: activity["isExpense"] ? Colors.red : Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 10,
                                        backgroundImage: AssetImage(activity["avatar"]),
                                        backgroundColor: accentColor.withOpacity(0.1),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        activity["name"],
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    activity["isExpense"] ? "Expense" : "Income",
                                    style: TextStyle(
                                      color: activity["isExpense"] ? Colors.red.shade300 : Colors.green.shade300,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
              
              // Space at bottom for FAB
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTransactionDialog,
        backgroundColor: Color(0xFF85C1E5),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}