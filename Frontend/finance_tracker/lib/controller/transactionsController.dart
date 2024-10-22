import 'dart:convert';
import 'package:finance_tracker/model/Transaction.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

String uri = dotenv.get('API_URI');
String token =
    "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjYW1pQGNhbWkuY29tIiwiaWF0IjoxNzI5NDU3NzIxLCJleHAiOjE3Mjk1NDQxMjF9.1TdYc4CPiPMRBzZTjZBMCFWyfYMCmDWeZ0Kp0KlcJR0";
Future<List<Transaction>> getTransactions() async {
  final response = await http.get(
    Uri.parse('$uri/transactions'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> transactionList =
        jsonDecode(response.body) as List<dynamic>;
    return Transaction.fromJsonList(transactionList);
  } else {
    throw Exception('Failed to load transactions');
  }
}

Future<Transaction> createTransaction(Transaction transaction) async {
  final transactionJson = {
    'user': transaction.userId,
    'category': transaction.categoryId,
    'amount': transaction.amount,
    'transactionType': transaction.transactionType.name,
    'transactionDate': transaction.transactionDate.toIso8601String(),
    'description': transaction.description,
  };

  final response = await http.post(
    Uri.parse('$uri/transactions'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(transactionJson),
  );

  if (response.statusCode == 200) {
    return Transaction.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception("Falied to create Transaction");
  }
}
