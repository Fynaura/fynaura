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
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
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
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 20),

            // Financial Data Section
            _buildFinancialSection(),

            SizedBox(height: 30),
            Divider(),

            // Bio Section
            _buildBioSection(),

            SizedBox(height: 20),

            // Action buttons for Edit Profile and Settings
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton("Edit Profile", _navigateToEditProfile),
                _buildActionButton("Settings", _navigateToSettings),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build financial data
  Widget _buildFinancialSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Current Balance: \$${currentBalance.toStringAsFixed(2)}", style: TextStyle(fontSize: 18)),
        Text("Savings Progress: ${savingsProgress.toStringAsFixed(0)}%", style: TextStyle(fontSize: 18)),
        Text("Recent Transactions: $recentTransactions", style: TextStyle(fontSize: 18)),
      ],
    );
  }

  // Widget to build bio section
  Widget _buildBioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Bio", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text(userBio, style: TextStyle(fontSize: 16)),
      ],
    );
  }

  // Widget to build action buttons
  Widget _buildActionButton(String text, Function onPressed) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      child: Text(text, style: TextStyle(fontSize: 16)),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        backgroundColor: Colors.blue,
        textStyle: TextStyle(color: Colors.white),
      ),
    );
  }
}
