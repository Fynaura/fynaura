import 'dart:io';
import 'package:flutter/material.dart';

class ImagePreviewScreen extends StatelessWidget {
  final File image;

  const ImagePreviewScreen({super.key, required this.image});

  Future<void> uploadImage(File imageFile) async {
    var uri = Uri.parse("http://10.0.2.2:3000/upload");

    var request = http.MultipartRequest("POST", uri);

    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
      contentType:  MediaType.parse(lookupMimeType(imageFile.path) ?? "image/jpeg"),
    ));

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Image uploaded successfully!");
      final responseData = await response.stream.bytesToString();
      print("Response from backend: $responseData");
    } else {
      print("Failed to upload image. Status Code: ${response.statusCode}");
    }
  }

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
