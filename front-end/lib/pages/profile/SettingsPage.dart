import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Settings", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Divider(),
            // Add settings options here
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text("Notifications"),
              onTap: () {
                // Implement notification settings
              },
            ),
            ListTile(
              leading: Icon(Icons.security),
              title: Text("Security"),
              onTap: () {
                // Implement security settings
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text("Account"),
              onTap: () {
                // Implement account settings
              },
            ),
            // More settings options as needed
          ],
        ),
      ),
    );
  }
}
