import 'package:flutter/material.dart';
import 'package:fynaura/widgets/CustomButton.dart';
import 'package:fynaura/widgets/backBtn.dart';
import 'package:fynaura/widgets/customInput.dart';

class BudgetDetails extends StatefulWidget {
  final String budgetName;
  final String budgetAmount;
  final String budgetDate;

  // Constructor to accept budget details
  const BudgetDetails({
    super.key,
    required this.budgetName,
    required this.budgetAmount,
    required this.budgetDate,
  });

  @override
  State<BudgetDetails> createState() => _BudgetDetailsState();
}

class _BudgetDetailsState extends State<BudgetDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
        // title: Text(widget.budgetName),
        // backgroundColor: const Color(0xFF85C1E5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Container(
          width: 350, // Adjust width as needed
          height: 180, // Adjust height as needed
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E1E1E), Color(0xFF2C3E50)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
        ),

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
            Text(
              "Budget Name: ${widget.budgetName}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Total Budget: LKR ${widget.budgetAmount}",
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Text(
              "More details about the budget will be displayed here...",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            Text(
              "Budget Date: ${widget.budgetDate}", 
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),

          ],
        ),
      ),
    );
  }
}
