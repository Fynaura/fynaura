import 'dart:io';
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

  @override
  void initState() {
    super.initState();
    _pickImageFromCamera(); // Automatically open the camera when the screen loads
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ImagePreviewScreen(image: _image!),
        ),
      );
    } else {
      Navigator.pop(context); // Close the screen if no image is selected
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: CircularProgressIndicator(), // Show a loading indicator while picking an image
      ),
    );
  }
}
