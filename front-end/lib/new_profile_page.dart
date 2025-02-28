import 'package:flutter/material.dart';
import 'MyAccountPage.dart'; // Import MyAccountPage

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String selectedAvatar = "images/fynaura.png"; // Default avatar
  int auraPoints = 1000; // Sample aura points

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Redeem", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios, size: 16),
                  onPressed: () {
                    // Implement Redeem section logic here
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
            Divider(),
            // Add navigation to the My Account page here
            ListTile(
              leading: Icon(Icons.person, color: Color(0xFF85C1E5)),
              title: Text("My Account"),
              subtitle: Text("View your account details"),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to My Account page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyAccountPage()), // Navigate to MyAccountPage
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
