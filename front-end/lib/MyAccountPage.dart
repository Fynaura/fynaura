import 'package:flutter/material.dart';

class MyAccountPage extends StatefulWidget {
  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  int auraPoints = 1000; // Default aura points
  String profilePicture = "images/fynaura.png"; // Default profile picture

  // Logic to handle redeem squares unlocking based on aura points
  List<bool> getUnlockStatus() {
    int unlockedSquares = auraPoints ~/ 1000;
    return List.generate(9, (index) => index < unlockedSquares);
  }

  @override
  Widget build(BuildContext context) {
    List<bool> unlockStatus = getUnlockStatus(); // Get unlock status for squares

    return Scaffold(
      appBar: AppBar(
        title: Text("My Account"),
        backgroundColor: Color(0xFF85C1E5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile picture
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(profilePicture),
            ),
            SizedBox(height: 16),
            // Aura points
            Text(
              "Aura Points: $auraPoints",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            // Redeem section
            Text(
              "Redeem Rewards",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.0,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Check if the reward is unlocked
                      if (unlockStatus[index]) {
                        // Add redemption logic here
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Redeemed Reward #${index + 1}!")),
                        );
                      } else {
                        // Show a message when trying to redeem a locked reward
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("You need more Aura points to redeem this reward!")),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: unlockStatus[index] ? Colors.green : Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.card_giftcard,  // Updated icon
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
