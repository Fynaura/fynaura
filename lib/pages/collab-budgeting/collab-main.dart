import 'package:flutter/material.dart';
import 'package:fynaura/widgets/CustomButton.dart';
import 'package:fynaura/widgets/backBtn.dart';
import 'package:fynaura/widgets/customInput.dart';

class CollabMain extends StatefulWidget {
  const CollabMain({super.key});

  @override
  State<CollabMain> createState() => CollabMainstate();
}

class CollabMainstate extends State<CollabMain> {
  List<Map<String, String>> createdBudgets = []; // Store created budgets

  void _addBudget(String name, String amount) {
    setState(() {
      createdBudgets.add({"name": name, "amount": amount});
    });
  }

  void _showCreateBudgetPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomPopup(onBudgetCreated: _addBudget);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Budget Plan",
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Color(0xFF85C1E5),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Pinned Plans",
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF85C1E5),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "No plans pinned yet",
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFFDADADA),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Created Plans",
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF85C1E5),
                ),
              ),
              const SizedBox(height: 20),

              // List of Created Budgets
              Column(
                children: createdBudgets.map((budget) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            budget["name"]!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          LinearProgressIndicator(
                            value: 1.0, // Full progress initially
                            backgroundColor: Color(0xFF85C1E5),
                            color: Color(0xFF85C1E5),
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start, // Align items to the top
                            children: [
                              Text(
                                "LKR ${budget["amount"]}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Spacer(),
                              CircleAvatar(
                                radius: 20,
                                backgroundImage:  AssetImage("images/user.png"),
                              ),
                            ],
                          )


                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Create Budget Button
              CustomButton(
                text: "Create a New Budget",
                backgroundColor: const Color(0xFF85C1E5),
                textColor: Colors.white,
                onPressed: () {
                  _showCreateBudgetPopup(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Popup Widget
class CustomPopup extends StatefulWidget {
  final Function(String, String) onBudgetCreated;

  CustomPopup({required this.onBudgetCreated});

  @override
  _CustomPopupState createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Create a New Budget",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text("Enter the following details!"),
            const SizedBox(height: 20),
            Text("Budget Name"),
            CustomInputField(
              hintText: "Christmas",
              controller: _nameController,
            ),
            const SizedBox(height: 20),
            Text("Estimated Total Budget"),
            CustomInputField(
              hintText: "1000",
              controller: _amountController,
            ),
            const SizedBox(height: 30),
            CustomButton(
              text: "Create Budget",
              backgroundColor: const Color(0xFF1E232C),
              textColor: Colors.white,
              onPressed: () {
                if (_nameController.text.isNotEmpty &&
                    _amountController.text.isNotEmpty) {
                  widget.onBudgetCreated(
                    _nameController.text,
                    _amountController.text,
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
