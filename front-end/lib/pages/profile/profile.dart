import 'package:flutter/material.dart';
import 'package:fynaura/pages/goal-oriented-saving/Goalpage.dart';

import 'package:fynaura/pages/profile/edit_profile_page.dart';

import '../goal-oriented-saving/model/Goal.dart';



class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String selectedAvatar = "images/fynaura.png"; // Default avatar
  int auraPoints = 1000; // Example points
  List<Goal> goals = []; // Example empty list of goals

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

  void updateAuraPoints(int points) {
    setState(() {
      auraPoints += points;
    });
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
                      MaterialPageRoute(builder: (context) => ProfileEditorPage()),
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
                // ✅ Navigate to GoalPage and pass required parameters
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GoalPage(
                      goals: goals,
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
