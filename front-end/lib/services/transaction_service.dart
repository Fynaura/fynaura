import 'dart:convert';
import 'package:http/http.dart' as http;

class TransactionService {
  final String baseUrl = "http://192.168.127.53:3000/transaction"; // Change to your actual backend URL

  Future<void> createTransaction({
    required String type,
    required String category,
    required double amount,
    String? description,
    required DateTime date,
    bool reminder = false, // Default to false
    DateTime? reminderDate, // Only for expenses
    required String? uid,
  }) async {
    final url = Uri.parse(baseUrl);
    
    // Build request body dynamically
    final Map<String, dynamic> body = {
      "type": type,
      "category": category,
      "amount": amount,
      "description": description,
      "date": date.toIso8601String(),
      "userId": uid,
    };

    // Only add reminder fields if it's an expense
    if (type == "expense") {
      body["reminder"] = reminder;
      if (reminder && reminderDate != null) {
        body["reminderDate"] = reminderDate.toIso8601String();
      }
    }

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      print("Transaction added successfully");
    } else {
      print("Error: ${response.body}");
    }
  }
}
