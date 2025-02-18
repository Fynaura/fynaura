import 'package:flutter/material.dart';
import 'package:fynaura/transaction_category_page.dart';

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
            onPressed: () {
              // Add transaction logic (e.g., save data)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Transaction Added Successfully")),
              );
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
            // Show "Set Reminder" only for expenses
            if (isExpense) buildModernOptionTile("Set Reminder", Icons.alarm, reminder ? "Reminder Set" : "Set Reminder", context, false),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildCameraGalleryButton("Camera", Icons.camera_alt, Color(0xFF85C1E5)),
                buildCameraGalleryButton("Gallery", Icons.photo, Color(0xFF85C1E5)),
              ],
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
          } else if (title == "Set Reminder") {
            final date = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              setState(() {
                selectedDate = date;
                reminder = true;
              });
            }
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
