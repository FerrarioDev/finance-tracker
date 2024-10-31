import 'dart:convert';

import 'package:finance_tracker/model/Budget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String uri = dotenv.get("API_URI");

Future<List<Budget>> getBudgets() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('auth_token');

  final response = await http.get(
    Uri.parse('$uri/budgets'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> budgetList = jsonDecode(response.body) as List<dynamic>;
    return Budget.fromJsonList(budgetList);
  } else {
    throw Exception('Failed to load budgets');
  }
}
