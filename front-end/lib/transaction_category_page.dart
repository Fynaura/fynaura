import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionCategoryPage extends StatefulWidget {
  final bool isExpense;
  TransactionCategoryPage({required this.isExpense});

  @override
  _TransactionCategoryPageState createState() => _TransactionCategoryPageState();
}

class _TransactionCategoryPageState extends State<TransactionCategoryPage> {
  List<Map<String, dynamic>> expenseCategories = [
    {"name": "Food", "icon": Icons.fastfood},
    {"name": "Shopping", "icon": Icons.shopping_cart},
    {"name": "Transport", "icon": Icons.directions_car},
    {"name": "Bills", "icon": Icons.receipt},
    {"name": "Clothes", "icon": Icons.checkroom},
    {"name": "Phone", "icon": Icons.phone_android},
    {"name": "Sport", "icon": Icons.sports_soccer},
    {"name": "Education", "icon": Icons.school},
    {"name": "Medical", "icon": Icons.local_hospital},
    {"name": "Beauty", "icon": Icons.brush},
    {"name": "Grocery", "icon": Icons.local_grocery_store},
    {"name": "Vehicle", "icon": Icons.directions_car},
  ];

  List<Map<String, dynamic>> incomeCategories = [
    {"name": "Salary", "icon": Icons.attach_money},
    {"name": "Bonus", "icon": Icons.card_giftcard},
    {"name": "Deposit", "icon": Icons.account_balance},
    {"name": "Stock", "icon": Icons.trending_up},
    {"name": "Crypto", "icon": Icons.currency_bitcoin},
  ];

  List<String> customCategories = [];

  @override
  void initState() {
    super.initState();
    _loadCustomCategories();
  }

  Future<void> _loadCustomCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customCategories = prefs.getStringList('customCategories') ?? [];
  }

  void _addCustomCategory() async {
    TextEditingController controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Custom Category", style: TextStyle(color: Color(0xFF9DB2CE))),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Enter category name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              controller.text = controller.text.trim();
              if (controller.text.isEmpty) {
                Navigator.pop(context);
                return;
              }
              if (customCategories.contains(controller.text)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Category already exists")),
                );
                return;
              }

              setState(() {
                customCategories.add(controller.text);
              });

              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setStringList('customCategories', customCategories);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Added ${controller.text}")),
              );
              Navigator.pop(context);
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categories = widget.isExpense
        ? [
      ...expenseCategories,
      ...customCategories.map((c) => {"name": c, "icon": Icons.category})
    ]
        : [
      ...incomeCategories,
      ...customCategories.map((c) => {"name": c, "icon": Icons.category})
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Select Category", style: TextStyle(color: Color(0xFF9DB2CE))),
        leading: BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: categories.length + 1,
          itemBuilder: (context, index) {
            if (index == categories.length) {
              return GestureDetector(
                onTap: _addCustomCategory,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.grey.shade700, size: 36),
                      SizedBox(height: 8),
                      Text("Add", style: TextStyle(color: Colors.grey.shade700)),
                    ],
                  ),
                ),
              );
            }

            final category = categories[index];
            return GestureDetector(
              onTap: () {
                Navigator.pop<String>(context, category["name"]);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF85C1E5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(category["icon"], color: Colors.white, size: 36),
                    SizedBox(height: 8),
                    Text(
                      category["name"],
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}