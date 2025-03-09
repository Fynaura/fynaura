import 'package:flutter/material.dart';

class TabPage extends StatelessWidget {
  final String title;

  const TabPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
       
      ),
    );
  }
}

class Page extends StatelessWidget {
  final String title;

  const Page({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page: $title')),
      body: Center(child: Text(title)),
    );
  }
}