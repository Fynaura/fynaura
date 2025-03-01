import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //imported for date (pubspec)
import 'package:flutter/cupertino.dart';import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //imported for date (pubspec)
import 'package:flutter/cupertino.dart';
import 'package:fynaura/pages/collab-budgeting/budgetDetails.dart';
import 'package:fynaura/widgets/CustomButton.dart';
import 'package:fynaura/widgets/backBtn.dart';
import 'package:fynaura/widgets/customInput.dart';
import 'package:fynaura/widgets/nav_bar.dart';
import 'package:fynaura/widgets/nav_model.dart';
import 'package:fynaura/pages/add-transactions/transaction_category_page.dart';

class CollabMain extends StatefulWidget {
  const CollabMain({super.key});

  @override
  State<CollabMain> createState() => CollabMainState();
}

class CollabMainState extends State<CollabMain> {
  List<Map<String, String>> createdBudgets = []; // Store created budgets
  final homeNavKey = GlobalKey<NavigatorState>();
  final searchNavKey = GlobalKey<NavigatorState>();
  final notificationNavKey = GlobalKey<NavigatorState>();
  final profileNavKey = GlobalKey<NavigatorState>();
  int selectedTab = 2; // Set to 2 for Plan tab
  List<NavModel> items = [];

  @override
  void initState() {
    super.initState();
    items = [
      NavModel(
        page: const TabPage(tab: 1),
        navKey: homeNavKey,
      ),
      NavModel(
        page: const TabPage(tab: 2),
        navKey: searchNavKey,
      ),
      NavModel(
        page: const BudgetPlanPage(),
        navKey: notificationNavKey,
      ),
      NavModel(
        page: const TabPage(tab: 4),
        navKey: profileNavKey,
      ),
    ];
  }

  void _addBudget(String name, String amount, String date) {
    setState(() {
      createdBudgets.add({"name": name, "amount": amount, "date": date});
    });
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
    return WillPopScope(
      onWillPop: () {
        if (items[selectedTab].navKey.currentState?.canPop() ?? false) {
          items[selectedTab].navKey.currentState?.pop();
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: selectedTab,
          children: items
              .map((page) => Navigator(
            key: page.navKey,
            onGenerateInitialRoutes: (navigator, initialRoute) {
              return [
                MaterialPageRoute(builder: (context) => page.page)
              ];
            },
          ))
              .toList(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          margin: const EdgeInsets.only(top: 10),
          height: 64,
          width: 64,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            elevation: 0,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TransactionCategoryPage()),
            ),
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 3, color: Color(0xFF85C1E5)),
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Icon(
              Icons.add,
              color: Color(0xFF85C1E5),
            ),
          ),
        ),
        bottomNavigationBar: NavBar(
          pageIndex: selectedTab,
          onTap: (index) {
            if (index == selectedTab) {
              items[index]
                  .navKey
                  .currentState
                  ?.popUntil((route) => route.isFirst);
            } else {
              setState(() {
                selectedTab = index;
              });
            }
          },
        ),
      ),
    );
  }
}

// Budget Plan Page - This is the content of the original CollabMain
class BudgetPlanPage extends StatefulWidget {
  const BudgetPlanPage({super.key});

  @override
  State<BudgetPlanPage> createState() => _BudgetPlanPageState();
}

class _BudgetPlanPageState extends State<BudgetPlanPage> {
  List<Map<String, String>> createdBudgets = []; // Store created budgets

  void _addBudget(String name, String amount, String date) {
    setState(() {
      createdBudgets.add({"name": name, "amount": amount, "date": date});
    });
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
      body: SingleChildScrollView(
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
              Column(
                children: createdBudgets.map((budget) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BudgetDetails(
                            budgetName: budget["name"]!,
                            budgetAmount: budget["amount"]!,
                            budgetDate: budget["date"]!,
                          ),
                        ),
                      );
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
                              budget["name"]!,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "LKR ${budget["amount"]}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                  ],
                                ),
                                Spacer(),
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage("images/user.png"),
                                ),
                              ],
                            ),
                          ],
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
            ],
          ),
        ),
      ),
    );
  }
}

