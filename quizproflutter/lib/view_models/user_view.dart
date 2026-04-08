import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserViewModel with ChangeNotifier {
  String _userName = "";
  bool _isLoading = false;

  String get userName => _userName;
  bool get isLoading => _isLoading;

  // Logic to set user and log activity to Firestore
  Future<void> loginUser(String name) async {
    _isLoading = true;
    notifyListeners();

    try {
      _userName = name;
      // Address the 'user_activity' permission issue found in logs
      await FirebaseFirestore.instance.collection('user_activity').add({
        'name': name,
        'login_time': FieldValue.serverTimestamp(),
        'platform': 'Windows_Desktop',
      });
      notifyListeners();
    } catch (e) {
      debugPrint("Login/Activity Error: $e");
      rethrow; // Pass error to UI for the SnackBar
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}