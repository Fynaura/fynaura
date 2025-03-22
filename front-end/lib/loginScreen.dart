import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final Function onLoginSuccess; // Callback function passed from the main widget

  LoginScreen({required this.onLoginSuccess});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Fake login validation
  bool _isLoggedIn = false;

  void _login() {
    if (_emailController.text == "test@example.com" && _passwordController.text == "password123") {
      setState(() {
        _isLoggedIn = true;
      });

      // Call the callback function passed from main to show the notification
      widget.onLoginSuccess();
    } else {
      setState(() {
        _isLoggedIn = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid credentials')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
