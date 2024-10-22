import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:finance_tracker/model/Category.dart';

String uri = dotenv.get('API_URI');
String token =
    "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjYW1pQGNhbWkuY29tIiwiaWF0IjoxNzI5NTIwMDc0LCJleHAiOjE3Mjk2MDY0NzR9.LDkbyILoOj1iCuM8LgAjXs-Ch48tw2mLpWnnbr25gYY";

Future<List<MyCategory>> getCategoryByType(CategoryType categoryType) async {
  String typeString = categoryType.toString().split('.').last;
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
