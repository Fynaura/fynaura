import 'package:flutter/material.dart';
import 'edit_profile_page.dart'; // Import EditProfilePage for navigation
import 'GoalPage.dart'; // Import GoalPage for navigation
import 'MyAccountPage.dart'; // Import MyAccountPage for navigation

class NewProfilePage extends StatefulWidget {
  @override
  _NewProfilePageState createState() => _NewProfilePageState();
}

class _NewProfilePageState extends State<NewProfilePage> {
  String selectedAvatar = "images/fynaura.png"; // Default avatar
  int auraPoints = 1000; // Sample aura points

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          // Edit Icon to navigate to EditProfilePage
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navigate to the EditProfilePage when edit icon is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage()), // Correct navigation to EditProfilePage
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // Add Avatar selection logic if needed
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(selectedAvatar),
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Aura", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("@Itunuoluwa", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Aura Points: $auraPoints",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Divider(),
            // Goal Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Goal", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios, size: 16),
                  onPressed: () {
                    // Navigate to GoalPage when Goal is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GoalPage(auraPoints: auraPoints, onUpdatePoints: (points) {})),
                    );
                  },
                ),
              ],
            ),
            Divider(),
            // My Account Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("My Account", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios, size: 16),
                  onPressed: () {
                    // Navigate to MyAccountPage when My Account is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyAccountPage()),
                    );
                  },
                ),
              ],
            ),
            Divider(),
            Text("Bio", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Name: John Doe"),
            Text("Age: 25"),
            Text("Location: California"),
          ],
        ),
      ),
    );
  }
}
