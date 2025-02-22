// new_profile_page.dart
import 'package:flutter/material.dart';

class NewProfilePage extends StatefulWidget {
  @override
  _NewProfilePageState createState() => _NewProfilePageState();
}

class _NewProfilePageState extends State<NewProfilePage> {
  int auraPoints = 1000; // Default Aura points

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
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("images/fynaura.png"),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Aura", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("$auraPoints+ Aura", style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Spacer(),
              ],
            ),
            Divider(),
            DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: 'Tips'),
                      Tab(text: 'Edit'),
                      Tab(text: 'Bio'),
                    ],
                    labelColor: Color(0xFF85C1E5),
                    indicatorColor: Color(0xFF85C1E5),
                  ),
                  Container(
                    height: 300.0, // Height of the content area
                    child: TabBarView(
                      children: [
                        // Tips Tab
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Aura is the point that you're getting from using our app",
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(height: 10),
                              Text("* Complete your goals", style: TextStyle(fontSize: 14)),
                              Text("* Invite your friends", style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                        // Edit Tab
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                  decoration: InputDecoration(
                                      labelText: "First Name", filled: true, fillColor: Colors.white, border: OutlineInputBorder())),
                              SizedBox(height: 10),
                              TextField(
                                  decoration: InputDecoration(
                                      labelText: "Last Name", filled: true, fillColor: Colors.white, border: OutlineInputBorder())),
                              SizedBox(height: 10),
                              TextField(
                                  decoration: InputDecoration(
                                      labelText: "Phone Number", filled: true, fillColor: Colors.white, border: OutlineInputBorder())),
                              SizedBox(height: 10),
                              DropdownButtonFormField(
                                decoration: InputDecoration(
                                    labelText: "Gender", filled: true, fillColor: Colors.white, border: OutlineInputBorder()),
                                items: ["Male", "Female"].map((String gender) {
                                  return DropdownMenuItem(value: gender, child: Text(gender));
                                }).toList(),
                                onChanged: (value) {},
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF85C1E5),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Update Profile", style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                        // Bio Tab
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Aura is the point that you're getting from using our app.",
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(height: 10),
                              Text("* Complete your goals", style: TextStyle(fontSize: 14)),
                              Text("* Invite your friends", style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
