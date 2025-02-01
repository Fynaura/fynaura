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
  void _showCreateBudgetPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomPopup();
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
class CustomPopup extends StatelessWidget {
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
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
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
            Text(
              "Enter the following details!",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            const Text(
              "Budget Name",
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: const Color(0xFF6A707C),
              ),
            ),
            const SizedBox(height: 5),

            CustomInputField(
              hintText: "Christmas",
              controller: TextEditingController(),
            ),
            const SizedBox(height: 30),

            CustomButton(
              text: "Create a New Budget",
              backgroundColor: const Color(0xFF1E232C),
              textColor: Colors.white,
              onPressed: () {
                // _showCreateBudgetPopup(context);
              },
            ),

          ],
        ),
      ),
    );
  }
}
