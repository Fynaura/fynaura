import 'package:flutter/material.dart';
import 'ProfileBioEditPage.dart';  // Import Bio Edit Page
import 'SettingsPage.dart'; // Import SettingsPage

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String selectedAvatar = "images/default_avatar.png"; // Default avatar
  String userName = "John Doe";
  int userAge = 30;
  String userCurrency = "USD";
  String userBio = "Financially aware and goal-driven individual.";

  double currentBalance = 3500.00; // Example financial data
  double savingsProgress = 80; // Percentage of savings goal achieved
  int recentTransactions = 50; // Example transactions count

  // Navigate to Edit Profile Page
  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileBioEditPage(
          name: userName,
          age: userAge,
          currency: userCurrency,
          bio: userBio,
        ),
      ),
    ).then((updatedData) {
      // When returning from the edit page, update profile data
      if (updatedData != null) {
        setState(() {
          userName = updatedData['name'];
          userAge = updatedData['age'];
          userCurrency = updatedData['currency'];
          userBio = updatedData['bio'];
        });
      }
    });
  }

  // Navigate to Settings Page
  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar and Name
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // Avatar selection logic here
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(selectedAvatar),
                  ),
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text("@username", style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: _navigateToEditProfile,
                )
              ],
            ),
            SizedBox(height: 20),
            Divider(),
            // Financial Information
            Text("Current Balance: \$${currentBalance.toStringAsFixed(2)}", style: TextStyle(fontSize: 18)),
            Text("Savings Progress: ${savingsProgress.toStringAsFixed(0)}%", style: TextStyle(fontSize: 18)),
            Text("Recent Transactions: $recentTransactions", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Divider(),
            // Bio Section
            Text("Bio", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(userBio, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            // Edit Profile and Settings buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _navigateToEditProfile,
                  child: Text("Edit Profile"),
                ),
                ElevatedButton(
                  onPressed: _navigateToSettings,
                  child: Text("Settings"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