// Reusing the TabPage from the provided code
class TabPage extends StatelessWidget {
  final int tab;

  const TabPage({Key? key, required this.tab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tab $tab')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Tab $tab'),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Page(tab: tab),
                  ),
                );
              },
              child: const Text('Go to page'),
            )
          ],
        ),
      ),
    );
  }
}

class Page extends StatelessWidget {
  final int tab;

  const Page({super.key, required this.tab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page Tab $tab')),
      body: Center(child: Text('Tab $tab')),
    );
  }
}

// Custom Popup Widget with Date Picker
class CustomPopup extends StatefulWidget {
  final Function(String, String, String) onBudgetCreated;

  CustomPopup({required this.onBudgetCreated});

  @override
  _CustomPopupState createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedDate = "Select a Date";

  // Validation errors
  String? _nameError;
  String? _amountError;
  String? _dateError;

  Future<void> _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color(0xFF85C1E5),
            colorScheme: ColorScheme.light(
              primary: Color(0xFF85C1E5),
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      // Validate that the selected date is not in the past
      if (pickedDate.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
        setState(() {
          _dateError = "Cannot select a date in the past";
          _selectedDate = "Select a Date";
        });
      } else {
        setState(() {
          _selectedDate = DateFormat("dd MMM yyyy").format(pickedDate);
          _dateError = null;
        });
      }
    }
  }

  // Validation function for budget name
  bool _validateName() {
    if (_nameController.text.isEmpty) {
      setState(() {
        _nameError = "Budget name cannot be empty";
      });
      return false;
    } else if (_nameController.text.length < 3) {
      setState(() {
        _nameError = "Budget name must be at least 3 characters";
      });
      return false;
    } else {
      setState(() {
        _nameError = null;
      });
      return true;
    }
  }

  // Validation function for budget amount
  bool _validateAmount() {
    if (_amountController.text.isEmpty) {
      setState(() {
        _amountError = "Budget amount cannot be empty";
      });
      return false;
    }

    // Try to parse the amount as a number
    try {
      double amount = double.parse(_amountController.text);
      if (amount <= 0) {
        setState(() {
          _amountError = "Amount must be greater than 0";
        });
        return false;
      } else if (amount > 1000000) {
        setState(() {
          _amountError = "Amount cannot exceed 1,000,000";
        });
        return false;
      } else {
        setState(() {
          _amountError = null;
        });
        return true;
      }
    } catch (e) {
      setState(() {
        _amountError = "Please enter a valid number";
      });
      return false;
    }
  }

  // Validation function for date
  bool _validateDate() {
    if (_selectedDate == "Select a Date") {
      setState(() {
        _dateError = "Please select a date";
      });
      return false;
    } else {
      setState(() {
        _dateError = null;
      });
      return true;
    }
  }

  // Validate all fields
  bool _validateAll() {
    bool nameValid = _validateName();
    bool amountValid = _validateAmount();
    bool dateValid = _validateDate();

    return nameValid && amountValid && dateValid;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Create a New Budget",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text("Enter the following details!"),
              const SizedBox(height: 20),
              Text("Budget Name"),
              CustomInputField(
                hintText: "Christmas",
                controller: _nameController,
              ),
              if (_nameError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    _nameError!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 20),
              Text("Estimated Total Budget"),
              CustomInputField(
                hintText: "1000",
                controller: _amountController,
                keyboardType: TextInputType.number,
              ),
              if (_amountError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    _amountError!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 20),
              Text("Select Date"),
              GestureDetector(
                onTap: () => _pickDate(context),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: _dateError != null ? Colors.red : Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _selectedDate,
                    style: TextStyle(
                        color: _selectedDate == "Select a Date"
                            ? Colors.black54
                            : Colors.black,
                        fontSize: 16),
                  ),
                ),
              ),
              if (_dateError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    _dateError!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 30),
              CustomButton(
                text: "Create Budget",
                backgroundColor: const Color(0xFF1E232C),
                textColor: Colors.white,
                onPressed: () {
                  if (_validateAll()) {
                    widget.onBudgetCreated(
                      _nameController.text,
                      _amountController.text,
                      _selectedDate,
                    );
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:fynaura/pages/collab-budgeting/budgetDetails.dart';
import 'package:fynaura/widgets/CustomButton.dart';
import 'package:fynaura/widgets/backBtn.dart';
import 'package:fynaura/widgets/customInput.dart';
import 'package:fynaura/widgets/nav_bar.dart';
import 'package:fynaura/widgets/nav_model.dart';
import 'package:fynaura/pages/add-transactions/transaction_category_page.dart';

class CollabMain extends StatefulWidget {
  const CollabMain({super.key});

  @override
  State<CollabMain> createState() => CollabMainState();
}

class CollabMainState extends State<CollabMain> {
  List<Map<String, String>> createdBudgets = []; // Store created budgets
  final homeNavKey = GlobalKey<NavigatorState>();
  final searchNavKey = GlobalKey<NavigatorState>();
  final notificationNavKey = GlobalKey<NavigatorState>();
  final profileNavKey = GlobalKey<NavigatorState>();
  int selectedTab = 2; // Set to 2 for Plan tab
  List<NavModel> items = [];

  @override
  void initState() {
    super.initState();
    items = [
      NavModel(
        page: const TabPage(tab: 1),
        navKey: homeNavKey,
      ),
      NavModel(
        page: const TabPage(tab: 2),
        navKey: searchNavKey,
      ),
      NavModel(
        page: const BudgetPlanPage(),
        navKey: notificationNavKey,
      ),
      NavModel(
        page: const TabPage(tab: 4),
        navKey: profileNavKey,
      ),
    ];
  }

  void _addBudget(String name, String amount, String date) {
    setState(() {
      createdBudgets.add({"name": name, "amount": amount, "date": date});
    });
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
    return WillPopScope(
      onWillPop: () {
        if (items[selectedTab].navKey.currentState?.canPop() ?? false) {
          items[selectedTab].navKey.currentState?.pop();
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: selectedTab,
          children: items
              .map((page) => Navigator(
            key: page.navKey,
            onGenerateInitialRoutes: (navigator, initialRoute) {
              return [
                MaterialPageRoute(builder: (context) => page.page)
              ];
            },
          ))
              .toList(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          margin: const EdgeInsets.only(top: 10),
          height: 64,
          width: 64,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            elevation: 0,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TransactionCategoryPage()),
            ),
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 3, color: Color(0xFF85C1E5)),
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Icon(
              Icons.add,
              color: Color(0xFF85C1E5),
            ),
          ),
        ),
        bottomNavigationBar: NavBar(
          pageIndex: selectedTab,
          onTap: (index) {
            if (index == selectedTab) {
              items[index]
                  .navKey
                  .currentState
                  ?.popUntil((route) => route.isFirst);
            } else {
              setState(() {
                selectedTab = index;
              });
            }
          },
        ),
      ),
    );
  }
}

