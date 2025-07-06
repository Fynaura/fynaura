import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:fynaura/pages/goal-oriented-saving/model/Goal.dart';
import 'package:fynaura/pages/goal-oriented-saving/service/GoalService.dart'
    as service;
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'dart:math' show max;
import 'package:fynaura/widgets/goal_notification_widget.dart';

bool isMongoId(String id) {
  final regex = RegExp(r'^[a-f\d]{24}$');
  return regex.hasMatch(id);
}

class GoalDetailScreen extends StatefulWidget {
  final Goal goal;

  GoalDetailScreen({required this.goal});

  @override
  _GoalDetailScreenState createState() => _GoalDetailScreenState();
}

class _GoalDetailScreenState extends State<GoalDetailScreen>
    with SingleTickerProviderStateMixin {
  // Define app's color palette (matching the design from other pages)
  static const Color primaryColor = Color(0xFF254e7a); // Primary blue
  static const Color accentColor = Color(0xFF85c1e5); // Light blue accent
  static const Color lightBgColor = Color(0xFFEBF1FD); // Light background
  static const Color whiteColor = Colors.white; // White background

  late Goal goal;
  late ConfettiController _confettiController;
  bool _isLoading = false;
  late AnimationController _progressAnimationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    goal = widget.goal;
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));

    // Initialize progress animation controller
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: (goal.savedAmount / goal.targetAmount).clamp(0.0, 1.0),
    ).animate(
      CurvedAnimation(
        parent: _progressAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Play initial progress animation
    _progressAnimationController.forward();

    // If goal is already completed, play confetti when screen loads
    if (goal.isCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _confettiController.play();
      });
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  // Update method for animating progress
  void _updateProgress() {
    _progressAnimationController.reset();
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: (goal.savedAmount / goal.targetAmount).clamp(0.0, 1.0),
    ).animate(
      CurvedAnimation(
        parent: _progressAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    _progressAnimationController.forward();
  }

  // Format date to a readable string
  String _formatDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  // Method to prompt user for the amount to add
  Future<void> _addAmount() async {
    if (goal.isCompleted) return;

    TextEditingController _amountController = TextEditingController();
    bool _validAmount = true;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(Icons.add_circle, color: primaryColor),
                SizedBox(width: 10),
                Text("Add to Your Goal",
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Current progress: ${(goal.savedAmount / goal.targetAmount * 100).toStringAsFixed(1)}%",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Amount (LKR)',
                    hintText: 'Enter amount to add',
                    prefixIcon: Icon(Icons.attach_money, color: primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: accentColor, width: 2),
                    ),
                    errorText:
                        _validAmount ? null : 'Please enter a valid amount',
                    filled: true,
                    fillColor: lightBgColor.withOpacity(0.5),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _validAmount = value.isNotEmpty &&
                          double.tryParse(value) != null &&
                          double.parse(value) > 0;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                                        // Set loading state and update UI
                      this.setState(() {
                        _isLoading = true;
                      });
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                ),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  double amountToAdd =
                      double.tryParse(_amountController.text) ?? 0.0;
                  if (amountToAdd > 0) {
                    final String tempId = const Uuid().v4();

                    // Close dialog
                    Navigator.pop(context);

                    // Set loading state and update UI
                    setState(() {
                      _isLoading = true;
                    });

                    try {
                      // Update state
                      setState(() {
                        goal.savedAmount += amountToAdd;
                        goal.history.add(Transaction(
                          id: tempId,
                          amount: amountToAdd,
                          date: DateTime.now(),
                          isAdded: true,
                        ));
                      });

                      _updateProgress();

                      // Save to backend
                      await service.GoalService()
                          .addAmount(goal.id, amountToAdd);
                      await service.GoalService().addTransaction(
                        goal.id,
                        amountToAdd,
                        DateTime.now().toString(),
                        true,
                      );

                      // Check if goal is completed
                      if (goal.savedAmount >= goal.targetAmount &&
                          !goal.isCompleted) {
                        setState(() {
                          goal.isCompleted = true;
                        });
                        _confettiController.play();
                        await service.GoalService()
                            .markGoalAsCompleted(goal.id);
                      }

                      // Success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Added LKR ${amountToAdd.toStringAsFixed(2)} to your goal!"),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Failed to add amount: $e"),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } finally {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  } else {
                    setState(() {
                      _validAmount = false;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: Text('Add Amount'),
              ),
            ],
          );
        });
      },
    );
  }

  // Method to prompt user for the amount to subtract
  Future<void> _subtractAmount() async {
    if (goal.isCompleted) return;

    TextEditingController _amountController = TextEditingController();
    bool _validAmount = true;
    String? _errorText;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(Icons.remove_circle, color: Colors.red),
                SizedBox(width: 10),
                Text("Withdraw from Goal",
                    style: TextStyle(
                      color: Colors.red[700],
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Available amount: LKR ${goal.savedAmount.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Amount (LKR)',
                    hintText: 'Enter amount to withdraw',
                    prefixIcon: Icon(Icons.money_off, color: Colors.red[700]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.red[300]!, width: 2),
                    ),
                    errorText: _errorText,
                    filled: true,
                    fillColor: lightBgColor.withOpacity(0.5),
                  ),
                  onChanged: (value) {
                    double? amount = double.tryParse(value);
                    setState(() {
                      if (value.isEmpty || amount == null || amount <= 0) {
                        _validAmount = false;
                        _errorText = 'Please enter a valid amount';
                      } else if (amount > goal.savedAmount) {
                        _validAmount = false;
                        _errorText = 'Cannot exceed saved amount';
                      } else {
                        _validAmount = true;
                        _errorText = null;
                      }
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                ),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: !_validAmount
                    ? null
                    : () async {
                        double amountToSubtract =
                            double.tryParse(_amountController.text) ?? 0.0;
                        if (amountToSubtract > 0 &&
                            amountToSubtract <= goal.savedAmount) {
                          final String tempId = const Uuid().v4();

                          // Close dialog
                          Navigator.pop(context);

                          // Set loading state
                          setState(() {
                            _isLoading = true;
                          });

                          try {
                            // Update state
                            setState(() {
                              goal.savedAmount -= amountToSubtract;
                              goal.history.add(Transaction(
                                id: tempId,
                                amount: amountToSubtract,
                                date: DateTime.now(),
                                isAdded: false,
                              ));
                            });

                            _updateProgress();

                            // Save to backend
                            await service.GoalService()
                                .subtractAmount(goal.id, amountToSubtract);
                            await service.GoalService().addTransaction(
                              goal.id,
                              amountToSubtract,
                              DateTime.now().toString(),
                              false,
                            );

                            // Success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Withdrew LKR ${amountToSubtract.toStringAsFixed(2)} from your goal"),
                                backgroundColor: Colors.orange,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Failed to withdraw amount: $e"),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } finally {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  foregroundColor: whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  disabledBackgroundColor: Colors.red.withOpacity(0.3),
                ),
                child: Text('Withdraw'),
              ),
            ],
          );
        });
      },
    );
  }
  

  @override
  Widget build(BuildContext context) {
    double progress = (goal.savedAmount / goal.targetAmount).clamp(0.0, 1.0);
    // Sort transactions in reverse chronological order
    goal.history.sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text(
          goal.name,
          style: TextStyle(
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: whiteColor),
          onPressed: () {
            Navigator.pop(context, goal);
          },
        ),
      ),
      body: Stack(
        children: [
          // Confetti effect positioned at the top center of the screen
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.08,
              numberOfParticles: 50,
              maxBlastForce: 20,
              minBlastForce: 10,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.red,
              ],
            ),
          ),

          // Main Content Container with Rounded Corners
          Container(
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: primaryColor))
                : RefreshIndicator(
                    color: primaryColor,
                    onRefresh: () async {
                      // You can implement a refresh logic here if needed
                      await Future.delayed(Duration(milliseconds: 500));
                    },
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header section with goal details
                          _buildGoalHeader(),
                          SizedBox(height: 30),

                          // Progress section with gradient progress bar
                          AnimatedBuilder(
                            animation: _progressAnimation,
                            builder: (context, child) {
                              return _buildProgressSection(
                                  _progressAnimation.value);
                            },
                          ),
                          SizedBox(height: 25),

                          // Goal completed banner (if applicable)
                          if (goal.isCompleted) _buildCompletedBanner(),
                          SizedBox(height: goal.isCompleted ? 30 : 0),

                          // Action buttons for adding/withdrawing funds
                          _buildActionButtons(),
                          SizedBox(height: 30),

                          // Transaction history section
                          _buildHistorySection(context),


                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // Helper method to build the goal header section
  Widget _buildGoalHeader() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Goal image or icon
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: lightBgColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: primaryColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: goal.image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        goal.image!,
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image_not_supported,
                            color: primaryColor,
                            size: 40,
                          );
                        },
                      ),
                    )
                  : Icon(
                      _getGoalIcon(),
                      color: primaryColor,
                      size: 40,
                    ),
            ),
          ),
          SizedBox(width: 15),

          // Goal details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Target: LKR ${goal.targetAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Timeline: ${_formatDate(goal.startDate)} - ${_formatDate(goal.endDate)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      
      // Add the notification widget after the main header content
      // Only show for goals that aren't completed
      if (!goal.isCompleted)
        GoalNotificationWidget(goal: goal),
    ],
  );
}

  // Helper method to build progress section
  Widget _buildProgressSection(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            Text(
              '${(progress * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _getProgressColor(progress),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),

        // Enhanced Progress Bar
        Container(
          width: double.infinity,
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200],
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Progress fill with gradient
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 800),
                  curve: Curves.easeInOut,
                  width: max(
                      0,
                      MediaQuery.of(context).size.width * progress -
                          40), // Adjust for padding
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primaryColor, // Start with blue
                        accentColor, // Middle with light blue
                        _getProgressColor(
                            progress), // End with color based on progress
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 15),

        // Saved and remaining amounts
        

            Row(
              children: [
                Icon(Icons.savings, color: Colors.green, size: 20),
                SizedBox(width: 5),
                Text(
                  'Saved: LKR ${goal.savedAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.flag, color: Colors.orange, size: 20),
                SizedBox(width: 5),
                Text(
                  'Remaining: LKR ${(goal.targetAmount - goal.savedAmount).toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        
      
    );
  }

  // Helper method to build the completed banner
  Widget _buildCompletedBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green[700]!,
            Colors.green[500]!,
            Colors.green[300]!,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.4),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.emoji_events,
            color: Colors.white,
            size: 40,
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Goal Completed!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Congratulations on achieving your financial goal!',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build action buttons
  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Manage Your Goal',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        SizedBox(height: 15),
        Row(
          children: [
            // Add funds button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: goal.isCompleted ? null : _addAmount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: whiteColor,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  disabledBackgroundColor: Colors.grey[400],
                ),
                icon: Icon(Icons.add_circle),
                label: Text(
                  'Add Funds',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(width: 15),
            // Withdraw funds button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: goal.isCompleted || goal.savedAmount <= 0
                    ? null
                    : _subtractAmount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  foregroundColor: whiteColor,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  disabledBackgroundColor: Colors.grey[400],
                ),
                icon: Icon(Icons.remove_circle),
                label: Text(
                  'Withdraw',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Helper method to build transaction history section
  Widget _buildHistorySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Transaction History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            Text(
              '${goal.history.length} transactions',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        goal.history.isEmpty
            ? Container(
                padding: EdgeInsets.symmetric(vertical: 30),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Icon(
                      Icons.history,
                      size: 50,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 15),
                    Text(
                      'No transactions yet',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Add funds to start building your goal',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  color: lightBgColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: goal.history.length,
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.grey[300],
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    final transaction = goal.history[index];
                    return Dismissible(
                      key: Key(transaction.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(Icons.delete, color: whiteColor),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Delete Transaction'),
                            content: Text(
                                'Are you sure you want to delete this transaction?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: Text('Delete',
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                      onDismissed: (direction) async {
                        final removedTransaction = goal.history[index];

                        // Check if transaction is synced with backend
                        if (isMongoId(removedTransaction.id)) {
                          try {
                            await service.GoalService().deleteTransaction(
                                goal.id, removedTransaction.id);
                            setState(() {
                              goal.history.removeAt(index);
                              goal.savedAmount -= removedTransaction.isAdded
                                  ? removedTransaction.amount
                                  : -removedTransaction.amount;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Transaction deleted"),
                                backgroundColor: Colors.red[700],
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Failed to delete transaction"),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        } else {
                          // Local-only transaction, just remove from UI
                          setState(() {
                            goal.history.removeAt(index);
                            goal.savedAmount -= removedTransaction.isAdded
                                ? removedTransaction.amount
                                : -removedTransaction.amount;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Local transaction deleted"),
                              backgroundColor: Colors.orange,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        leading: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: transaction.isAdded
                                ? Colors.green[50]
                                : Colors.red[50],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: transaction.isAdded
                                  ? Colors.green[200]!
                                  : Colors.red[200]!,
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            transaction.isAdded
                                ? Icons.add_circle
                                : Icons.remove_circle,
                            color:
                                transaction.isAdded ? Colors.green : Colors.red,
                            size: 24,
                          ),
                        ),
                        title: Text(
                          'LKR ${transaction.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: transaction.isAdded
                                ? Colors.green[700]
                                : Colors.red[700],
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          '${DateFormat('MMM d, yyyy • h:mm a').format(transaction.date)}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        trailing: Chip(
                          label: Text(
                            transaction.isAdded ? 'Deposit' : 'Withdrawal',
                            style: TextStyle(
                              color: transaction.isAdded
                                  ? Colors.green[700]
                                  : Colors.red[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          backgroundColor: transaction.isAdded
                              ? Colors.green[50]
                              : Colors.red[50],
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: transaction.isAdded
                                  ? Colors.green[200]!
                                  : Colors.red[200]!,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }

  // Helper method to determine appropriate icon for the goal
  IconData _getGoalIcon() {
    final name = goal.name.toLowerCase();
    if (name.contains('house') || name.contains('home')) {
      return Icons.home;
    } else if (name.contains('car') || name.contains('vehicle')) {
      return Icons.directions_car;
    } else if (name.contains('education') ||
        name.contains('school') ||
        name.contains('college')) {
      return Icons.school;
    } else if (name.contains('travel') ||
        name.contains('vacation') ||
        name.contains('trip')) {
      return Icons.flight;
    } else if (name.contains('wedding') || name.contains('marriage')) {
      return Icons.favorite;
    } else if (name.contains('device') ||
        name.contains('phone') ||
        name.contains('tech')) {
      return Icons.devices;
    } else if (name.contains('emergency') || name.contains('medical')) {
      return Icons.medical_services;
    }
    return Icons.emoji_events;
  }

  // Helper method to get color based on progress
  Color _getProgressColor(double progress) {
    if (progress >= 1.0 || goal.isCompleted) {
      return Colors.green;
    } else if (progress >= 0.7) {
      return Colors.lightGreen;
    } else if (progress >= 0.4) {
      return Colors.orange;
    } else {
      return Colors.deepOrange;
    }
  }
}
