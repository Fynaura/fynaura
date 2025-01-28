import 'package:flutter/material.dart';
import 'transaction_category_page.dart'; // Import the category page

class TemporaryHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Temporary Home Page',
            style: TextStyle(
              color: Color(0xFF9DB2CE), // Set the title color
            ),
          ),
        ),
        backgroundColor: Color(0xFFEBEBEB),
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
            backgroundColor: Color(0xFF85C1E5),
          ),
        ),
      ),
    );
  }
}
