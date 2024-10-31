import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

String uri = dotenv.get('API_URI');
Future<Map<String, dynamic>> authenticate(String email, String password) async {
  Map<String, String> headers = {"Content-Type": "application/json"};

  final body = {
    "email": email,
    "password": password,
  };

  try {
    final response = await http.post(
      Uri.parse('$uri/auth/authenticate'),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String token = data['token'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);

      return {"token": data['token']};
    } else {
      // In case of login failure
      return {"error": "Login failed"};
    }
  } catch (e) {
    // Handling any network or parsing errors
    return {"error": "Error: $e"};
  }
}

// logout controller
Future<void> logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('auth_token');
}
