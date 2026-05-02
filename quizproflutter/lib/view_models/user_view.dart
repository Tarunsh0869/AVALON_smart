import 'package:flutter/material.dart';
import '../data/repositories/auth_repository.dart';
import '../data/models/user_model.dart';

class UserViewModel with ChangeNotifier {
  final AuthRepository _repo = AuthRepository();

  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  String get userName => _user?.name ?? 'Guest';
  int? get userId => _user?.id;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _repo.register(name, email, password);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _repo.login(email, password);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    _user = null;
    notifyListeners();
  }
}
