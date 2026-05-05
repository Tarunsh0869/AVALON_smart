import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TokenStorage {
  static const String _tokenKey = 'jwt_token';
  static const String _userDataKey = 'user_data';

  // ── Token Management ──────────────────────────────────────────────────────

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ── User Data Persistence (id, name, email — NO password) ────────────────

  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, jsonEncode(userData));
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_userDataKey);
    if (data == null) return null;
    return jsonDecode(data) as Map<String, dynamic>;
  }

  // ── Complete Logout (clear everything) ───────────────────────────────────

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userDataKey);
  }

  // Backward compatibility
  static Future<void> clearToken() => clearAll();
}