// Budget Plan Page - This is the content of the original CollabMain
class BudgetPlanPage extends StatefulWidget {
  const BudgetPlanPage({super.key});

  @override
  State<BudgetPlanPage> createState() => _BudgetPlanPageState();
}

class _BudgetPlanPageState extends State<BudgetPlanPage> {
  List<Map<String, String>> createdBudgets = []; // Store created budgets

  void _addBudget(String name, String amount, String date) {
    setState(() {
      createdBudgets.add({"name": name, "amount": amount, "date": date});
    });
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
      body: SingleChildScrollView(
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
              Column(
                children: createdBudgets.map((budget) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BudgetDetails(
                            budgetName: budget["name"]!,
                            budgetAmount: budget["amount"]!,
                            budgetDate: budget["date"]!,
                          ),
                        ),
                      );
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
                              budget["name"]!,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "LKR ${budget["amount"]}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                  ],
                                ),
                                Spacer(),
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage("images/user.png"),
                                ),
                              ],
                            ),
                          ],
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
            ],
          ),
        ),
      ),
    );
  }
}

// Reusing the TabPage from the provided code
class TabPage extends StatelessWidget {
  final int tab;

  const TabPage({Key? key, required this.tab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tab $tab')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Tab $tab'),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Page(tab: tab),
                  ),
                );
              },
              child: const Text('Go to page'),
            )
          ],
        ),
      ),
    );
  }
}

