import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fynaura/pages/add-transactions/transaction_category_page.dart';
import 'package:fynaura/pages/ocr/ImageSelectionOption.dart';


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
  File? selectedImage; // Store selected image

  void _handleImageSelection(bool isCamera) async {
    File? image = isCamera
        ? await ImageSelectionOption.pickImageFromCamera()
        : await ImageSelectionOption.pickImageFromGallery();

    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction', style: TextStyle(color: Color(0xFF9DB2CE))),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.blue),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Transaction Added Successfully")),
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
            const SizedBox(height: 10),
            buildModernAmountField(),
            buildModernOptionTile("Category", Icons.toc, selectedCategory, context, true),
            buildModernDescriptionField(),
            if (isExpense) buildModernOptionTile("Set Reminder", Icons.alarm, reminder ? "Reminder Set" : "Set Reminder", context, false),

            const Spacer(),

            // Show selected image preview
            if (selectedImage != null)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: FileImage(selectedImage!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            // Image selection buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _handleImageSelection(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF85C1E5),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  label: const Text("Camera", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                ElevatedButton.icon(
                  onPressed: () => _handleImageSelection(false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.image, color: Colors.white),
                  label: const Text("Gallery", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
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
        backgroundColor: selected ? const Color(0xFF85C1E5) : Colors.grey,
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
      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
      decoration: const InputDecoration(
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 5),
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
        style: const TextStyle(fontSize: 18),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget buildModernOptionTile(String title, IconData icon, String hint, BuildContext context, bool isCategory) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey.shade700),
        title: Text(hint, style: const TextStyle(color: Colors.black54)),
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
}
