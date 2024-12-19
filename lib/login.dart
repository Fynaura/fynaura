import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'ImagePreviewScreen.dart';

class OcrScreen extends StatefulWidget {
  const OcrScreen({super.key});

  @override
  State<OcrScreen> createState() => _OcrScreenState();
}

class _OcrScreenState extends State<OcrScreen> {
  File? _image;

  Future<void> _pickImageFromCamera() async{
    final pickedFile=await ImagePicker().pickImage(source: ImageSource.camera);
    if(pickedFile!=null){
      setState(() {
        _image=File(pickedFile.path);

      });
      Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => ImagePreviewScreen(image: _image!),
          ),
      );
    }
  }

  Future<void> _pickImageFromGallery() async{
    final pickedFile=await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedFile!=null){
      setState(() {
        _image=File(pickedFile.path);
      });
      Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => ImagePreviewScreen(image: _image!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          // Bottom-aligned button container
          // Positioned Row
          Positioned(
            top: 800, // Center vertically
            left: 75,// Center horizontally

            child: Row(
              children: [
                // Camera Button
                ElevatedButton.icon(
                  onPressed:_pickImageFromCamera,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  label: const Text(
                    "Camera",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(width: 20), // Space between buttons
                // Gallery Button
                ElevatedButton.icon(
                  onPressed: _pickImageFromGallery,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.image, color: Colors.white),
                  label: const Text(
                    "Gallery",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


