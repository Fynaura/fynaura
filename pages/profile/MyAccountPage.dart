import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAccountPage extends StatefulWidget {
  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  int auraPoints = 1000; // Default aura points
  String profilePicture = "images/fynaura.png"; // Default profile picture

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load user data (e.g., aura points, profile picture) from shared preferences
  _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      auraPoints = prefs.getInt('auraPoints') ?? 1000; // Default 1000 points
      profilePicture = prefs.getString('profilePicture') ?? "images/fynaura.png"; // Default profile picture
    });
  }

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
            // Bio section
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 5),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Bio", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text("Name: John Doe"),
                  Text("Age: 25"),
                  Text("Location: California"),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Redeem section (empty for now)
            Text(
              "Redeem Rewards",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
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
                    if (unlockStatus[index]) {
                      // Add redemption logic here
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Redeemed Reward #${index + 1}!")),
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
          ],
        ),
      ),
    );
  }
}
