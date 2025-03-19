import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'dart:convert';
import 'extracted_text_screen.dart';
import 'package:image/image.dart' as img;  // Import the image package

class ImagePreviewScreen extends StatefulWidget {
  final File image;

  const ImagePreviewScreen({super.key, required this.image});

  @override
  _ImagePreviewScreenState createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  // Function to compress, convert to monochrome, and upload the image
  Future<void> uploadImage(File imageFile) async {
    // Load the image file
    img.Image? image = img.decodeImage(imageFile.readAsBytesSync());

    if (image != null) {
      // Convert the image to grayscale (monochrome)
      image = img.grayscale(image);

      // Compress the image (quality between 0-100)
      List<int> compressedImage = img.encodeJpg(image, quality: 80);  // Adjust the quality as needed

      // Create a temporary file with the compressed image
      File compressedFile = File('${imageFile.path}_compressed_monochrome.jpg')
        ..writeAsBytesSync(compressedImage);

      var uri = Uri.parse("http://192.168.127.53:3000/upload");

      var request = http.MultipartRequest("POST", uri);

      request.files.add(await http.MultipartFile.fromPath(
        'image',
        compressedFile.path,
        contentType: MediaType.parse(lookupMimeType(compressedFile.path) ?? "image/jpeg"),
      ));

      var response = await request.send();

      if (response.statusCode == 200) {
        print("Image uploaded successfully!");
        final responseData = await response.stream.bytesToString();
        print("Response Data: $responseData"); // Debugging Line
        final extractedData = json.decode(responseData);

        String totalAmount = extractedData['totalAmount'].toString();
        //String billDate = extractedData['billDate'].toString();

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
              //billDate: billDate,
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
    } else {
      print("Failed to decode image.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: Could not process image.")),
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
      body: SingleChildScrollView(  // Wrap the body in a SingleChildScrollView
        child: Column(
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
      ),
    );
  }
}
