import 'package:flutter/material.dart';
import '../data/repositories/leaderboard_repository.dart';
import '../domain/entities/leaderboard_entry.dart';

class LeaderboardViewModel with ChangeNotifier {
  final LeaderboardRepository _repo = LeaderboardRepository();

  List<LeaderboardEntry> _entries = [];
  bool _isLoading = false;
  String? _error;

  List<LeaderboardEntry> get entries => _entries;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchRankings() async {
    if (_isLoading) return;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _entries = await _repo.fetchRankings();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
