import 'package:flutter/material.dart';
import 'package:fynaura/widgets/CustomButton.dart';
import 'package:fynaura/widgets/backBtn.dart';

class BudgetDetails extends StatefulWidget {
  final String budgetName;
  final String budgetAmount;
  final String budgetDate;

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Center(
                //   child: Text(
                //     "Budget Plan",
                //     style: TextStyle(
                //       fontFamily: 'Urbanist',
                //       fontWeight: FontWeight.bold,
                //       fontSize: 30,
                //       color: Color(0xFF85C1E5),
                //     ),
                //   ),
                // ),

                Container(

                  width: 380,
                  height: 180,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1E1E1E), Color(0xFF2C3E50)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Budget For "+ widget.budgetName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Accumulated Balance",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        "LKR ${widget.budgetAmount}",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: Text(
                    widget.budgetDate,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              value: 0.1, // 10% remaining
                              strokeWidth: 5,
                              backgroundColor: Colors.white24,
                              valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF85C1E5)),
                            ),
                          ),
                          Text(
                            "10%",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 5),
                      Text(
                        "Remaining",
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Stack(
              children: [
                Container(
                  width: 380,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Color(0xFF26252A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 20,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage("images/user.png"),
                  ),
                ),
                Positioned(
                  left: 80,
                  top: 20,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage("images/user.png"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            const Text(
              "Recent Activity",
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w600,
                fontSize: 25,
                color: Color(0xFF26252A),
              ),

            ),
            const SizedBox(height: 15),
            Center(
              child: Text(
                "No activities yet",
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFFDADADA),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
