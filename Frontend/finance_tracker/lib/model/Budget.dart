class Budget {
  final int? id;
  final String name;
  final int userId;
  final int categoryId;
  final double amount;
  final double? progress;
  final DateTime startDate;
  final DateTime endDate;

  Budget({
    this.id,
    required this.name,
    required this.userId,
    required this.categoryId,
    required this.amount,
    this.progress,
    required this.startDate,
    required this.endDate,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'] as int?,
      name: json['name'] as String,
      userId: json['user']['id'] as int, // Access nested user id
      categoryId: json['category']['id'] as int, // Access nested category id
      amount: (json['amount'] is double)
          ? json['amount']
          : double.parse(json['amount'].toString()),
      progress: json['progress'] != null
          ? (json['progress'] is double
              ? json['progress']
              : double.parse(json['progress'].toString()))
          : null,
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }

  static List<Budget> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Budget.fromJson(json)).toList();
  }
}
