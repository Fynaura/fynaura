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

  void _saveProfile() {
    Map<String, dynamic> updatedData = {
      'name': _nameController.text,
      'age': int.parse(_ageController.text),
      'currency': _currencyController.text,
      'bio': _bioController.text,
    };

    Navigator.pop(context, updatedData);
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
            // Name input
            _buildTextField(_nameController, "Name"),
            SizedBox(height: 20),
            // Age input
            _buildTextField(_ageController, "Age", inputType: TextInputType.number),
            SizedBox(height: 20),
            // Currency input
            _buildTextField(_currencyController, "Currency"),
            SizedBox(height: 20),
            // Bio input
            _buildTextField(_bioController, "Bio", maxLines: 4),
            SizedBox(height: 30),
            // Save button
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

  // Custom widget for text fields
  Widget _buildTextField(TextEditingController controller, String label, {TextInputType inputType = TextInputType.text, int maxLines = 1}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: inputType,
      maxLines: maxLines,
    );
  }
}
