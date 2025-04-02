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
  String selectedCurrency = "USD"; // Default currency

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

  void _selectCurrency() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select Currency"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("USD - US Dollar"),
                onTap: () {
                  setState(() => selectedCurrency = "USD");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("EUR - Euro"),
                onTap: () {
                  setState(() => selectedCurrency = "EUR");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("GBP - British Pound"),
                onTap: () {
                  setState(() => selectedCurrency = "GBP");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("NGN - Nigerian Naira"),
                onTap: () {
                  setState(() => selectedCurrency = "NGN");
                  Navigator.pop(context);
                },
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
      backgroundColor: Color(0xFF254e7a), // Blue background color
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF254e7a),
        elevation: 0, // Modern look with no shadow
      ),
      body: SingleChildScrollView( // Add scroll view to prevent overflow
        child: Column(
          children: [
            // Top blue area
            Container(
              height: 80, // Reduced height
              color: Color(0xFF254e7a),
            ),

            // White card covering the rest of the screen
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24)
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Content
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 70, 16, 30),
                    child: Column(
                      children: [
                        // Profile Name
                        Text(
                          "@Itunuoluwa",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 16),

                        // Edit Profile button with text
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProfileEditorPage()),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.edit, color: Color(0xFF85C1E5), size: 20),
                                SizedBox(width: 8),
                                Text(
                                  "Edit Profile",
                                  style: TextStyle(
                                    color: Color(0xFF85C1E5),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 24),

                        // Goal section with updated modern design
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: Color(0xFFEBF1FD),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                            leading: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xFF254e7a).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.flag, color: Color(0xFF254e7a), size: 22),
                            ),
                            title: Text(
                              "Goal",
                              style: TextStyle(
                                color: Color(0xFF254e7a),
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              "Track and complete your goals",
                              style: TextStyle(
                                color: Color(0xFF254e7a).withOpacity(0.7),
                                fontSize: 13,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: Color(0xFF254e7a),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GoalPage(goals: goals),
                                ),
                              );
                            },
                          ),
                        ),

                        // Currency section with matching modern style
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: Color(0xFFEBF1FD),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                            leading: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xFF254e7a).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.currency_exchange, color: Color(0xFF254e7a), size: 22),
                            ),
                            title: Text(
                              "Currency",
                              style: TextStyle(
                                color: Color(0xFF254e7a),
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              "Currently using $selectedCurrency",
                              style: TextStyle(
                                color: Color(0xFF254e7a).withOpacity(0.7),
                                fontSize: 13,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: Color(0xFF254e7a),
                            ),
                            onTap: _selectCurrency,
                          ),
                        ),

                        // Add more sections as needed
                        SizedBox(height: 20),
                      ],
                    ),
                  ),

                  // Avatar positioned outside the card
                  Positioned(
                    top: -50,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: _selectAvatar,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                spreadRadius: 2,
                              )
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(selectedAvatar),
                          ),
                        ),
                      ),
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