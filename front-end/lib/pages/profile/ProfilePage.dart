import 'package:flutter/material.dart';
import 'ProfileBioEditPage.dart'; // Import Bio Edit Page

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String selectedAvatar = "images/fynaura.png"; // Default avatar image path
  String userName = "Aura"; // Default user name
  int userAge = 25; // Default user age
  String userCurrency = "USD"; // Default currency
  String userBio = "Hello! I am Aura. Welcome to my profile."; // Default user bio

  // Navigate to the Bio Edit Page when the "Edit Bio" button is clicked
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
      // When coming back from the edit page, update the profile details
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture and Name
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // Avatar selection logic goes here
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
              ],
            ),
            SizedBox(height: 20),
            // User Info (Age, Currency, Bio)
            Text("Age: $userAge", style: TextStyle(fontSize: 18)),
            Text("Currency: $userCurrency", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text("Bio: $userBio", style: TextStyle(fontSize: 16)),
            SizedBox(height: 30),
            // Edit Profile Button
            ElevatedButton(
              onPressed: _navigateToEditProfile,
              child: Text("Edit Profile", style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.blue,
                textStyle: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
