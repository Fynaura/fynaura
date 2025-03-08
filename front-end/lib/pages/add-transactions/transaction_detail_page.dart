
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:fynaura/pages/ocr/ImageSelectionOption.dart' as ocrScreen;
import 'package:http/http.dart' as http;
import 'transaction_category_page.dart';


class TransactionDetailPage extends StatefulWidget {
  @override
  _TransactionDetailPageState createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  bool isExpense = true;
  String selectedCategory = "Select Category";
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  bool reminder = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Add Transaction', style: TextStyle(color: Color(0xFF9DB2CE))),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: Colors.blue),
            onPressed: _saveTransaction,
          ),
        ],

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildToggleButton("Income", !isExpense),
                buildToggleButton("Expense", isExpense),
              ],
            ),
            SizedBox(height: 10),
            buildModernAmountField(),
            buildModernOptionTile("Category", Icons.toc, selectedCategory, context, true),
            buildModernDescriptionField(),
            buildModernOptionTile("Set Date", Icons.calendar_today, "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}", context, false),
            buildModernOptionTile("Set Reminder", Icons.alarm, reminder ? "Reminder Set" : "Set Reminder", context, false),
            Spacer(),
            // Camera Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ocrScreen.OcrScreen()),
                );
              },
              icon: Icon(Icons.camera_alt, color: Colors.white),
              label: Text("Scan Receipt"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveTransaction,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'SAVE TRANSACTION',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveTransaction() async {
    var requestBody = {
      "type": isExpense ? "expense" : "income",
      "amount": int.tryParse(amountController.text) ?? 0,
      "category": selectedCategory,
      "note": descriptionController.text,
      "date": "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}",
      "reminder": reminder,
    };

    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse('http://localhost:8000/api/transaction'));
    request.body = json.encode(requestBody);
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Transaction Added Successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to Add Transaction: ${response.reasonPhrase}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Widget buildToggleButton(String text, bool selected) {
    return ElevatedButton(
      onPressed: () => setState(() => isExpense = text == "Expense"),
      child: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? Color(0xFF85C1E5) : Colors.grey,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget buildModernAmountField() {
    return TextField(
      controller: amountController,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        prefixText: "LKR ",
        hintText: "00",
        hintStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.w300, color: Colors.grey),
        border: InputBorder.none,
      ),
    );
  }

  Widget buildModernDescriptionField() {
    return TextField(
      controller: descriptionController,
      decoration: InputDecoration(
        hintText: "Add Description...",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: Icon(Icons.edit),
      ),
    );
  }

  Widget buildModernOptionTile(String title, IconData icon, String hint, BuildContext context, bool isCategory) {
    return ListTile(
      leading: Icon(icon),
      title: Text(hint),
      onTap: () async {
        if (isCategory) {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TransactionCategoryPage(isExpense: isExpense)),
          );
          if (result != null) {
            setState(() => selectedCategory = result);
          }
        } else if (title == "Set Date") {
          final date = await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (date != null) setState(() => selectedDate = date);
        } else if (title == "Set Reminder") {
          setState(() {
            reminder = !reminder;
          });
        }
      },
    );
  }
}

