import 'dart:convert';
import 'package:http/http.dart' as http;

import '../pages/user-session/UserSession.dart';

class BudgetService {
  final String baseUrl = "http://192.168.110.53:3000";

  // Get all budgets (including those where user is a collaborator)
  Future<List<Map<String, dynamic>>> getBudgets() async {
    try {
      final userSession = UserSession();
      final userId = userSession.userId;

      // Get both owned and collaborative budgets
      final response = await http.get(
        Uri.parse(('${baseUrl}/collab-budgets/check-exists/$userId')),
      );

      if (response.statusCode == 200) {
        // Print the raw response to debug
        print('Raw API response: ${response.body}');

        final dynamic decodedResponse = json.decode(response.body);
        print('Decoded response: $decodedResponse'); // Add this for debugging

        // Handle different response formats
        if (decodedResponse is List) {
          // Handle as list directly
          return decodedResponse.map<Map<String, dynamic>>((item) => {
            "id": item['_id'],
            "name": item['name'],
            "amount": item['amount'],
            "date": item['date'],
            "isPinned": item['isPinned'] ?? false,
            "isOwner": item['userId'] == userId,
          }).toList();
        } else if (decodedResponse is Map) {
          // Check for an error response
          if (decodedResponse.containsKey('error')) {
            throw Exception('API error: ${decodedResponse['error']}');
          }

          // Check for exists property (no budgets yet)
          if (decodedResponse.containsKey('exists') && !decodedResponse.containsKey('budgets')) {
            return []; // Return empty list if user exists but no budgets found
          }

          // Check if there's a wrapped budgets array
          if (decodedResponse.containsKey('budgets')) {
            final List<dynamic> budgets = decodedResponse['budgets'];
            print('Found budgets array: $budgets'); // Add this for debugging
            return budgets.map<Map<String, dynamic>>((item) => {
              "id": item['_id'] ?? item['id'], // Try both _id and id
              "name": item['name'],
              "amount": item['amount'],
              "date": item['date'],
              "isPinned": item['isPinned'] ?? false,
              "isOwner": item['userId'] == userId,
            }).toList();
          }
        }

        // Fallback to empty list for unrecognized formats
        return [];
      } else {
        throw Exception('Failed to load budgets: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getBudgets: $e');
      throw Exception('Error getting budgets: $e');
    }
  }

  // Create a new budget
  Future<Map<String, dynamic>> createBudget(String name, double amount, String date, String? userId) async {
    try {
      print('Creating budget with data: name=$name, amount=$amount, date=$date, userId=$userId');

      final response = await http.post(
        Uri.parse('$baseUrl/collab-budgets'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'amount': amount,
          'date': date,
          'userId': userId,
        }),
      );

      print('Create budget response status: ${response.statusCode}');
      print('Create budget response body: ${response.body}');

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return {
          "id": data['_id'] ?? data['id'], // Handle both formats
          "name": data['name'],
          "amount": data['amount'],
          "date": data['date'],
        };
      } else {
        throw Exception('Failed to create budget: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating budget: $e');
      throw Exception('Error creating budget: $e');
    }
  }

  // Delete a budget
  Future<void> deleteBudget(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/collab-budgets/$id'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete budget: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting budget: $e');
    }
  }

  // Get transactions for a budget
  Future<List<Map<String, dynamic>>> getTransactions(String budgetId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/collab-budgets/$budgetId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> expenses = data['expenses'] ?? [];

        return expenses.map((transaction) => {
          "description": transaction['description'],
          "amount": transaction['amount'],
          "date": transaction['date'],
          "addedBy": transaction['addedBy'],
          "isExpense": transaction['isExpense'] ?? true,
        }).toList();
      } else {
        throw Exception('Failed to load transactions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting transactions: $e');
    }
  }

  // Add a transaction to a budget
  Future<void> addTransaction(
      String budgetId,
      String description,
      double amount,
      bool isExpense,
      String addedBy,
      ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/collab-budgets/$budgetId/transactions'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'description': description,
          'amount': amount,
          'date': DateTime.now().toIso8601String(),
          'addedBy': addedBy,
          'isExpense': isExpense,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add transaction: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding transaction: $e');
    }
  }

  Future<bool> checkUserExists(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/collab-budgets/check-exists/$userId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['exists'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error checking user: $e');
    }
  }

  // Add a collaborator to a budget
  Future<void> addCollaborator(String budgetId, String userId) async {
    try {
      bool userExists = await checkUserExists(userId);
      if (!userExists) {
        throw Exception('User does not exist');
      }
      final response = await http.patch(
        Uri.parse('$baseUrl/collab-budgets/$budgetId/collaborators'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to add collaborator: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding collaborator: $e');
    }
  }

  // Get collaborators for a budget
  Future<List<String>> getCollaborators(String budgetId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/collab-budgets/$budgetId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> collaborators = data['collaborators'] ?? [];
        return collaborators.map((c) => c.toString()).toList();
      } else {
        throw Exception('Failed to load collaborators: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting collaborators: $e');
    }
  }
}

