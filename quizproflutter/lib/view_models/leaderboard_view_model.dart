import 'package:flutter/material.dart';
import '../data/repositories/leaderboard_repository.dart';
import '../data/models/leaderboard_model.dart';

class LeaderboardViewModel with ChangeNotifier {
  final LeaderboardRepository _repo = LeaderboardRepository();

  List<LeaderboardModel> _entries = [];
  bool _isLoading = false;
  String? _error;

  List<LeaderboardModel> get entries => _entries;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchRankings() async {
    if (_isLoading) return;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _entries = (await _repo.fetchRankings()).cast<LeaderboardModel>();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
