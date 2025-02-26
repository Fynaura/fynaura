import 'package:flutter/material.dart';
import 'new_profile_page.dart';  // Import the new profile page
import 'GoalPage.dart';  // Import the Goal page
import 'edit_profile_page.dart';  // Import the EditProfilePage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF85C1E5),
        scaffoldBackgroundColor: Color(0xFFEBEBEB),
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.black)),
      ),
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String selectedAvatar = "images/fynaura.png"; // Default avatar
  int auraPoints = 1000; // Aura points initialized

  void _selectAvatar() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select Avatar"),
          content: Wrap(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() => selectedAvatar = "images/fynaura.png");
                  Navigator.pop(context);
                },
                child: CircleAvatar(backgroundImage: AssetImage("images/fynaura.png"), radius: 30),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  setState(() => selectedAvatar = "images/fynaura-icon.png");
                  Navigator.pop(context);
                },
                child: CircleAvatar(backgroundImage: AssetImage("images/fynaura-icon.png"), radius: 30),
              ),
            ],
          ),
        );
      },
    );
  }

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
                  onTap: _selectAvatar,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(selectedAvatar),
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Aura", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("@Itunuoluwa", style: TextStyle(color: Colors.grey)),
                    Text("$auraPoints+ Aura", style: TextStyle(fontSize: 16, color: Colors.green)),
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.edit, color: Color(0xFF85C1E5)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfilePage()), // Navigate to EditProfilePage
                    );
                  },
                )
              ],
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.person, color: Color(0xFF85C1E5)),
              title: Text("My Account"),
              subtitle: Text("Make changes to your account"),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewProfilePage(auraPoints: auraPoints)), // Navigate to NewProfilePage
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.flag, color: Color(0xFF85C1E5)),
              title: Text("Goal"),
              subtitle: Text("Track and complete your goals"),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GoalPage(auraPoints: auraPoints, onUpdatePoints: (newPoints) {
                    setState(() {
                      auraPoints = newPoints;
                    });
                  })),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
