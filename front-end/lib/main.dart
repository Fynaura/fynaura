import 'package:flutter/material.dart';

import 'dart:async';
import 'package:fynaura/pages/log-in/mainLogin.dart';
import 'package:fynaura/pages/home/DashboardScreen.dart';


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
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.edit, color: Color(0xFF85C1E5)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfilePage()), // Correctly navigate to the EditProfilePage
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
            ),
            ListTile(
              leading: Icon(Icons.flag, color: Color(0xFF85C1E5)),
              title: Text("Goal"),
              subtitle: Text("Track and complete your goals"),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GoalPage(auraPoints: 1000, onUpdatePoints: (points) {})), // Pass data to GoalPage
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.lock, color: Color(0xFF85C1E5)),
              title: Text("Face ID / Touch ID"),
              subtitle: Text("Manage your device security"),
              trailing: Switch(value: false, onChanged: (value) {}),
            ),
            ListTile(
              leading: Icon(Icons.security, color: Color(0xFF85C1E5)),
              title: Text("Two-Factor Authentication"),
              subtitle: Text("Further secure your account"),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("Log out", style: TextStyle(color: Colors.red)),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

