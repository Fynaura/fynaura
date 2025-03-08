import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'dart:convert';
import 'extracted_text_screen.dart';

class ImagePreviewScreen extends StatefulWidget {
  final File image;

  const ImagePreviewScreen({super.key, required this.image});

  @override
  _ImagePreviewScreenState createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {

  // Function to upload image and get extracted text
  Future<void> uploadImage(File imageFile) async {
    var uri = Uri.parse("localhost:3000/upload");
    // var uri = Uri.parse("http://10.31.9.147:3000/upload");
    //final String apiUrl = "http://192.168.8.172:3000/upload"; , "http://10.0.2.2:3000/upload" ,"http://10.31.9.147:3000/upload"

    var request = http.MultipartRequest("POST", uri);

    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
      contentType: MediaType.parse(lookupMimeType(imageFile.path) ?? "image/jpeg"),
    ));

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Image uploaded successfully!");
      final responseData = await response.stream.bytesToString();
      final extractedData = json.decode(responseData);

      String extractedText = extractedData['extractedText'].toString();// Get extracted text
      String totalAmount = extractedData['totalAmount'].toString(); // Get total amount

      // Navigate to ExtractedTextScreen with the extracted text
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context)=>ExtractedTextScreen(text: extractedText,totalAmount:totalAmount),
          ),
      );
    } else {
      print("Failed to upload image. Status Code: ${response.statusCode}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: Could not extract text.")),
      );
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
                widget.image,
                height: 650,
                width: 370,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Upload Button
          SizedBox(
            width: 150,
            child: ElevatedButton(
              onPressed: () async {
                await uploadImage(widget.image);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                "Upload",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}