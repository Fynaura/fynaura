import 'package:flutter/material.dart';
import 'package:expencetracker/components/top_bar.dart';

class AnalyzePage extends StatefulWidget {
  const AnalyzePage({super.key});

  @override
  State<AnalyzePage> createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        toolbarHeight: 100,
        centerTitle: true,
        title: TopBar(),
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [],
        ),
      ),
    );
  }
}
// Inside Column in Scaffold body

Padding(
  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
  child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: const Color.fromARGB(255, 221, 221, 221),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Container(
            width: MediaQuery.of(context).size.width / 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            padding: EdgeInsets.symmetric(vertical: 7),
            child: Center(
                child: Text(
              "Today",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            )),
          ),
        ),
        // Other buttons (This Week, This Month)
      ],
    ),
  ),
),
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 15.0),
  child: Text(
    "Recent Transactions",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
  ),
),
// ListView.builder for transactions
