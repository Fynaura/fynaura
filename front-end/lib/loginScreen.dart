

import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  
  @override
  Widget build(BuildContext) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            children: [
              Image.asset('images/fynaura.png')
            ],
          )),
    );
  }
}