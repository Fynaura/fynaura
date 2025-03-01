// // import 'package:flutter/material.dart';
// // import 'package:fynaura/widgets/CustomButton.dart';
// // import 'package:fynaura/widgets/backBtn.dart';
// //
// // class BudgetDetails extends StatefulWidget {
// //   final String budgetName;
// //   final String budgetAmount;
// //   final String budgetDate;
// //
// //   const BudgetDetails({
// //     super.key,
// //     required this.budgetName,
// //     required this.budgetAmount,
// //     required this.budgetDate,
// //   });
// //
// //   @override
// //   State<BudgetDetails> createState() => _BudgetDetailsState();
// // }
// //
// // class _BudgetDetailsState extends State<BudgetDetails> {
// //   List<String> avatars = ["images/user.png"]; // Initial avatar list
// //   //
// //   // void _addAvatar() {
// //   //   setState(() {
// //   //     avatars.add("images/user.png"); // Add new avatar
// //   //   });
// //   // }
// //   void _addAvatar() {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return Dialog(
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(20),
// //           ),
// //           child: Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Row(
// //                   children: [
// //                     Icon(Icons.person_add, size: 24, color: Colors.black54),
// //                     SizedBox(width: 8),
// //                     Text(
// //                       "Invite Collaborators",
// //                       style: TextStyle(
// //                         fontSize: 18,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     Spacer(),
// //                     IconButton(
// //                       icon: Icon(Icons.close, color: Colors.black54),
// //                       onPressed: () => Navigator.pop(context),
// //                     ),
// //                   ],
// //                 ),
// //                 SizedBox(height: 10),
// //                 Text("Your budget has been created. Invite your friends to join!"),
// //                 SizedBox(height: 10),
// //                 TextField(
// //                   decoration: InputDecoration(
// //                     prefixIcon: Icon(Icons.person),
// //                     hintText: "User ID",
// //                     border: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                   ),
// //                 ),
// //                 SizedBox(height: 10),
// //                 TextField(
// //                   decoration: InputDecoration(
// //                     prefixIcon: Icon(Icons.person),
// //                     hintText: "User ID",
// //                     border: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                   ),
// //                 ),
// //                 SizedBox(height: 10),
// //                 TextButton.icon(
// //                   onPressed: () {},
// //                   icon: Icon(Icons.add, color: Colors.blue),
// //                   label: Text("Add another", style: TextStyle(color: Colors.blue)),
// //                 ),
// //                 SizedBox(height: 10),
// //                 ElevatedButton(
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: Colors.black,
// //                     foregroundColor: Colors.white,
// //                     minimumSize: Size(double.infinity, 50),
// //                   ),
// //                   onPressed: () {},
// //                   child: Text("Confirm"),
// //                 ),
// //                 SizedBox(height: 10),
// //                 OutlinedButton.icon(
// //                   onPressed: () {},
// //                   icon: Icon(Icons.qr_code, color: Colors.black),
// //                   label: Text("Scan QR code", style: TextStyle(color: Colors.black)),
// //                   style: OutlinedButton.styleFrom(
// //                     minimumSize: Size(double.infinity, 50),
// //                     side: BorderSide(color: Colors.black),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         leading: CustomBackButton(),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Stack(
// //               children: [
// //                 Container(
// //                   width: 380,
// //                   height: 180,
// //                   decoration: BoxDecoration(
// //                     gradient: LinearGradient(
// //                       colors: [Color(0xFF1E1E1E), Color(0xFF2C3E50)],
// //                       begin: Alignment.topCenter,
// //                       end: Alignment.bottomCenter,
// //                     ),
// //                     borderRadius: BorderRadius.circular(20),
// //                   ),
// //                 ),
// //                 Positioned(
// //                   top: 20,
// //                   left: 20,
// //                   child: Container(
// //                     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //                     decoration: BoxDecoration(
// //                       color: Colors.white,
// //                       borderRadius: BorderRadius.circular(20),
// //                     ),
// //                     child: Text(
// //                       "Budget For " + widget.budgetName,
// //                       style: TextStyle(
// //                         fontSize: 14,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 Positioned(
// //                   bottom: 20,
// //                   left: 20,
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         "Accumulated Balance",
// //                         style: TextStyle(
// //                           fontSize: 18,
// //                           color: Colors.white70,
// //                         ),
// //                       ),
// //                       Text(
// //                         "LKR ${widget.budgetAmount}",
// //                         style: TextStyle(
// //                           fontSize: 22,
// //                           fontWeight: FontWeight.bold,
// //                           color: Colors.white,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 Positioned(
// //                   top: 20,
// //                   right: 20,
// //                   child: Text(
// //                     widget.budgetDate,
// //                     style: TextStyle(
// //                       fontSize: 14,
// //                       color: Colors.white,
// //                     ),
// //                   ),
// //                 ),
// //                 Positioned(
// //                   bottom: 20,
// //                   right: 20,
// //                   child: Column(
// //                     children: [
// //                       Stack(
// //                         alignment: Alignment.center,
// //                         children: [
// //                           SizedBox(
// //                             width: 50,
// //                             height: 50,
// //                             child: CircularProgressIndicator(
// //                               value: 0.1, // 10% remaining
// //                               strokeWidth: 5,
// //                               backgroundColor: Colors.white24,
// //                               valueColor:
// //                               AlwaysStoppedAnimation<Color>(Color(0xFF85C1E5)),
// //                             ),
// //                           ),
// //                           Text(
// //                             "10%",
// //                             style: TextStyle(
// //                               fontSize: 14,
// //                               fontWeight: FontWeight.bold,
// //                               color: Colors.white,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       SizedBox(height: 5),
// //                       Text(
// //                         "Remaining",
// //                         style: TextStyle(fontSize: 12, color: Colors.white70),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 25),
// //
// //             // Avatar List with Plus Button
// //             // Stack(
// //             //   children: [
// //             //     Container(
// //             //       width: 380,
// //             //       height: 80,
// //             //       decoration: BoxDecoration(
// //             //         color: Color(0xFF26252A),
// //             //         borderRadius: BorderRadius.circular(20),
// //             //       ),
// //             //     ),
// //             //     Row(
// //             //       children: [
// //             //         ...avatars.asMap().entries.map((entry) {
// //             //           int index = entry.key;
// //             //           return Positioned(
// //             //             left: 20 + (index * 60), // Adjusts avatar position dynamically
// //             //             top: 100,
// //             //             child: CircleAvatar(
// //             //               radius: 20,
// //             //               backgroundImage: AssetImage(entry.value),
// //             //             ),
// //             //           );
// //             //         }).toList(),
// //             //         Positioned(
// //             //           left: 20 + (avatars.length * 60),
// //             //           top: 100,
// //             //           child: GestureDetector(
// //             //             onTap: _addAvatar,
// //             //             child: CircleAvatar(
// //             //               radius: 20,
// //             //               backgroundColor: Colors.white,
// //             //               child: Icon(Icons.add, color: Colors.black),
// //             //             ),
// //             //           ),
// //             //         ),
// //             //       ],
// //             //     ),
// //             //   ],
// //             // ),
// //             // Avatar List with Plus Button
// //             Container(
// //               width: 380,
// //               padding: const EdgeInsets.all(16),
// //               decoration: BoxDecoration(
// //                 color: const Color(0xFF26252A),
// //                 borderRadius: BorderRadius.circular(20),
// //               ),
// //               child: Row(
// //                 children: [
// //                   ...avatars.map((avatar) {
// //                     return Padding(
// //                       padding: const EdgeInsets.only(right: 10),
// //                       child: CircleAvatar(
// //                         radius: 20,
// //                         backgroundImage: AssetImage(avatar),
// //                       ),
// //                     );
// //                   }).toList(),
// //                   GestureDetector(
// //                     onTap: _addAvatar,
// //                     child: CircleAvatar(
// //                       radius: 20,
// //                       backgroundColor: Colors.white,
// //                       child: const Icon(Icons.add, color: Colors.black),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //
// //
// //
// //             const SizedBox(height: 25),
// //             const Text(
// //               "Recent Activity",
// //               style: TextStyle(
// //                 fontFamily: 'Urbanist',
// //                 fontWeight: FontWeight.w600,
// //                 fontSize: 25,
// //                 color: Color(0xFF26252A),
// //               ),
// //             ),
// //             const SizedBox(height: 15),
// //             Center(
// //               child: Text(
// //                 "No activities yet",
// //                 style: TextStyle(
// //                   fontFamily: 'Urbanist',
// //                   fontWeight: FontWeight.w800,
// //                   fontSize: 16,
// //                   fontStyle: FontStyle.italic,
// //                   color: Color(0xFFDADADA),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:fynaura/pages/collab-budgeting/scanQr.dart';
// import 'package:fynaura/widgets/CustomButton.dart';
// import 'package:fynaura/widgets/backBtn.dart';
//
// class BudgetDetails extends StatefulWidget {
//   final String budgetName;
//   final String budgetAmount;
//   final String budgetDate;
//
//   const BudgetDetails({
//     super.key,
//     required this.budgetName,
//     required this.budgetAmount,
//     required this.budgetDate,
//   });
//
//   @override
//   State<BudgetDetails> createState() => _BudgetDetailsState();
// }
//
// class _BudgetDetailsState extends State<BudgetDetails> {
//   List<String> avatars = ["images/user.png"]; // Initial avatar list
//
//   void _addAvatar() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.person_add, size: 24, color: Colors.black54),
//                     SizedBox(width: 8),
//                     Text(
//                       "Invite Collaborators",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Spacer(),
//                     IconButton(
//                       icon: Icon(Icons.close, color: Colors.black54),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 Text("Your budget has been created. Invite your friends to join!"),
//                 SizedBox(height: 10),
//                 TextField(
//                   decoration: InputDecoration(
//                     prefixIcon: Icon(Icons.person),
//                     hintText: "User ID",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.black,
//                     foregroundColor: Colors.white,
//                     minimumSize: Size(double.infinity, 50),
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       avatars.add("images/user.png"); // Add new avatar
//                     });
//                     Navigator.pop(context); // Close the popup
//                   },
//                   child: Text("Confirm"),
//                 ),
//                 SizedBox(height: 10),
//                 OutlinedButton.icon(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const Scanqr()),
//                     );
//                   },
//                   icon: Icon(Icons.qr_code, color: Colors.black),
//                   label: Text("Scan QR Code", style: TextStyle(color: Colors.black)),
//                   style: OutlinedButton.styleFrom(
//                     minimumSize: Size(double.infinity, 50),
//                     side: BorderSide(color: Colors.black),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
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
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 Container(
//                   width: 380,
//                   height: 180,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Color(0xFF1E1E1E), Color(0xFF2C3E50)],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                     ),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//                 Positioned(
//                   top: 20,
//                   left: 20,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       "Budget For " + widget.budgetName,
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 20,
//                   left: 20,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Accumulated Balance",
//                         style: TextStyle(
//                           fontSize: 18,
//                           color: Colors.white70,
//                         ),
//                       ),
//                       Text(
//                         "LKR ${widget.budgetAmount}",
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                   top: 20,
//                   right: 20,
//                   child: Text(
//                     widget.budgetDate,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 20,
//                   right: 20,
//                   child: Column(
//                     children: [
//                       Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           SizedBox(
//                             width: 50,
//                             height: 50,
//                             child: CircularProgressIndicator(
//                               value: 0.1, // 10% remaining
//                               strokeWidth: 5,
//                               backgroundColor: Colors.white24,
//                               valueColor:
//                               AlwaysStoppedAnimation<Color>(Color(0xFF85C1E5)),
//                             ),
//                           ),
//                           Text(
//                             "10%",
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 5),
//                       Text(
//                         "Remaining",
//                         style: TextStyle(fontSize: 12, color: Colors.white70),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 25),
//
//             // Avatar List with Plus Button
//             Container(
//               width: 380,
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF26252A),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Row(
//                 children: [
//                   ...avatars.map((avatar) {
//                     return Padding(
//                       padding: const EdgeInsets.only(right: 10),
//                       child: CircleAvatar(
//                         radius: 20,
//                         backgroundImage: AssetImage(avatar),
//                       ),
//                     );
//                   }).toList(),
//                   GestureDetector(
//                     onTap: _addAvatar,
//                     child: CircleAvatar(
//                       radius: 20,
//                       backgroundColor: Colors.white,
//                       child: const Icon(Icons.add, color: Colors.black),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 25),
//             const Text(
//               "Recent Activity",
//               style: TextStyle(
//                 fontFamily: 'Urbanist',
//                 fontWeight: FontWeight.w600,
//                 fontSize: 25,
//                 color: Color(0xFF26252A),
//               ),
//             ),
//             const SizedBox(height: 15),
//             Center(
//               child: Text(
//                 "No activities yet",
//                 style: TextStyle(
//                   fontFamily: 'Urbanist',
//                   fontWeight: FontWeight.w800,
//                   fontSize: 16,
//                   fontStyle: FontStyle.italic,
//                   color: Color(0xFFDADADA),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:fynaura/pages/collab-budgeting/scanQr.dart';
import 'package:fynaura/widgets/CustomButton.dart';
import 'package:fynaura/widgets/backBtn.dart';

class BudgetDetails extends StatefulWidget {
  final String budgetName;
  final String budgetAmount;
  final String budgetDate;

  const BudgetDetails({
    super.key,
    required this.budgetName,
    required this.budgetAmount,
    required this.budgetDate,
  });

  @override
  State<BudgetDetails> createState() => _BudgetDetailsState();
}

class _BudgetDetailsState extends State<BudgetDetails> {
  List<String> avatars = ["images/user.png"]; // Initial avatar list

  // Track the current balance and activities
  late double currentAmount;
  double percentageRemaining = 10; // Starting at 10% as in the original code

  // List to store activities
  List<Map<String, dynamic>> activities = [];

  @override
  void initState() {
    super.initState();
    // Initialize the current amount from the budget amount passed from collab main
    currentAmount =
        double.tryParse(widget.budgetAmount.replaceAll(',', '')) ?? 50000;
  }

  void _addAvatar() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                Text(
                    "Your budget has been created. Invite your friends to join!"),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: "User ID",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    setState(() {
                      avatars.add("images/user.png"); // Add new avatar
                    });
                    Navigator.pop(context); // Close the popup
                  },
                  child: Text("Confirm"),
                ),
                SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Scanqr()),
                    );
                  },
                  icon: Icon(Icons.qr_code, color: Colors.black),
                  label: Text(
                      "Scan QR Code", style: TextStyle(color: Colors.black)),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    side: BorderSide(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Show dialog to add new expense or income
  void _showAddTransactionDialog() {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    bool isExpense = true;

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
                      onPressed: () {
                        // Get amount from controller
                        double amount = double.tryParse(
                            amountController.text) ?? 0;
                        if (amount <= 0 || descriptionController.text.isEmpty) {
                          // Show error
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(
                                "Please enter valid amount and description")),
                          );
                          return;
                        }

                        // Update the current amount based on whether it's expense or income
                        this.setState(() {
                          if (isExpense) {
                            // Add expense activity - appearance based on your mockup
                            activities.add({
                              "avatar": "images/user.png",
                              "name": "John Doe",
                              "description": descriptionController.text,
                              "amount": "LKR ${amount.toStringAsFixed(0)}",
                              "isExpense": true,
                            });

                            // Only update percentage (not the total balance as specified)
                            percentageRemaining = (percentageRemaining - 1) > 0
                                ? percentageRemaining - 1
                                : 0;
                          } else {
                            // Add income activity - appearance based on your mockup
                            activities.add({
                              "avatar": "images/user.png",
                              "name": "John Doe",
                              "description": descriptionController.text,
                              "amount": "LKR ${amount.toStringAsFixed(0)}",
                              "isExpense": false,
                            });

                            // Increase percentage for income
                            percentageRemaining =
                            (percentageRemaining + 1) < 100
                                ? percentageRemaining + 1
                                : 100;
                          }
                        });

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
                        "LKR ${widget.budgetAmount}",
                        // Keep original format as requested
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
                              valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF85C1E5)),
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
                          color: activity["isExpense"] ? Colors.red : Colors
                              .green,
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