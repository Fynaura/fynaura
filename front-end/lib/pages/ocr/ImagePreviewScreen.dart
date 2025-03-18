import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'dart:convert';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'extracted_text_screen.dart';

class ImagePreviewScreen extends StatefulWidget {
  final File image;

  const ImagePreviewScreen({super.key, required this.image});

  @override
  _ImagePreviewScreenState createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {

  // Function to compress image before uploading
  Future<XFile?> compressImage(File file) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      '${file.path}_compressed.jpg',
      quality: 60,  // Lower quality for faster processing
    );
    return result; // This is now returning a File, not XFile
  }

  // Function to upload image and get extracted text
  Future<void> uploadImage(File imageFile) async {
    // Compress image
    XFile? compressedFile = await compressImage(imageFile);
    if (compressedFile == null) return; // Prevent sending null file

    var uri = Uri.parse("http://10.31.9.147:3000/upload");

    var request = http.MultipartRequest("POST", uri);

    // Add the compressed file to the request
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      compressedFile.path,  // Send compressed file
      contentType: MediaType.parse(lookupMimeType(compressedFile.path) ?? "image/jpeg"),
    ));

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Image uploaded successfully!");
      final responseData = await response.stream.bytesToString();
      print("Response Data: $responseData"); // Debugging Line
      final extractedData = json.decode(responseData);

      String totalAmount = extractedData['totalAmount'].toString();

      // Extracting category (First item in categorizedItems list)
      String category = "Unknown"; // Default value
      if (extractedData.containsKey('categorizedItems') &&
          extractedData['categorizedItems'] is List &&
          extractedData['categorizedItems'].isNotEmpty) {
        category = extractedData['categorizedItems'][0]['predicted_category'] ?? "Unknown";
      }

      print("Total Amount: $totalAmount, Category: $category"); // Debugging Line

      // Navigate to ExtractedTextScreen with extracted details
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExtractedTextScreen(
            totalAmount: totalAmount,
            categorizedItems: List<Map<String, dynamic>>.from(extractedData['categorizedItems']),
          ),
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
