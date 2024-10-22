class Transaction {
  final int? id;
  final int userId;
  final int categoryId;
  final double amount;
  final TransactionType transactionType;
  final String description;
  final DateTime transactionDate;

  Transaction({
    this.id,
    required this.userId,
    required this.categoryId,
    required this.amount,
    required this.transactionType,
    required this.transactionDate,
    required this.description,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as int?,
      userId: (json['userId'] ?? 0) as int,
      categoryId: (json['category'] ?? 0) as int,
      amount: (json['amount'] ?? 0) as double,
      transactionType:
          TransactionType.values.byName(json['transactionType'] as String),
      transactionDate: DateTime.parse(json['transactionDate']),
      description: json['description'] as String,
    );
  }
  static List<Transaction> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Transaction.fromJson(json)).toList();
  }
}

enum TransactionType { ALL, INCOME, EXPENSE, TRANSFER }
