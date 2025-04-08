import 'package:flutter/material.dart';
import 'package:fynaura/pages/home/main_screen.dart'; // Import MainScreen
import 'package:fynaura/pages/add-transactions/transaction_detail_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ocr_screen.dart';
import 'package:fynaura/pages/user-session/UserSession.dart'; // Import UserSession

class ExtractedTextScreen extends StatelessWidget {
  final String totalAmount;
  final List<Map<String, dynamic>> categorizedItems;

  // Define app's color palette based on Dashboard/AnalyzePage
  static const Color primaryColor = Color(0xFF254e7a);     // Primary blue
  static const Color accentColor = Color(0xFF85c1e5);      // Light blue accent
  static const Color lightBgColor = Color(0xFFEBF1FD);     // Light background
  static const Color whiteColor = Colors.white;            // White background

  const ExtractedTextScreen({
    super.key,
    required this.totalAmount,
    required this.categorizedItems,
  });

  // Function to send the extracted data to the backend for saving
  Future<void> _saveData(BuildContext context) async {
    final userSession = UserSession();
    final uid = userSession.userId;
    List<Map<String, dynamic>> formattedData = categorizedItems.map((item) {
      return {
        'type': 'expense', // Always set to 'expense'
        'amount': item['price'], // Assuming 'price' field is the amount
        'category': item['category'],
        'description':
            item['item'], // Assuming 'item' field is the description/note
        'date': item['billdate'] is DateTime
            ? item['billdate'].toIso8601String()
            : item['billdate'], // Ensure date is in ISO format
        'reminder': false, // Always false
        'userId': uid,
      };
    }).toList();

    var uri = Uri.parse(
        "http://192.168.8.172:3000/transaction/bulk"); // Replace with your API URL

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: primaryColor),
                  SizedBox(width: 20),
                  Text(
                    "Saving transactions...",
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      var response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(formattedData),
      );

      // Close loading dialog
      Navigator.of(context, rootNavigator: true).pop();

      if (response.statusCode == 200) {
        print("Data saved successfully!");
        // Show success dialog
        _showSuccessDialog(context);
      } else {
        print("Failed to save data. Status Code: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: Could not save data."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Close loading dialog if error occurs
      Navigator.of(context, rootNavigator: true).pop();
      print("Exception occurred: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An unexpected error occurred. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Success dialog after data is saved
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: primaryColor,
                child: Icon(Icons.check, color: whiteColor, size: 40),
              ),
              const SizedBox(height: 16),
              Text(
                "Transaction Added Successfully",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TransactionDetailsPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: whiteColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    "Add Another Transaction",
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);

                    // Retrieve user details from UserSession
                    String? userId = UserSession().userId;
                    String? displayName = UserSession().displayName;
                    String? email = UserSession().email;

                    // Navigate to MainScreen if userId exists
                    if (userId != null &&
                        displayName != null &&
                        email != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainScreen(),
                        ),
                      );
                    } else {
                      // Fallback: Navigate to OcrScreen if no user is logged in
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => OcrScreen()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lightBgColor,
                    foregroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: primaryColor, width: 1.5),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Go to Dashboard",
                    style: TextStyle(
                      color: primaryColor, 
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBgColor,
      appBar: AppBar(
        title: Text(
          "Extracted Receipt Details",
          style: TextStyle(
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton.icon(
              onPressed: () => _saveData(context),
              icon: Icon(Icons.save, color: whiteColor),
              label: Text(
                "Save",
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Amount Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.payment, color: whiteColor),
                  SizedBox(width: 8),
                  Text(
                    "Total Bill Amount",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: whiteColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            
            // Total Amount Value
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "LKR $totalAmount",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            // Items Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.receipt_long, color: whiteColor),
                  SizedBox(width: 8),
                  Text(
                    "Receipt Items",
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
            
            // Items List
            Expanded(
              child: categorizedItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long,
                            size: 60,
                            color: primaryColor.withOpacity(0.5),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "No items detected in this receipt",
                            style: TextStyle(
                              color: primaryColor.withOpacity(0.7),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: categorizedItems.length,
                      itemBuilder: (context, index) {
                        final item = categorizedItems[index];
                        return _buildItemCard(item);
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: whiteColor,
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () => _saveData(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: whiteColor,
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.save, size: 20),
              SizedBox(width: 10),
              Text(
                "Save Transaction",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item) {
    // Determine a suitable icon based on item category
    IconData categoryIcon = Icons.category;
    final categoryName = (item['category'] ?? "").toString().toLowerCase();
    
    if (categoryName.contains('food') || categoryName.contains('grocery')) {
      categoryIcon = Icons.restaurant;
    } else if (categoryName.contains('transport') || categoryName.contains('travel')) {
      categoryIcon = Icons.directions_car;
    } else if (categoryName.contains('bill') || categoryName.contains('utilities')) {
      categoryIcon = Icons.power;
    } else if (categoryName.contains('shopping') || categoryName.contains('clothes')) {
      categoryIcon = Icons.shopping_bag;
    } else if (categoryName.contains('entertainment')) {
      categoryIcon = Icons.movie;
    } else if (categoryName.contains('health') || categoryName.contains('medical')) {
      categoryIcon = Icons.medical_services;
    } else if (categoryName.contains('education')) {
      categoryIcon = Icons.school;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Item Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    categoryIcon,
                    color: primaryColor,
                    size: 20,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item['item'] ?? "Unknown Item",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "LKR ${item['price']}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: whiteColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Item Details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildDetailRow("Category", item['category'] ?? "Uncategorized"),
                SizedBox(height: 8),
                _buildDetailRow("Quantity", item['quantity']?.toString() ?? "1"),
                SizedBox(height: 8),
                _buildDetailRow("Date", item['billdate'] ?? "Not specified"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text(
          "$label:",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}