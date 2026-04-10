// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://localhost:3000"; 

  Future<void> login(String name, String email) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        print("Response: ${response.body}");
      } else {
        print("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Connection Error: $e");
    }
  }
}