import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:finance_tracker/model/Category.dart';
import 'package:shared_preferences/shared_preferences.dart';

String uri = dotenv.get('API_URI');

Future<List<MyCategory>> getCategoryByType(CategoryType categoryType) async {
  String typeString = categoryType.toString().split('.').last;

  SharedPreferences prefs = await SharedPreferences.getInstance();
  print(prefs.getString('auth_token'));
  String? token = prefs.getString('auth_token');

  final response = await http.get(
    Uri.parse('$uri/category/$typeString'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> categoryList =
        jsonDecode(response.body) as List<dynamic>;
    return MyCategory.fromJsonList(categoryList);
  } else {
    throw Exception("Failed to load categorys");
  }
}
