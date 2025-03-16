

import 'dart:convert';
import 'package:http/http.dart' as http;

class BudgetService {
  final String baseUrl = "http://192.168.127.53:3000/collab-budgets"; // API base URL

  // Fetch all budgets
  // Future<List<Map<String, dynamic>>> getBudgets() async {
  //   final response = await http.get(Uri.parse(baseUrl));
  //
  //   if (response.statusCode == 200) {
  //     List<dynamic> data = json.decode(response.body);
  //     return data.cast<Map<String, dynamic>>();
  //   } else {
  //     throw Exception("Failed to load budgets");
  //   }
  // }

  // Future<List<Map<String, dynamic>>> getBudgets() async {
  //   final response = await http.get(Uri.parse(baseUrl));
  //
  //   if (response.statusCode == 200) {
  //     List<dynamic> data = json.decode(response.body);
  //
  //     // Transform data to ensure each budget has an "id" field
  //     return data.map<Map<String, dynamic>>((item) {
  //       var budget = Map<String, dynamic>.from(item);
  //       // Map MongoDB _id to id for Flutter
  //       if (budget.containsKey("_id") && !budget.containsKey("id")) {
  //         budget["id"] = budget["_id"];
  //       }
  //       return budget;
  //     }).toList();
  //   } else {
  //     throw Exception("Failed to load budgets");
  //   }
  // }

  Future<List<Map<String, dynamic>>> getBudgets() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      // Transform data to ensure each budget has an "id" field
      return data.map<Map<String, dynamic>>((item) {
        var budget = Map<String, dynamic>.from(item);
        // Map MongoDB _id to id for Flutter
        if (budget.containsKey("_id")) {
          budget["id"] = budget["_id"];
        }
        return budget;
      }).toList();
    } else {
      throw Exception("Failed to load budgets");
    }
  }

  // Create a new budget
  Future<void> createBudget(String name, double amount, String date, String userId) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "name": name,
        "amount": amount,
        "date": date,
        "userId": userId
      }),
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to create budget");
    }
  }

  // Delete a budget
  // Future<void> deleteBudget(String id) async {
  //   final response = await http.delete(Uri.parse("$baseUrl/$id"));
  //
  //   if (response.statusCode != 200) {
  //     throw Exception("Failed to delete budget");
  //   }
  // }

  Future<void> deleteBudget(String id) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/$id"));

      if (response.statusCode != 200) {
        throw Exception("Failed to delete budget: Status ${response.statusCode}, Response: ${response.body}");
      }
    } catch (e) {
      throw Exception("Delete request failed: $e");
    }
  }

  Future<void> addTransaction(String budgetId, String description, double amount,
      bool isExpense, String addedBy) async {
    final response = await http.post(
      Uri.parse("$baseUrl/$budgetId/transactions"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "description": description,
        "amount": amount,
        "date": DateTime.now().toIso8601String(),
        "addedBy": addedBy,
        "isExpense": isExpense
      }),
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to add transaction: ${response.body}");
    }
  }

  Future<List<Map<String, dynamic>>> getTransactions(String budgetId) async {
    final response = await http.get(Uri.parse("$baseUrl/$budgetId"));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey("expenses") && data["expenses"] is List) {
        return List<Map<String, dynamic>>.from(data["expenses"]);
      }
      return [];
    } else {
      throw Exception("Failed to load transactions");
    }
  }
}
