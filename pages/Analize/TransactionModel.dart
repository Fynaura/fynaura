class Transaction {
  final String type;  // 'income' or 'expense'
  final double amount;
  final String category;
  final String? description; // Optional field
  final DateTime date; // DateTime object to handle the date correctly
  final bool reminder; // Reminder status
  final DateTime? reminderDate; // Optional reminder date

  Transaction({
    required this.type,
    required this.amount,
    required this.category,
    this.description,
    required this.date,
    required this.reminder,
    this.reminderDate,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      type: json['type'],  // 'income' or 'expense'
      amount: json['amount'].toDouble(),
      category: json['category'],
      description: json['description'],
      date: DateTime.parse(json['date']), // Parsing date string to DateTime
      reminder: json['reminder'] ?? false,
      reminderDate: json['reminderDate'] != null
          ? DateTime.parse(json['reminderDate'])
          : null,
    );
  }

  String get formattedDate {
    return '${date.month}/${date.day}/${date.year}';
  }
}
