
// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class BudgetService {
//   final String baseUrl = "http://10.0.2.2:3000/"; // Change if deployed
//
//   Future<List<Map<String, dynamic>>> getBudgets() async {
//     final response = await http.get(Uri.parse(baseUrl));
//
//     if (response.statusCode == 200) {
//       List<dynamic> data = json.decode(response.body);
//       return data.cast<Map<String, dynamic>>();
//     } else {
//       throw Exception("Failed to load budgets");
//     }
//   }
//
//   Future<void> createBudget(String name, double amount, String date) async {
//     final response = await http.post(
//       Uri.parse(baseUrl),
//       headers: {"Content-Type": "application/json"},
//       body: json.encode({"name": name, "amount": amount, "date": date}),
//     );
//
//     if (response.statusCode != 201) {
//       throw Exception("Failed to create budget");
//     }
//   }
//
//   Future<void> deleteBudget(String id) async {
//     final response = await http.delete(Uri.parse("$baseUrl/$id"));
//
//     if (response.statusCode != 200) {
//       throw Exception("Failed to delete budget");
//     }
//   }
// // }



// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// // Budget Service class for API interactions
// class BudgetService {
//   final String baseUrl = "http://10.0.2.2:3000/collab-budgets"; // Consistent URL path
//
//   Future<List<Map<String, dynamic>>> getBudgets() async {
//     final response = await http.get(Uri.parse(baseUrl));
//
//     if (response.statusCode == 200) {
//       List<dynamic> data = json.decode(response.body);
//       return data.cast<Map<String, dynamic>>();
//     } else {
//       throw Exception("Failed to load budgets");
//     }
//   }
//
//   Future<void> createBudget(String name, double amount, String date) async {
//     final response = await http.post(
//       Uri.parse(baseUrl),
//       headers: {"Content-Type": "application/json"},
//       body: json.encode({"name": name, "amount": amount, "date": date}),
//     );
//
//     if (response.statusCode != 201) {
//       throw Exception("Failed to create budget");
//     }
//   }
//
//   Future<void> deleteBudget(String id) async {
//     final response = await http.delete(Uri.parse("$baseUrl/$id"));
//
//     if (response.statusCode != 200) {
//       throw Exception("Failed to delete budget");
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;

class BudgetService {
  final String baseUrl = "http://10.0.2.2:3000/collab-budgets"; // API base URL

  // Fetch all budgets
  Future<List<Map<String, dynamic>>> getBudgets() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Failed to load budgets");
    }
  }

  // Create a new budget (✅ Now includes userId)
  Future<void> createBudget(String name, double amount, String date, String userId) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "name": name,
        "amount": amount,
        "date": date,
        "userId": userId // ✅ Ensure userId is included
      }),
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to create budget");
    }
  }

  // Delete a budget
  Future<void> deleteBudget(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));

    if (response.statusCode != 200) {
      throw Exception("Failed to delete budget");
    }
  }
}
