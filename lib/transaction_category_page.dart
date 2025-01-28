import 'package:flutter/material.dart';
import 'transaction_detail_page.dart';

class TransactionCategoryPage extends StatefulWidget {
  @override
  _TransactionCategoryPageState createState() =>
      _TransactionCategoryPageState();
}

class _TransactionCategoryPageState extends State<TransactionCategoryPage> {
  bool isExpense = true; // Toggle between Expense and Income

  final List<Map<String, String>> _expenseCategories = [
    {'icon': '🍔', 'name': 'Food'},
    {'icon': '🛍️', 'name': 'Shopping'},
    {'icon': '🚗', 'name': 'Transport'},
    {'icon': '💊', 'name': 'Health'},
    {'icon': '🎓', 'name': 'Education'},
    {'icon': '📱', 'name': 'Phone'},
    {'icon': '⚽', 'name': 'Sport'},
    {'icon': '💄', 'name': 'Beauty'},
    {'icon': '👗', 'name': 'Clothes'},
  ];

  final List<Map<String, String>> _incomeCategories = [
    {'icon': '💰', 'name': 'Salary'},
    {'icon': '🎁', 'name': 'Bonus'},
    {'icon': '📈', 'name': 'Stock'},
    {'icon': '🏦', 'name': 'Deposit'},
    {'icon': '💸', 'name': 'Interest'},
  ];

  void _addCustomCategory(bool isExpenseCategory) {
    TextEditingController categoryController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Custom Category"),
        content: TextField(
          controller: categoryController,
          decoration: InputDecoration(hintText: "Enter category name"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (categoryController.text.isNotEmpty) {
                setState(() {
                  (isExpenseCategory ? _expenseCategories : _incomeCategories)
                      .add({'icon': '🆕', 'name': categoryController.text});
                });
              }
              Navigator.of(context).pop();
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = isExpense ? _expenseCategories : _incomeCategories;

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Category',
          style: TextStyle(
            color: Color(0xFF9DB2CE), // Set the title color
          ),
        ),
        backgroundColor: Colors.white, // Replace with custom color

        leading: BackButton(),
      ),
      body: Column(
        children: [
          // Expense/Income Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => setState(() => isExpense = true),
                child: Text('Expense'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isExpense ? Color(0xFF85C1E5) : Colors.grey,
                  foregroundColor: Colors.white,
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => setState(() => isExpense = false),
                child: Text('Income'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: !isExpense ? Color(0xFF85C1E5) : Colors.grey,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          // Categories Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
              itemCount: categories.length + 1, // Add 1 for the "Add" button
              itemBuilder: (context, index) {
                if (index == categories.length) {
                  // Add Custom Category Button
                  return GestureDetector(
                    onTap: () => _addCustomCategory(isExpense),
                    child: Card(
                      color: Colors.green[100], // Custom color
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 30, color: Colors.green),
                            SizedBox(height: 5),
                            Text(
                              'Add',
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionDetailPage(
                          category: categories[index]['name']!,
                          isExpense: isExpense,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: Color(0xFF85C1E5), // Custom background color
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(categories[index]['icon']!,
                            style: TextStyle(fontSize: 24)),
                        SizedBox(height: 5),
                        Text(categories[index]['name']!),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
