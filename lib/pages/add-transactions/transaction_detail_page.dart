import 'dart:convert';
import 'package:flutter/material.dart';
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
            onPressed: () async {
              // Build the request body using the entered data
              var requestBody = {
                "type": isExpense ? "expense" : "income",
                "amount": int.tryParse(amountController.text) ?? 0, // Parse the amount
                "category": selectedCategory,
                "note": descriptionController.text,
                "date": "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}",
                "reminder": reminder,
              };

              // Set the headers
              var headers = {
                'Content-Type': 'application/json'
              };

              // Create the HTTP request
              var request = http.Request('POST', Uri.parse('http://192.168.56.1:8000/api/transaction'));
              request.body = json.encode(requestBody);
              request.headers.addAll(headers);

              try {
                // Send the request
                http.StreamedResponse response = await request.send();

                // Handle the response
                if (response.statusCode == 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Transaction Added Successfully")),
                  );
                  print(await response.stream.bytesToString());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to Add Transaction: ${response.reasonPhrase}")),
                  );
                  print(response.reasonPhrase);
                }
              } catch (e) {
                // Handle error if the request fails
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: $e")),
                );
              }
            },
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildCameraGalleryButton("Camera", Icons.camera_alt, Colors.blue),
                buildCameraGalleryButton("Gallery", Icons.photo, Colors.orange),
              ],
            ),
            SizedBox(height: 20),
            // Save Transaction Button
            ElevatedButton(
              onPressed: () async {
                // Build the request body using the entered data
                var requestBody = {
                  "type": isExpense ? "expense" : "income",
                  "amount": int.tryParse(amountController.text) ?? 0, // Parse the amount
                  "category": selectedCategory,
                  "note": descriptionController.text,
                  "date": "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}",
                  "reminder": reminder,
                };

                // Set the headers
                var headers = {
                  'Content-Type': 'application/json'
                };

                // Create the HTTP request
                var request = http.Request('POST', Uri.parse('http://localhost:8000/api/transaction'));
                request.body = json.encode(requestBody);
                request.headers.addAll(headers);

                try {
                  // Send the request
                  http.StreamedResponse response = await request.send();

                  // Handle the response
                  if (response.statusCode == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Transaction Added Successfully")),
                    );
                    print(await response.stream.bytesToString());
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to Add Transaction: ${response.reasonPhrase}")),
                    );
                    print(response.reasonPhrase);
                  }
                } catch (e) {
                  // Handle error if the request fails
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: $e")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Use backgroundColor instead of primary
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
      onChanged: (value) {
        setState(() {});
      },
    );
  }

  Widget buildModernDescriptionField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: descriptionController,
        decoration: InputDecoration(
          hintText: "Add Description...",
          hintStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey.shade600),
          border: InputBorder.none,
          prefixIcon: Icon(Icons.edit, color: Colors.grey.shade700),
        ),
        style: TextStyle(fontSize: 18),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget buildModernOptionTile(String title, IconData icon, String hint, BuildContext context, bool isCategory) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey.shade700),
        title: Text(hint, style: TextStyle(color: Colors.black54)),
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
      ),
    );
  }

  Widget buildCameraGalleryButton(String title, IconData icon, Color color) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.white),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
