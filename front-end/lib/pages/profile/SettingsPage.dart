import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSettingOption(Icons.notifications, "Notifications", () {
              // Handle notifications settings
            }),
            _buildSettingOption(Icons.security, "Security", () {
              // Handle security settings
            }),
            _buildSettingOption(Icons.account_circle, "Account", () {
              // Handle account settings
            }),
            _buildSettingOption(Icons.help, "Help", () {
              // Handle help settings
            }),
          ],
        ),
      ),
    );
  }

  // Helper method to build setting options
  Widget _buildSettingOption(IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(text, style: TextStyle(fontSize: 18)),
      onTap: onTap,
    );
  }
}
