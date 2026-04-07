import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Use 10.0.2.2 for Android Emulator, 127.0.0.1 for iOS Simulator
  final String baseUrl = "http://10.0.2.2:3000"; 

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