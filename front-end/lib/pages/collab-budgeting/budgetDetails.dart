import 'package:flutter/material.dart';
import 'package:fynaura/pages/collab-budgeting/qr_scanner.dart';
import 'package:fynaura/widgets/backBtn.dart';
import 'package:fynaura/services/budget_service.dart';
import 'package:fynaura/pages/user-session/UserSession.dart';

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
  List<String> avatars = ["images/user.png"]; // Initial avatar list
  final BudgetService _budgetService = BudgetService(); // Add budget service
  final UserSession _userSession = UserSession(); // Get UserSession instance

  // Track the current balance and activities
  late double currentAmount;
  late double initialAmount;
  double percentageRemaining = 100; // Starting at 100% instead of 10%

  // List to store activities
  List<Map<String, dynamic>> activities = [];

  @override
  void initState() {
    super.initState();
    // Initialize the current amount from the budget amount passed from collab main
    currentAmount = double.tryParse(widget.budgetAmount.replaceAll(',', '')) ?? 50000;
    initialAmount = currentAmount; // Store initial amount to calculate percentage

    // Load transactions
    _loadTransactions();
  }



  Future<void> _loadCollaborators() async {
    try {
      final collaborators = await _budgetService.getCollaborators(widget.budgetId);
      setState(() {
        // Update avatars based on collaborators
        avatars = collaborators.map((collaborator) => "images/user.png").toList();
      });
    } catch (e) {
      print('Failed to load collaborators: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCollaborators();  // Ensure collaborators are reloaded when the screen is displayed
  }

  Future<void> _loadTransactions() async {
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
          };
        }).toList();
      });
    } catch (e) {
      // Handle error
      print("Failed to load transactions: $e");
    }
  }



  void _addAvatar() {
    final TextEditingController searchController = TextEditingController();
    final TextEditingController userIdController = TextEditingController();
    bool isLoading = false;
    String? errorMessage;
    List<Map<String, dynamic>> searchResults = [];
    bool isSearching = false;

    // Function to handle QR code scanning
    void scanQRCode() async {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => QRScannerScreen(
            onQRCodeScanned: (qrData) async {
              try {
                // Parse the QR code data
                final userData = _budgetService.parseCollaboratorQrCode(qrData);

                if (userData != null && userData.containsKey('userId')) {
                  final userId = userData['userId'];

                  // Don't allow adding yourself as a collaborator
                  if (userId == _userSession.userId) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("You cannot add yourself as a collaborator"))
                    );
                    return;
                  }

                  // Show a loading indicator
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Adding collaborator..."))
                  );

                  // Check if user exists
                  final userExists = await _budgetService.checkUserExists(userId);

                  if (!userExists) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("User does not exist"))
                    );
                    return;
                  }

                  // Add the user as a collaborator
                  await _budgetService.addCollaborator(
                    widget.budgetId,
                    userId,
                  );

                  // Update the UI
                  setState(() {
                    avatars.add("images/user.png");
                    _loadCollaborators();
                  });

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Collaborator added successfully"))
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Invalid QR code format"))
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to add collaborator: $e"))
                );
              }
            },
          ),
        ),
      );
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                  SnackBar(content: Text("Collaborator added successfully")),
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
              child: Container(
                constraints: BoxConstraints(maxHeight: 550),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Icon(Icons.person_add, size: 24, color: Colors.black54),
                          SizedBox(width: 8),
                          Text(
                            "Invite Collaborators",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.black54),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text("Your budget has been created. Invite your friends to join!"),
                      SizedBox(height: 16),

                      // Scan QR Code button
                      ElevatedButton.icon(
                        icon: Icon(Icons.qr_code_scanner),
                        label: Text("Scan QR Code"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF85C1E5),
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          scanQRCode();
                        },
                      ),

                      SizedBox(height: 16),
                      Divider(),
                      SizedBox(height: 16),

                      // Search field
                      Text(
                        "Search by name or user ID:",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: "Type to search...",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: searchController.text.isNotEmpty
                              ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              setState(() {
                                searchResults = [];
                                errorMessage = null;
                              });
                            },
                          )
                              : null,
                        ),
                        onChanged: performSearch,
                      ),

                      if (errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            errorMessage!,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),

                      SizedBox(height: 8),

                      // Search results
                      if (isLoading)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (isSearching && searchResults.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              "No matching users found",
                              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                            ),
                          ),
                        )
                      else if (searchResults.isNotEmpty)
                          Flexible(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: searchResults.length,
                              itemBuilder: (context, index) {
                                final user = searchResults[index];
                                return Card(
                                  margin: EdgeInsets.symmetric(vertical: 4),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: AssetImage("images/user.png"),
                                      child: user["displayName"] != null && user["displayName"].isNotEmpty
                                          ? null
                                          : Icon(Icons.person, color: Colors.white),
                                    ),
                                    title: Text(user["displayName"] ?? "User ${user["userId"]}"),
                                    subtitle: user["email"] != null && user["email"].isNotEmpty
                                        ? Text(user["email"])
                                        : Text("ID: ${user["userId"]}"),
                                    trailing: IconButton(
                                      icon: Icon(Icons.add_circle, color: Colors.blue),
                                      onPressed: () => addCollaborator(user["userId"]),
                                    ),
                                    onTap: () => addCollaborator(user["userId"]),
                                  ),
                                );
                              },
                            ),
                          ),

                      Divider(height: 32),

                      // Direct entry section
                      Text(
                        "Or enter user ID directly:",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: userIdController,
                              decoration: InputDecoration(
                                hintText: "Enter user ID",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            ),
                            onPressed: () {
                              if (userIdController.text.isNotEmpty) {
                                addCollaborator(userIdController.text);
                              }
                            },
                            child: Text("Add"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Updated method to add transaction using BudgetService and current user's name
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isExpense ? Icons.remove_circle : Icons.add_circle,
                          size: 24,
                          color: isExpense ? Colors.red : Colors.green,
                        ),
                        SizedBox(width: 8),
                        Text(
                          isExpense ? "Add Expense" : "Add Income",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.black54),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isExpense
                                  ? Color(0xFF85C1E5)
                                  : Colors.grey.shade300,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                isExpense = true;
                              });
                            },
                            child: Text("Expense"),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: !isExpense
                                  ? Color(0xFF85C1E5)
                                  : Colors.grey.shade300,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                isExpense = false;
                              });
                            },
                            child: Text("Income"),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixText: "LKR ",
                        hintText: "Amount",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        hintText: "Description",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      onPressed: () async {
                        // Get amount from controller
                        double amount = double.tryParse(amountController.text) ?? 0;
                        if (amount <= 0 || descriptionController.text.isEmpty) {
                          // Show error
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please enter valid amount and description")),
                          );
                          return;
                        }

                        try {
                          await _budgetService.addTransaction(
                              widget.budgetId,
                              descriptionController.text,
                              amount,
                              isExpense,
                              currentUserName // Use current user's name instead of "John Doe"
                          );

                          // Update the UI state
                          this.setState(() {
                            if (isExpense) {
                              currentAmount = currentAmount - amount;

                              activities.add({
                                "avatar": "images/user.png",
                                "name": currentUserName, // Use current user's name here too
                                "description": descriptionController.text,
                                "amount": "LKR ${amount.toStringAsFixed(0)}",
                                "isExpense": true,
                              });

                              percentageRemaining = (currentAmount / initialAmount) * 100;
                              if (percentageRemaining < 0) percentageRemaining = 0;
                            } else {
                              currentAmount = currentAmount + amount;

                              activities.add({
                                "avatar": "images/user.png",
                                "name": currentUserName, // Use current user's name here too
                                "description": descriptionController.text,
                                "amount": "LKR ${amount.toStringAsFixed(0)}",
                                "isExpense": false,
                              });

                              percentageRemaining = (currentAmount / initialAmount) * 100;
                              if (percentageRemaining > 100) percentageRemaining = 100;
                            }
                          });

                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Failed to add transaction: $e")),
                          );
                        }
                        Navigator.pop(context);
                      },
                      child: Text("Add"),
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

  @override
  Widget build(BuildContext context) {
    // Format the current amount for display
    String formattedCurrentAmount = currentAmount.toStringAsFixed(0);
    // Add commas for thousands if needed
    if (formattedCurrentAmount.length > 3) {
      formattedCurrentAmount = formattedCurrentAmount.replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    }

    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: 380,
                  height: 180,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1E1E1E), Color(0xFF2C3E50)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Budget For " + widget.budgetName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Accumulated Balance",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        "LKR $formattedCurrentAmount", // Use updated current amount
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: Text(
                    widget.budgetDate,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              value: percentageRemaining / 100,
                              strokeWidth: 5,
                              backgroundColor: Colors.white24,
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF85C1E5)),
                            ),
                          ),
                          Text(
                            "${percentageRemaining.toInt()}%",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Remaining",
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // Avatar List with Plus Button
            Container(
              width: 380,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF26252A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  ...avatars.map((avatar) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(avatar),
                      ),
                    );
                  }).toList(),
                  GestureDetector(
                    onTap: _addAvatar,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.add, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recent Activity",
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    color: Color(0xFF26252A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Recent Activity List
            Expanded(
              child: activities.isEmpty
                  ? Center(
                child: Text(
                  "No activities yet",
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFFDADADA),
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  final activity = activities[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(activity["avatar"]),
                      ),
                      title: Text(
                        activity["name"],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(activity["description"]),
                      trailing: Text(
                        activity["amount"],
                        style: TextStyle(
                          color: activity["isExpense"] ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
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