class Page extends StatelessWidget {
  final int tab;

  const Page({super.key, required this.tab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page Tab $tab')),
      body: Center(child: Text('Tab $tab')),
    );
  }
}

// Custom Popup Widget with Date Picker
class CustomPopup extends StatefulWidget {
  final Function(String, String, String) onBudgetCreated;

  CustomPopup({required this.onBudgetCreated});

  @override
  _CustomPopupState createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedDate = "Select a Date";

  // Validation errors
  String? _nameError;
  String? _amountError;
  String? _dateError;

  Future<void> _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color(0xFF85C1E5),
            colorScheme: ColorScheme.light(
              primary: Color(0xFF85C1E5),
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      // Validate that the selected date is not in the past
      if (pickedDate.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
        setState(() {
          _dateError = "Cannot select a date in the past";
          _selectedDate = "Select a Date";
        });
      } else {
        setState(() {
          _selectedDate = DateFormat("dd MMM yyyy").format(pickedDate);
          _dateError = null;
        });
      }
    }
  }

  // Validation function for budget name
  bool _validateName() {
    if (_nameController.text.isEmpty) {
      setState(() {
        _nameError = "Budget name cannot be empty";
      });
      return false;
    } else if (_nameController.text.length < 3) {
      setState(() {
        _nameError = "Budget name must be at least 3 characters";
      });
      return false;
    } else {
      setState(() {
        _nameError = null;
      });
      return true;
    }
  }

  // Validation function for budget amount
  bool _validateAmount() {
    if (_amountController.text.isEmpty) {
      setState(() {
        _amountError = "Budget amount cannot be empty";
      });
      return false;
    }

    // Try to parse the amount as a number
    try {
      double amount = double.parse(_amountController.text);
      if (amount <= 0) {
        setState(() {
          _amountError = "Amount must be greater than 0";
        });
        return false;
      } else if (amount > 1000000) {
        setState(() {
          _amountError = "Amount cannot exceed 1,000,000";
        });
        return false;
      } else {
        setState(() {
          _amountError = null;
        });
        return true;
      }
    } catch (e) {
      setState(() {
        _amountError = "Please enter a valid number";
      });
      return false;
    }
  }

  // Validation function for date
  bool _validateDate() {
    if (_selectedDate == "Select a Date") {
      setState(() {
        _dateError = "Please select a date";
      });
      return false;
    } else {
      setState(() {
        _dateError = null;
      });
      return true;
    }
  }

  // Validate all fields
  bool _validateAll() {
    bool nameValid = _validateName();
    bool amountValid = _validateAmount();
    bool dateValid = _validateDate();

    return nameValid && amountValid && dateValid;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Create a New Budget",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text("Enter the following details!"),
              const SizedBox(height: 20),
              Text("Budget Name"),
              CustomInputField(
                hintText: "Christmas",
                controller: _nameController,
              ),
              if (_nameError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    _nameError!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 20),
              Text("Estimated Total Budget"),
              CustomInputField(
                hintText: "1000",
                controller: _amountController,
                keyboardType: TextInputType.number,
              ),
              if (_amountError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    _amountError!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 20),
              Text("Select Date"),
              GestureDetector(
                onTap: () => _pickDate(context),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: _dateError != null ? Colors.red : Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _selectedDate,
                    style: TextStyle(
                        color: _selectedDate == "Select a Date"
                            ? Colors.black54
                            : Colors.black,
                        fontSize: 16),
                  ),
                ),
              ),
              if (_dateError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    _dateError!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 30),
              CustomButton(
                text: "Create Budget",
                backgroundColor: const Color(0xFF1E232C),
                textColor: Colors.white,
                onPressed: () {
                  if (_validateAll()) {
                    widget.onBudgetCreated(
                      _nameController.text,
                      _amountController.text,
                      _selectedDate,
                    );
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}