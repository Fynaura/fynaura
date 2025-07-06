class Goal {
  String id;
  String name;
  double targetAmount;
  double savedAmount;
  DateTime startDate;
  DateTime endDate;
  bool isCompleted;
  String? image;
  String userId;
  List<Transaction> history; // Add a list of Transaction to track goal history

  Goal({
    this.id = '',
    required this.name,
    required this.targetAmount,
    this.savedAmount = 0,
    required this.startDate,
    required this.endDate,
    this.isCompleted = false,
    this.image,
    required this.userId,
    List<Transaction>? history,
  }) : history =
            history ?? []; // If history is null, initialize it as an empty list

  // Factory constructor to create Goal from JSON
  factory Goal.fromJson(Map<String, dynamic> json) {
    var historyList =
        json['history'] as List?; // Check if 'history' exists in the JSON

    // Convert each transaction in the history list to a Transaction object
    List<Transaction> historyItems = historyList != null
        ? historyList.map((item) => Transaction.fromJson(item)).toList()
        : [];

    return Goal(
      id: json['_id'], // MongoDB returns _id, so we map it to 'id' here
      name: json['name'],
      targetAmount: (json['targetAmount'] is int
          ? (json['targetAmount'] as int).toDouble()
          : json['targetAmount']) as double, // Handle type conversion
      savedAmount: (json['savedAmount'] is int
              ? (json['savedAmount'] as int).toDouble()
              : json['savedAmount']) ??
          0.0, // Handle type conversion and default to 0.0
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      isCompleted: json['isCompleted'] ?? false,
      image: json['image'],
      userId: json['userId'] ?? 'defaultUserId',
      history: historyItems, // Set the history field
    );
  }

  // Convert Goal to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id, // Include the 'id' field when converting back to JSON
      'name': name,
      'targetAmount': targetAmount,
      'savedAmount': savedAmount,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isCompleted': isCompleted,
      'image': image,
      'userId': userId,
      'history': history
          .map((transaction) => transaction.toJson())
          .toList(), // Convert history to JSON
    };
  }
}

class Transaction {
  final String id;
  final double amount;
  final DateTime date;
  final bool isAdded;

  Transaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.isAdded,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'], // ✅ expects MongoDB _id
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
      isAdded: json['isAdded'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'isAdded': isAdded,
    };
  }
}