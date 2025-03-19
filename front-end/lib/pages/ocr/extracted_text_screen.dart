import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ocr_screen.dart';

class ExtractedTextScreen extends StatelessWidget {
  final String totalAmount;
  final List<Map<String, dynamic>> categorizedItems;

  const ExtractedTextScreen({
    super.key,
    required this.totalAmount,
    required this.categorizedItems,
  });

  // Function to send the extracted data to the backend for saving
  Future<void> _saveData(BuildContext context) async {
    List<Map<String, dynamic>> formattedData = categorizedItems.map((item) {
      return {
        'type': 'expense',  // Always set to 'expense'
        'amount': item['price'],  // Assuming 'price' field is the amount
        'category': item['category'], 
        'description': item['item'],  // Assuming 'item' field is the description/note
        'date': item['billdate'] is DateTime 
            ? item['billdate'].toIso8601String() 
            : item['billdate'],  // Ensure date is in ISO format
        'reminder': false,  // Always false
      };
    }).toList();

    var uri = Uri.parse("http://192.168.127.53:3000/transaction/bulk");  // Replace with your API URL

    var response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(formattedData),
    );

    if (response.statusCode == 200) {
      print("Data saved successfully!");
      // Show success dialog
      _showSuccessDialog(context);
    } else {
      print("Failed to save data. Status Code: ${response.statusCode}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: Could not save data.")),
      );
    }
  }

  // Success dialog after data is saved
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue,
                child: Icon(Icons.check, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 16),
              const Text(
                "Transaction Added Successfully",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const OcrScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Text("Add Another Transaction", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const OcrScreen()), // Navigate to home page
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Text("Home", style: TextStyle(color: Colors.white, fontSize: 16)),
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
      appBar: AppBar(
        foregroundColor: Colors.blue[300],
        backgroundColor: Colors.grey[200],
        title: const Text("Extracted Details"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: TextButton(
              onPressed: () => _saveData(context),
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
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
            _buildDetailRow("Total Bill Amount", "\$$totalAmount", Colors.black),
            const SizedBox(height: 5),
            Expanded(
              child: ListView.builder(
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
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.lightBlue[100],
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildText("Item", color: Colors.blue, isBold: true, size: 20),
            const SizedBox(height: 10),
            _buildRichText("Category    ", item['category']),
            _buildRichText("Item name ", item['item']),
            _buildRichText("Price           ", "\$${item['price']}", color: Colors.black),
            _buildRichText("Date            ", item['billdate']),
            _buildRichText("Quantity     ", item['quantity'].toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildText(String text, {Color? color, bool isBold = false, double size = 16}) {
    return Text(
      text,
      style: TextStyle(fontSize: size, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: color),
    );
  }

  Widget _buildRichText(String label, String value, {Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          children: [
            TextSpan(text: "$label: ", style: TextStyle(color: Colors.black)),
            TextSpan(text: value, style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color color) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
        children: [
          TextSpan(text: "$label: "),
          TextSpan(text: value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
