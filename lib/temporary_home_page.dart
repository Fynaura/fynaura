import 'package:flutter/material.dart';
import 'transaction_category_page.dart'; // Import the category page

class TemporaryHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temporary Home Page'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TransactionCategoryPage()),
            );
          },
          child: Text('Go to Add Transaction'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            backgroundColor: Colors.blue,
          ),
        ),
      ),
    );
  }
}
