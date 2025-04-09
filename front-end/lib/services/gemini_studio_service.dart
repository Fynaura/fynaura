// lib/services/gemini_studio_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiStudioService {
  // Get this API key from https://makersuite.google.com/app/apikey
  static const String apiKey = "AIzaSyB0NFiTyn9r-AO2cJU0ocIzx-k52k8Xs_E"; // Replace with your actual key
  static const String endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro-latest:generateContent";

  Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse('$endpoint?key=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text": message
                }
              ]
            }
          ],
          "generationConfig": {
            "temperature": 0.7,
            "topK": 40,
            "topP": 0.95,
            "maxOutputTokens": 800,
          }
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        // AI Studio API response format
        if (jsonResponse['candidates'] != null &&
            jsonResponse['candidates'].isNotEmpty &&
            jsonResponse['candidates'][0]['content'] != null &&
            jsonResponse['candidates'][0]['content']['parts'] != null &&
            jsonResponse['candidates'][0]['content']['parts'].isNotEmpty) {

          return jsonResponse['candidates'][0]['content']['parts'][0]['text'];
        } else {
          print('Unexpected response format: $jsonResponse');
          return "I couldn't process that request properly. Please try again.";
        }
      } else {
        print('Failed to get response: ${response.statusCode}');
        print('Response body: ${response.body}');
        return "Sorry, I couldn't connect to my brain right now. Please try again later.";
      }
    } catch (e) {
      print('Exception occurred: $e');
      return "Sorry, an unexpected error occurred. Please try again.";
    }
  }
}