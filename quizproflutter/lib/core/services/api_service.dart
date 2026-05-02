import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../storage/token_storage.dart';

class ApiService {
  static Future<Map<String, String>> _headers({bool auth = false}) async {
    final headers = {'Content-Type': 'application/json'};
    if (auth) {
      final token = await TokenStorage.getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Future<dynamic> get(String path, {bool auth = false}) async {
    final res = await http.get(
      Uri.parse('${ApiConstants.baseUrl}$path'),
      headers: await _headers(auth: auth),
    );
    return _handle(res);
  }

  static Future<dynamic> post(
    String path,
    Map<String, dynamic> body, {
    bool auth = false,
  }) async {
    final res = await http.post(
      Uri.parse('${ApiConstants.baseUrl}$path'),
      headers: await _headers(auth: auth),
      body: jsonEncode(body),
    );
    return _handle(res);
  }

  static dynamic _handle(http.Response res) {
    final data = res.body.isNotEmpty ? jsonDecode(res.body) : null;
    if (res.statusCode >= 200 && res.statusCode < 300) return data;
    throw Exception(data?['message'] ?? 'Server error (${res.statusCode})');
  }

  // Token helpers — delegates to TokenStorage
  static Future<void> saveToken(String token) => TokenStorage.saveToken(token);
  static Future<String?> getToken()           => TokenStorage.getToken();
  static Future<void> clearToken()            => TokenStorage.clearToken();
}
