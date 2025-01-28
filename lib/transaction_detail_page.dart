import 'package:flutter/material.dart';

class TransactionDetailPage extends StatelessWidget {
  final String category;
  final bool isExpense;

  TransactionDetailPage({required this.category, required this.isExpense});

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  final List<String> currencies = [
    'LKR - Sri Lankan Rupee',
    'USD - US Dollar',
    'EUR - Euro',
    'GBP - British Pound',
    'INR - Indian Rupee',
    'JPY - Japanese Yen',
    'AUD - Australian Dollar',
  ]; // Add more as needed

  String selectedCurrency = 'LKR - Sri Lankan Rupee'; // Default currency

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add ${isExpense ? "Expense" : "Income"}: $category',
          style: TextStyle(
            color: Color(0xFF9DB2CE), // Set the title color
          ),),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description Field
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Amount Field
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),

            // Currency Dropdown
            Row(
              children: [
                Text(
                  'Currency:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedCurrency,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down),
                    elevation: 16,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    underline: Container(
                      height: 2,
                      color: Colors.blueAccent,
                    ),
                    onChanged: (String? newValue) {
                      selectedCurrency = newValue!;
                    },
                    items: currencies.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Buttons for Save as Draft and Upload
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Save as Draft Logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Saved as Draft')),
                    );
                  },
                  child: Text('Save as Draft'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Upload Logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Uploaded with ${selectedCurrency.split(" - ")[0]} currency')),
                    );
                  },
                  child: Text('Upload'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
