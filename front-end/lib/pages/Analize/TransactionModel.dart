class Transaction {
  final String title;
  final String dateTime;
  final double amount;
  final bool isIncome;

  Transaction({
    required this.title,
    required this.dateTime,
    required this.amount,
    required this.isIncome,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      title: json['title'],
      dateTime: json['dateTime'],
      amount: json['amount'].toDouble(),
      isIncome: json['isIncome'],
    );
  }
}
