import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fynaura/pages/goal-oriented-saving/model/Goal.dart';

class GoalService {
  final String baseUrl = 'http://192.168.127.53:3000/goals'; // Replace with your backend URL

  // Create Goal
  Future<Goal> createGoal(Goal goal) async {
    final response = await http.post(
      Uri.parse('$baseUrl'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': goal.name,
        'targetAmount': goal.targetAmount,
        'startDate': goal.startDate.toIso8601String(),
        'endDate': goal.endDate.toIso8601String(),
        'isCompleted': goal.isCompleted,
      }),
    );

    if (response.statusCode == 201) {
      return Goal.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create goal: ${response.body}');
    }
  }

  // Get Goals by User ID
  Future<List<Goal>> getGoalsByUser(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/$userId'));

    if (response.statusCode == 200) {
      Iterable list = jsonDecode(response.body);
      return list.map((goal) => Goal.fromJson(goal)).toList();
    } else {
      throw Exception('Failed to load goals: ${response.body}');
    }
  }

  // Get a single goal by ID
  // Future<Goal> getGoalById(String goalId, {required String goalId}) async {
  //   final response = await http.get(Uri.parse('$baseUrl/goal/$goalId'));

  //   if (response.statusCode == 200) {
  //     return Goal.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to load goal: ${response.body}');
  //   }
  // }

  // Update Goal
  Future<Goal> updateGoal(String goalId, Goal goal) async {
    final response = await http.put(
      Uri.parse('$baseUrl/goal/$goalId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': goal.name,
        'targetAmount': goal.targetAmount,
        'startDate': goal.startDate.toIso8601String(),
        'endDate': goal.endDate.toIso8601String(),
        'isCompleted': goal.isCompleted,
      }),
    );

    if (response.statusCode == 200) {
      return Goal.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update goal: ${response.body}');
    }
  }

  // Add Amount to Goal
  Future<Goal> addAmount(String goalId, double amount) async {
    final response = await http.post(
      Uri.parse('$baseUrl/goal/$goalId/addAmount'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'amount': amount}),
    );

    if (response.statusCode == 200) {
      return Goal.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add amount: ${response.body}');
    }
  }

  // Subtract Amount from Goal
  Future<Goal> subtractAmount(String goalId, double amount) async {
    final response = await http.post(
      Uri.parse('$baseUrl/goal/$goalId/subtractAmount'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'amount': amount}),
    );

    if (response.statusCode == 200) {
      return Goal.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to subtract amount: ${response.body}');
    }
  }

  // Add a Transaction to the Goal
  Future<Goal> addTransaction(String goalId, double amount, String date, bool isAdded) async {
    final response = await http.post(
      Uri.parse('$baseUrl/goal/$goalId/addTransaction'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': amount,
        'date': date,
        'isAdded': isAdded,
      }),
    );

    if (response.statusCode == 200) {
      return Goal.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add transaction: ${response.body}');
    }
  }

  Future<List<Goal>> getAllGoals() async {
    final response = await http.get(Uri.parse('$baseUrl'));

    if (response.statusCode == 200) {
      Iterable list = jsonDecode(response.body);
      return list.map((goal) => Goal.fromJson(goal)).toList();// Mapping the JSON response to Goal objects
    } else {
      throw Exception('Failed to load goals: ${response.body}');
    }
  }

  Future<void> markGoalAsCompleted(String goalId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$goalId/complete'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark goal as completed: ${response.body} ');
    }
  }

  Future<double> getGoalProgress(String goalId) async {
    final response = await http.get(Uri.parse('$baseUrl/$goalId/progress'));

    if (response.statusCode == 200) {
      final progressData = jsonDecode(response.body);
      return progressData['progress']; // Return the progress value from the response
    } else {
      throw Exception('Failed to fetch goal progress: ${response.body}');
    }
  }
}
