import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'dart:convert';
import 'extracted_text_screen.dart';
import 'package:image/image.dart' as img; // Import the image package

class ImagePreviewScreen extends StatefulWidget {
  final File image;

  const ImagePreviewScreen({super.key, required this.image});

  @override
  _ImagePreviewScreenState createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  // Define app's color palette based on Dashboard/AnalyzePage
  static const Color primaryColor = Color(0xFF254e7a);     // Primary blue
  static const Color accentColor = Color(0xFF85c1e5);      // Light blue accent
  static const Color lightBgColor = Color(0xFFEBF1FD);     // Light background
  static const Color whiteColor = Colors.white;            // White background
  
  bool _isLoading = false;
  String _errorMessage = '';

  // Function to compress, convert to monochrome, and upload the image
  Future<void> uploadImage(File imageFile) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      // Load the image file
      img.Image? image = img.decodeImage(imageFile.readAsBytesSync());

      if (image != null) {
        // Convert the image to grayscale (monochrome)
        image = img.grayscale(image);

        // Compress the image (quality between 0-100)
        List<int> compressedImage =
            img.encodeJpg(image, quality: 80); // Adjust the quality as needed

        // Create a temporary file with the compressed image
        File compressedFile = File('${imageFile.path}_compressed_monochrome.jpg')
          ..writeAsBytesSync(compressedImage);

        var uri = Uri.parse("http://192.168.110.53:3000/upload");

        var request = http.MultipartRequest("POST", uri);

        request.files.add(await http.MultipartFile.fromPath(
          'image',
          compressedFile.path,
          contentType: MediaType.parse(
              lookupMimeType(compressedFile.path) ?? "image/jpeg"),
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
            category = extractedData['categorizedItems'][0]
                    ['predicted_category'] ??
                "Unknown";
          }

          print(
              "Total Amount: $totalAmount, Category: $category"); // Debugging Line

          // Navigate to ExtractedTextScreen with extracted details
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExtractedTextScreen(
                totalAmount: totalAmount,
                //billDate: billDate,
                categorizedItems: List<Map<String, dynamic>>.from(
                    extractedData['categorizedItems']),
              ),
            ),
          );
        } else {
          print("Failed to upload image. Status Code: ${response.statusCode}");
          setState(() {
            _errorMessage = "Error: Could not extract text. Please try again.";
          });
        }
      } else {
        print("Failed to decode image.");
        setState(() {
          _errorMessage = "Error: Could not process image. Please try again.";
        });
      }
    } catch (e) {
      print("Exception occurred: $e");
      setState(() {
        _errorMessage = "An unexpected error occurred. Please try again.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBgColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Receipt Preview",
          style: TextStyle(
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: whiteColor),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Header
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.receipt_long, color: whiteColor),
                            SizedBox(width: 8),
                            Text(
                              "Receipt Scanner",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      
                      // Image Preview
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                widget.image,
                                height: 450,
                                width: double.infinity,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "Our system will extract details from your receipt including the total amount and item categories.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: primaryColor.withOpacity(0.7),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 20),
                      
                      // Error message if any
                      if (_errorMessage.isNotEmpty)
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: Colors.red),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _errorMessage,
                                  style: TextStyle(color: Colors.red[700]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              
              // Upload Button at the bottom
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () => uploadImage(widget.image),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: whiteColor,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                  ),
                  child: _isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: whiteColor,
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 15),
                            Text(
                              "Processing...",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload_file),
                            SizedBox(width: 10),
                            Text(
                              "Process Receipt",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}