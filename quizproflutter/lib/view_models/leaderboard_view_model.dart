import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardViewModel with ChangeNotifier {
  List<Map<String, dynamic>> _topScores = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get topScores => _topScores;
  bool get isLoading => _isLoading;

  Future<void> fetchRankings() async {
    // Prevent redundant calls if already loading
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Use async get() to fetch data off the main thread
      final snapshot = await FirebaseFirestore.instance
          .collection('leaderboard')
          .orderBy('score', descending: true)
          .limit(20)
          .get();

      // Mapping happens here, not in the widget build()
      _topScores = snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      debugPrint("Leaderboard Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}