// Temporary Home Page
import 'package:flutter/material.dart';
import 'transaction_detail_page.dart';

class TemporaryHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Temporary Home Page',
            style: TextStyle(color: Color(0xFF9DB2CE)),
          ),
        ),
        backgroundColor: Color(0xFFEBEBEB),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TransactionDetailPage()),
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