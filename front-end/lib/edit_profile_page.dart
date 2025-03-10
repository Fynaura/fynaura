import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String _name = "John Doe";
  int _age = 25;
  String _location = "California";
  String _profilePicture = "images/fynaura.png"; // Default profile picture

  // Method to select avatar
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
                  setState(() {
                    _profilePicture = "images/fynaura.png"; // Default Avatar
                  });
                  Navigator.pop(context);
                },
                child: CircleAvatar(backgroundImage: AssetImage("images/fynaura.png"), radius: 30),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _profilePicture = "images/fynaura-icon.png"; // Alternate Avatar
                  });
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
      appBar: AppBar(
        title: Text("Edit Profile"),
        backgroundColor: Color(0xFF85C1E5),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Save profile data (this can be connected to a backend or shared preferences)
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Profile Picture Section
              GestureDetector(
                onTap: _selectAvatar,
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage(_profilePicture),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: "Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your name";
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              TextFormField(
                initialValue: _age.toString(),
                decoration: InputDecoration(labelText: "Age"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your age";
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _age = int.parse(value);
                  });
                },
              ),
              TextFormField(
                initialValue: _location,
                decoration: InputDecoration(labelText: "Location"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your location";
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _location = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Save the data and navigate back
                    Navigator.pop(context);
                  }
                },
                child: Text("Save Profile"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF85C1E5), // Custom button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16), // Custom padding
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Custom text style
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
