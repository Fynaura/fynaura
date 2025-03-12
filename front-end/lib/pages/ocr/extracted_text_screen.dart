import 'package:flutter/material.dart';

class ExtractedTextScreen extends StatelessWidget {
  //final String text;
  final String totalAmount;
  final String billDate;

  const ExtractedTextScreen({super.key, required this.totalAmount,required this.billDate}); //required this.text,


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.blue[300],
        backgroundColor: Colors.grey[200],
        title: const Text("Extracted Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),

                  children: [
                    TextSpan(text: "Total Amount: "),
                    TextSpan(
                      text: totalAmount,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
              ),


              RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color:Colors.green),
                    children: [
                      TextSpan(text: "Date: "),
                      TextSpan(
                        text: billDate,
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.green),
                      )
                    ]
                  )
              )

            ],
          ),
        ),
      ),
    );
  }
}

