import 'package:flutter/material.dart';

class ProfileBioEditPage extends StatefulWidget {
  final String name;
  final int age;
  final String currency;
  final String bio;

  ProfileBioEditPage({
    required this.name,
    required this.age,
    required this.currency,
    required this.bio,
  });

  @override
  _ProfileBioEditPageState createState() => _ProfileBioEditPageState();
}

class _ProfileBioEditPageState extends State<ProfileBioEditPage> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _currencyController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _ageController = TextEditingController(text: widget.age.toString());
    _currencyController = TextEditingController(text: widget.currency);
    _bioController = TextEditingController(text: widget.bio);
  }

  // Save the changes and send the updated data back to ProfilePage
  void _saveProfile() {
    Map<String, dynamic> updatedData = {
      'name': _nameController.text,
      'age': int.parse(_ageController.text),
      'currency': _currencyController.text,
      'bio': _bioController.text,
    };

    Navigator.pop(context, updatedData); // Return updated data to ProfilePage
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _currencyController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Name Input
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 20),
            // Age Input
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Age'),
            ),
            SizedBox(height: 20),
            // Currency Input
            TextField(
              controller: _currencyController,
              decoration: InputDecoration(labelText: 'Currency'),
            ),
            SizedBox(height: 20),
            // Bio Input
            TextField(
              controller: _bioController,
              decoration: InputDecoration(labelText: 'Bio'),
              maxLines: 4,
            ),
            SizedBox(height: 30),
            // Save Button
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text("Save Changes", style: TextStyle(fontSize: 16)),
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
