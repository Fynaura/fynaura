import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'transaction_category_page.dart';

class TransactionDetailsPage extends StatefulWidget {
  @override
  _TransactionDetailsPageState createState() => _TransactionDetailsPageState();
}

class _TransactionDetailsPageState extends State<TransactionDetailsPage> {
  bool isExpense = true;
  String selectedCategory = "Select Category";
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  bool reminder = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void addTransaction() {
    if (amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please enter an amount"),
      ));
      return;
    }
    if (selectedCategory == "Select Category") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please select a category"),
      ));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Transaction Added Successfully'),
    ));
    resetFields();
  }

  void resetFields() {
    amountController.clear();
    descriptionController.clear();
    selectedCategory = "Select Category";
    reminder = false;
    selectedDate = DateTime.now();
  }

  void pickImage(ImageSource source) async {
    final pickedImage = await _picker.pickImage(source: source);
    // Process picked image here (e.g., upload or store)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction', style: TextStyle(color: Color(0xFF9DB2CE))),
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: Colors.blue),
            onPressed: addTransaction,
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
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF85C1E5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: buildModernAmountField(),
              ),
            ),
            SizedBox(height: 10),
            buildModernOptionTile("Category", Icons.toc, selectedCategory, context, true),
            buildModernDescriptionField(),
            if (isExpense) buildModernOptionTile(
              "Set Reminder",
              Icons.alarm,
              reminder ? DateFormat('MMMM d, y').format(selectedDate) : "Set Reminder",
              context,
              false,
            ),
            SizedBox(height: 20),
            buildCameraGalleryButtons(),
          ],
        ),
      ),
    );
  }

  Widget buildToggleButton(String text, bool selected) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isExpense = text == "Expense";
          selectedCategory = "Select Category";
        });
      },
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
      ),
    );
  }

  Widget buildModernOptionTile(String title, IconData icon, String hint, BuildContext context, bool isCategory) {
    return Container(
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
              setState(() => selectedCategory = result as String);
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
            } else {
              setState(() {
                reminder = false;
              });
            }
          }
        },
      ),
    );
  }

  Widget buildCameraGalleryButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () => pickImage(ImageSource.camera),
          icon: Icon(Icons.camera_alt, color: Colors.white),
          label: Text("Camera"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF85C1E5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => pickImage(ImageSource.gallery),
          icon: Icon(Icons.photo, color: Colors.white),
          label: Text("Gallery"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF85C1E5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}