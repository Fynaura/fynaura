import 'dart:io';
import 'package:flutter/material.dart';

class ImagePreviewScreen extends StatelessWidget {
  final File image;

  const ImagePreviewScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.blue[300],
        backgroundColor: Colors.grey[200],
        title: const Text("Image Preview"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                image,
                height: 650,
                width: 370,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: 100,
            child: ElevatedButton(
              onPressed: (){

              },
              style:ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                "Select",
                style: TextStyle(color: Colors.white,fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
