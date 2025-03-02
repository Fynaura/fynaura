//
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; //imported for date (pubspec)
// import 'package:fynaura/pages/collab-budgeting/budgetDetails.dart';
// import 'package:fynaura/widgets/CustomButton.dart';
// import 'package:fynaura/widgets/backBtn.dart';
// import 'package:fynaura/widgets/customInput.dart';
//
// class CollabMain extends StatefulWidget {
//   const CollabMain({super.key});
//
//   @override
//   State<CollabMain> createState() => CollabMainState();
// }
//
// class CollabMainState extends State<CollabMain> {
//   List<Map<String, String>> createdBudgets = []; // Store created budgets
//
//   void _addBudget(String name, String amount, String date) {
//     setState(() {
//       createdBudgets.add({"name": name, "amount": amount, "date": date});
//     });
//   }
//
//   void _showCreateBudgetPopup(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return CustomPopup(onBudgetCreated: _addBudget);
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: CustomBackButton(),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Text(
//                   "Budget Plan",
//                   style: TextStyle(
//                     fontFamily: 'Urbanist',
//                     fontWeight: FontWeight.bold,
//                     fontSize: 30,
//                     color: Color(0xFF85C1E5),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 "Pinned Plans",
//                 style: TextStyle(
//                   fontFamily: 'Urbanist',
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                   color: Color(0xFF85C1E5),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Center(
//                 child: Text(
//                   "No plans pinned yet",
//                   style: TextStyle(
//                     fontFamily: 'Urbanist',
//                     fontWeight: FontWeight.w800,
//                     fontSize: 16,
//                     fontStyle: FontStyle.italic,
//                     color: Color(0xFFDADADA),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 "Created Plans",
//                 style: TextStyle(
//                   fontFamily: 'Urbanist',
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                   color: Color(0xFF85C1E5),
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               Column(
//                 children: createdBudgets.map((budget) {
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => BudgetDetails(
//                             budgetName: budget["name"]!,
//                             budgetAmount: budget["amount"]!,
//                             budgetDate: budget["date"]!,
//                           ),
//                         ),
//                       );
//                     },
//                     child: Card(
//                       elevation: 3,
//                       margin: EdgeInsets.symmetric(vertical: 8),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: Padding(
//                         padding: EdgeInsets.all(16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               budget["name"]!,
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             SizedBox(height: 5),
//                             LinearProgressIndicator(
//                               value: 1.0,
//                               backgroundColor: Color(0xFF85C1E5),
//                               color: Color(0xFF85C1E5),
//                             ),
//                             SizedBox(height: 10),
//                             Row(
//                               crossAxisAlignment:
//                               CrossAxisAlignment.start, // Align items to the top
//                               children: [
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "LKR ${budget["amount"]}",
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.grey[700],
//                                       ),
//                                     ),
//                                     SizedBox(height: 5),
//
//                                   ],
//                                 ),
//                                 Spacer(),
//                                 CircleAvatar(
//                                   radius: 20,
//                                   backgroundImage: AssetImage("images/user.png"),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//
//               const SizedBox(height: 20),
//
//               CustomButton(
//                 text: "Create a New Budget",
//                 backgroundColor: const Color(0xFF85C1E5),
//                 textColor: Colors.white,
//                 onPressed: () {
//                   _showCreateBudgetPopup(context);
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // Custom Popup Widget with Date Picker
// class CustomPopup extends StatefulWidget {
//   final Function(String, String, String) onBudgetCreated;
//
//   CustomPopup({required this.onBudgetCreated});
//
//   @override
//   _CustomPopupState createState() => _CustomPopupState();
// }
//
// class _CustomPopupState extends State<CustomPopup> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _amountController = TextEditingController();
//   String _selectedDate = "Select a Date";
//
//   // Validation errors
//   String? _nameError;
//   String? _amountError;
//   String? _dateError;
//
//   Future<void> _pickDate(BuildContext context) async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//       builder: (context, child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             primaryColor: Color(0xFF85C1E5), // Header background color
//             colorScheme: ColorScheme.light(
//               primary: Color(0xFF85C1E5), // Circle color
//             ),
//             buttonTheme: ButtonThemeData(
//               textTheme: ButtonTextTheme.primary,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (pickedDate != null) {
//       // Validate that the selected date is not in the past
//       if (pickedDate.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
//         setState(() {
//           _dateError = "Cannot select a date in the past";
//           _selectedDate = "Select a Date";
//         });
//       } else {
//         setState(() {
//           _selectedDate = DateFormat("dd MMM yyyy").format(pickedDate); // Format date
//           _dateError = null;
//         });
//       }
//     }
//   }
//
//   // Validation function for budget name
//   bool _validateName() {
//     if (_nameController.text.isEmpty) {
//       setState(() {
//         _nameError = "Budget name cannot be empty";
//       });
//       return false;
//     } else if (_nameController.text.length < 3) {
//       setState(() {
//         _nameError = "Budget name must be at least 3 characters";
//       });
//       return false;
//     } else {
//       setState(() {
//         _nameError = null;
//       });
//       return true;
//     }
//   }
//
//   // Validation function for budget amount
//   bool _validateAmount() {
//     if (_amountController.text.isEmpty) {
//       setState(() {
//         _amountError = "Budget amount cannot be empty";
//       });
//       return false;
//     }
//
//     // Try to parse the amount as a number
//     try {
//       double amount = double.parse(_amountController.text);
//       if (amount <= 0) {
//         setState(() {
//           _amountError = "Amount must be greater than 0";
//         });
//         return false;
//       } else if (amount > 1000000) {
//         setState(() {
//           _amountError = "Amount cannot exceed 1,000,000";
//         });
//         return false;
//       } else {
//         setState(() {
//           _amountError = null;
//         });
//         return true;
//       }
//     } catch (e) {
//       setState(() {
//         _amountError = "Please enter a valid number";
//       });
//       return false;
//     }
//   }
//
//   // Validation function for date
//   bool _validateDate() {
//     if (_selectedDate == "Select a Date") {
//       setState(() {
//         _dateError = "Please select a date";
//       });
//       return false;
//     } else {
//       setState(() {
//         _dateError = null;
//       });
//       return true;
//     }
//   }
//
//   // Validate all fields
//   bool _validateAll() {
//     bool nameValid = _validateName();
//     bool amountValid = _validateAmount();
//     bool dateValid = _validateDate();
//
//     return nameValid && amountValid && dateValid;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: const EdgeInsets.all(25.0),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Create a New Budget",
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.close),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               Text("Enter the following details!"),
//               const SizedBox(height: 20),
//
//               Text("Budget Name"),
//               CustomInputField(
//                 hintText: "Christmas",
//                 controller: _nameController,
//               ),
//               if (_nameError != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 5.0),
//                   child: Text(
//                     _nameError!,
//                     style: TextStyle(color: Colors.red, fontSize: 12),
//                   ),
//                 ),
//               const SizedBox(height: 20),
//
//               Text("Estimated Total Budget"),
//               CustomInputField(
//                 hintText: "1000",
//                 controller: _amountController,
//                 keyboardType: TextInputType.number,
//               ),
//               if (_amountError != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 5.0),
//                   child: Text(
//                     _amountError!,
//                     style: TextStyle(color: Colors.red, fontSize: 12),
//                   ),
//                 ),
//               const SizedBox(height: 20),
//
//               Text("Select Date"),
//               GestureDetector(
//                 onTap: () => _pickDate(context),
//                 child: Container(
//                   padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: _dateError != null ? Colors.red : Colors.grey),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Text(
//                     _selectedDate,
//                     style: TextStyle(
//                         color: _selectedDate == "Select a Date" ? Colors.black54 : Colors.black,
//                         fontSize: 16
//                     ),
//                   ),
//                 ),
//               ),
//               if (_dateError != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 5.0),
//                   child: Text(
//                     _dateError!,
//                     style: TextStyle(color: Colors.red, fontSize: 12),
//                   ),
//                 ),
//               const SizedBox(height: 30),
//
//               CustomButton(
//                 text: "Create Budget",
//                 backgroundColor: const Color(0xFF1E232C),
//                 textColor: Colors.white,
//                 onPressed: () {
//                   if (_validateAll()) {
//                     widget.onBudgetCreated(
//                       _nameController.text,
//                       _amountController.text,
//                       _selectedDate,
//                     );
//                     Navigator.of(context).pop();
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// SECOND CODE
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:fynaura/pages/collab-budgeting/budgetDetails.dart';
// import 'package:fynaura/widgets/CustomButton.dart';
// import 'package:fynaura/widgets/backBtn.dart';
// import 'package:fynaura/widgets/customInput.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// // Budget Service class for API interactions
// class BudgetService {
//   final String baseUrl = "http://10.0.2.2:3000/collab-budgets"; // Change if deployed
//
//   Future<List<Map<String, dynamic>>> getBudgets() async {
//     final response = await http.get(Uri.parse(baseUrl));
//
//     if (response.statusCode == 200) {
//       List<dynamic> data = json.decode(response.body);
//       return data.cast<Map<String, dynamic>>();
//     } else {
//       throw Exception("Failed to load budgets");
//     }
//   }
//
//   Future<void> createBudget(String name, double amount, String date) async {
//     final response = await http.post(
//       Uri.parse(baseUrl),
//       headers: {"Content-Type": "application/json"},
//       body: json.encode({"name": name, "amount": amount, "date": date}),
//     );
//
//     if (response.statusCode != 201) {
//       throw Exception("Failed to create budget");
//     }
//   }
//
//   Future<void> deleteBudget(String id) async {
//     final response = await http.delete(Uri.parse("$baseUrl/$id"));
//
//     if (response.statusCode != 200) {
//       throw Exception("Failed to delete budget");
//     }
//   }
// }
//
// class CollabMain extends StatefulWidget {
//   const CollabMain({super.key});
//
//   @override
//   State<CollabMain> createState() => CollabMainState();
// }
//
// class CollabMainState extends State<CollabMain> {
//   List<Map<String, dynamic>> createdBudgets = []; // Store created budgets
//   bool isLoading = true;
//   String? errorMessage;
//   final BudgetService _budgetService = BudgetService();
//
//   @override
//   void initState() {
//     super.initState();
//     _loadBudgets();
//   }
//
//   // Load budgets from the API
//   Future<void> _loadBudgets() async {
//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//     });
//
//     try {
//       final budgets = await _budgetService.getBudgets();
//       setState(() {
//         createdBudgets = budgets;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         errorMessage = "Failed to load budgets: ${e.toString()}";
//         isLoading = false;
//       });
//     }
//   }
//
//   // Create a new budget via the API
//   Future<void> _addBudget(String name, String amount, String date) async {
//     try {
//       // Convert amount to double
//       double parsedAmount = double.parse(amount);
//       await _budgetService.createBudget(name, parsedAmount, date);
//
//       // Reload the budgets to get the updated list including the new one
//       await _loadBudgets();
//     } catch (e) {
//       setState(() {
//         errorMessage = "Failed to create budget: ${e.toString()}";
//       });
//     }
//   }
//
//   // Delete a budget via the API
//   Future<void> _deleteBudget(String id) async {
//     try {
//       await _budgetService.deleteBudget(id);
//       await _loadBudgets(); // Reload to get the updated list
//     } catch (e) {
//       setState(() {
//         errorMessage = "Failed to delete budget: ${e.toString()}";
//       });
//     }
//   }
//
//   void _showCreateBudgetPopup(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return CustomPopup(onBudgetCreated: _addBudget);
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: CustomBackButton(),
//       ),
//       body: RefreshIndicator(
//         onRefresh: _loadBudgets,
//         child: SingleChildScrollView(
//           physics: AlwaysScrollableScrollPhysics(),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Text(
//                     "Budget Plan",
//                     style: TextStyle(
//                       fontFamily: 'Urbanist',
//                       fontWeight: FontWeight.bold,
//                       fontSize: 30,
//                       color: Color(0xFF85C1E5),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   "Pinned Plans",
//                   style: TextStyle(
//                     fontFamily: 'Urbanist',
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16,
//                     color: Color(0xFF85C1E5),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Center(
//                   child: Text(
//                     "No plans pinned yet",
//                     style: TextStyle(
//                       fontFamily: 'Urbanist',
//                       fontWeight: FontWeight.w800,
//                       fontSize: 16,
//                       fontStyle: FontStyle.italic,
//                       color: Color(0xFFDADADA),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   "Created Plans",
//                   style: TextStyle(
//                     fontFamily: 'Urbanist',
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16,
//                     color: Color(0xFF85C1E5),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//
//                 // Show error message if any
//                 if (errorMessage != null)
//                   Container(
//                     padding: EdgeInsets.all(10),
//                     margin: EdgeInsets.only(bottom: 10),
//                     decoration: BoxDecoration(
//                       color: Colors.red.shade100,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Text(
//                       errorMessage!,
//                       style: TextStyle(color: Colors.red),
//                     ),
//                   ),
//
//                 // Show loading indicator
//                 if (isLoading)
//                   Center(
//                     child: CircularProgressIndicator(
//                       color: Color(0xFF85C1E5),
//                     ),
//                   ),
//
//                 // Show budgets if available
//                 if (!isLoading && createdBudgets.isEmpty)
//                   Center(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 20.0),
//                       child: Text(
//                         "No budgets created yet",
//                         style: TextStyle(
//                           fontFamily: 'Urbanist',
//                           fontWeight: FontWeight.w800,
//                           fontSize: 16,
//                           fontStyle: FontStyle.italic,
//                           color: Color(0xFFDADADA),
//                         ),
//                       ),
//                     ),
//                   ),
//
//                 // Budget list
//                 if (!isLoading && createdBudgets.isNotEmpty)
//                   Column(
//                     children: createdBudgets.map((budget) {
//                       return GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => BudgetDetails(
//                                 budgetName: budget["name"] ?? "",
//                                 budgetAmount: budget["amount"].toString(),
//                                 budgetDate: budget["date"] ?? "",
//                               ),
//                             ),
//                           ).then((_) => _loadBudgets()); // Reload after returning from details
//                         },
//                         child: Dismissible(
//                           key: Key(budget["id"]?.toString() ?? UniqueKey().toString()),
//                           background: Container(
//                             color: Colors.red,
//                             alignment: Alignment.centerRight,
//                             padding: EdgeInsets.symmetric(horizontal: 20),
//                             child: Icon(Icons.delete, color: Colors.white),
//                           ),
//                           direction: DismissDirection.endToStart,
//                           confirmDismiss: (direction) async {
//                             return await showDialog(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return AlertDialog(
//                                   title: Text("Confirm"),
//                                   content: Text("Are you sure you want to delete this budget?"),
//                                   actions: [
//                                     TextButton(
//                                       onPressed: () => Navigator.of(context).pop(false),
//                                       child: Text("Cancel"),
//                                     ),
//                                     TextButton(
//                                       onPressed: () => Navigator.of(context).pop(true),
//                                       child: Text("Delete", style: TextStyle(color: Colors.red)),
//                                     ),
//                                   ],
//                                 );
//                               },
//                             );
//                           },
//                           onDismissed: (direction) {
//                             _deleteBudget(budget["id"].toString());
//                           },
//                           child: Card(
//                             elevation: 3,
//                             margin: EdgeInsets.symmetric(vertical: 8),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             child: Padding(
//                               padding: EdgeInsets.all(16),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     budget["name"] ?? "Unnamed Budget",
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   SizedBox(height: 5),
//                                   LinearProgressIndicator(
//                                     value: 1.0,
//                                     backgroundColor: Color(0xFF85C1E5),
//                                     color: Color(0xFF85C1E5),
//                                   ),
//                                   SizedBox(height: 10),
//                                   Row(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "LKR ${budget["amount"].toString()}",
//                                             style: TextStyle(
//                                               fontSize: 14,
//                                               color: Colors.grey[700],
//                                             ),
//                                           ),
//                                           SizedBox(height: 5),
//                                           Text(
//                                             "Due: ${budget["date"] ?? "Not set"}",
//                                             style: TextStyle(
//                                               fontSize: 12,
//                                               color: Colors.grey[600],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Spacer(),
//                                       CircleAvatar(
//                                         radius: 20,
//                                         backgroundImage: AssetImage("images/user.png"),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//
//                 const SizedBox(height: 20),
//
//                 CustomButton(
//                   text: "Create a New Budget",
//                   backgroundColor: const Color(0xFF85C1E5),
//                   textColor: Colors.white,
//                   onPressed: () {
//                     _showCreateBudgetPopup(context);
//                   },
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // Custom Popup Widget with Date Picker
// class CustomPopup extends StatefulWidget {
//   final Function(String, String, String) onBudgetCreated;
//
//   CustomPopup({required this.onBudgetCreated});
//
//   @override
//   _CustomPopupState createState() => _CustomPopupState();
// }
//
// class _CustomPopupState extends State<CustomPopup> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _amountController = TextEditingController();
//   String _selectedDate = "Select a Date";
//
//   // Validation errors
//   String? _nameError;
//   String? _amountError;
//   String? _dateError;
//
//   Future<void> _pickDate(BuildContext context) async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//       builder: (context, child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             primaryColor: Color(0xFF85C1E5),
//             colorScheme: ColorScheme.light(
//               primary: Color(0xFF85C1E5),
//             ),
//             buttonTheme: ButtonThemeData(
//               textTheme: ButtonTextTheme.primary,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (pickedDate != null) {
//       // Validate that the selected date is not in the past
//       if (pickedDate.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
//         setState(() {
//           _dateError = "Cannot select a date in the past";
//           _selectedDate = "Select a Date";
//         });
//       } else {
//         setState(() {
//           _selectedDate = DateFormat("dd MMM yyyy").format(pickedDate);
//           _dateError = null;
//         });
//       }
//     }
//   }
//
//   // Validation function for budget name
//   bool _validateName() {
//     if (_nameController.text.isEmpty) {
//       setState(() {
//         _nameError = "Budget name cannot be empty";
//       });
//       return false;
//     } else if (_nameController.text.length < 3) {
//       setState(() {
//         _nameError = "Budget name must be at least 3 characters";
//       });
//       return false;
//     } else {
//       setState(() {
//         _nameError = null;
//       });
//       return true;
//     }
//   }
//
//   // Validation function for budget amount
//   bool _validateAmount() {
//     if (_amountController.text.isEmpty) {
//       setState(() {
//         _amountError = "Budget amount cannot be empty";
//       });
//       return false;
//     }
//
//     // Try to parse the amount as a number
//     try {
//       double amount = double.parse(_amountController.text);
//       if (amount <= 0) {
//         setState(() {
//           _amountError = "Amount must be greater than 0";
//         });
//         return false;
//       } else if (amount > 1000000) {
//         setState(() {
//           _amountError = "Amount cannot exceed 1,000,000";
//         });
//         return false;
//       } else {
//         setState(() {
//           _amountError = null;
//         });
//         return true;
//       }
//     } catch (e) {
//       setState(() {
//         _amountError = "Please enter a valid number";
//       });
//       return false;
//     }
//   }
//
//   // Validation function for date
//   bool _validateDate() {
//     if (_selectedDate == "Select a Date") {
//       setState(() {
//         _dateError = "Please select a date";
//       });
//       return false;
//     } else {
//       setState(() {
//         _dateError = null;
//       });
//       return true;
//     }
//   }
//
//   // Validate all fields
//   bool _validateAll() {
//     bool nameValid = _validateName();
//     bool amountValid = _validateAmount();
//     bool dateValid = _validateDate();
//
//     return nameValid && amountValid && dateValid;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: const EdgeInsets.all(25.0),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Create a New Budget",
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.close),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               Text("Enter the following details!"),
//               const SizedBox(height: 20),
//
//               Text("Budget Name"),
//               CustomInputField(
//                 hintText: "Christmas",
//                 controller: _nameController,
//               ),
//               if (_nameError != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 5.0),
//                   child: Text(
//                     _nameError!,
//                     style: TextStyle(color: Colors.red, fontSize: 12),
//                   ),
//                 ),
//               const SizedBox(height: 20),
//
//               Text("Estimated Total Budget"),
//               CustomInputField(
//                 hintText: "1000",
//                 controller: _amountController,
//                 keyboardType: TextInputType.number,
//               ),
//               if (_amountError != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 5.0),
//                   child: Text(
//                     _amountError!,
//                     style: TextStyle(color: Colors.red, fontSize: 12),
//                   ),
//                 ),
//               const SizedBox(height: 20),
//
//               Text("Select Date"),
//               GestureDetector(
//                 onTap: () => _pickDate(context),
//                 child: Container(
//                   padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: _dateError != null ? Colors.red : Colors.grey),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Text(
//                     _selectedDate,
//                     style: TextStyle(
//                         color: _selectedDate == "Select a Date" ? Colors.black54 : Colors.black,
//                         fontSize: 16
//                     ),
//                   ),
//                 ),
//               ),
//               if (_dateError != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 5.0),
//                   child: Text(
//                     _dateError!,
//                     style: TextStyle(color: Colors.red, fontSize: 12),
//                   ),
//                 ),
//               const SizedBox(height: 30),
//
//               CustomButton(
//                 text: "Create Budget",
//                 backgroundColor: const Color(0xFF1E232C),
//                 textColor: Colors.white,
//                 onPressed: () {
//                   if (_validateAll()) {
//                     widget.onBudgetCreated(
//                       _nameController.text,
//                       _amountController.text,
//                       _selectedDate,
//                     );
//                     Navigator.of(context).pop();
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fynaura/pages/collab-budgeting/budgetDetails.dart';
import 'package:fynaura/widgets/CustomButton.dart';
import 'package:fynaura/widgets/backBtn.dart';
import 'package:fynaura/widgets/customInput.dart';
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

  // Create a new budget via the API
  // Future<void> _addBudget(String name, String amount, String date) async {
  //   try {
  //     // Convert amount to double
  //     double parsedAmount = double.parse(amount);
  //     await _budgetService.createBudget(name, parsedAmount, date);
  //
  //     // Reload the budgets to get the updated list including the new one
  //     await _loadBudgets();
  //   } catch (e) {
  //     setState(() {
  //       errorMessage = "Failed to create budget: ${e.toString()}";
  //     });
  //   }
  // }
  Future<void> _addBudget(String name, String amount, String date) async {
    try {
      double parsedAmount = double.parse(amount);
      String userId = "123456"; // Replace with actual user ID

      await _budgetService.createBudget(name, parsedAmount, date, userId);
      await _loadBudgets();
    } catch (e) {
      setState(() {
        errorMessage = "Failed to create budget: ${e.toString()}";
      });
    }
  }

  // Delete a budget via the API
  Future<void> _deleteBudget(String id) async {
    try {
      await _budgetService.deleteBudget(id);
      await _loadBudgets(); // Reload to get the updated list
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
                              ),
                            ),
                          ).then((_) => _loadBudgets()); // Reload after returning from details
                        },
                        child: Dismissible(
                          key: Key(budget["id"]?.toString() ?? UniqueKey().toString()),
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
                                  content: Text("Are you sure you want to delete this budget?"),
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                        backgroundImage: AssetImage("images/user.png"),
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