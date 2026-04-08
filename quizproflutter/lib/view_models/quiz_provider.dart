import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizProvider with ChangeNotifier {
  List<Map<String, dynamic>> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _isLoading = false;

  // Getters for the UI
  bool get isLoading => _isLoading;
  int get score => _score;
  int get currentIndex => _currentIndex;
  
  Map<String, dynamic> get currentQuestion {
    if (_questions.isEmpty || _currentIndex >= _questions.length) {
      return {};
    }
    return _questions[_currentIndex];
  }
  int get totalQuestions => _questions.length;

  // Logic: Fetch questions from the 'question_bank' shown in your console
  Future<void> loadQuiz(String category) async {
    _isLoading = true;
    _currentIndex = 0;
    _score = 0;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('question_bank')
          .doc(category)
          .collection('questions')
          .get();

      _questions = snapshot.docs.map((doc) => doc.data()).toList();
      _questions.shuffle(); // Move shuffling off the main UI thread
    } catch (e) {
      debugPrint("Firestore Fetch Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logic: Check answer and advance
  void checkAnswer(String selected, String correct) {
    if (selected == correct) _score++;
    _currentIndex++;
    notifyListeners();
  }

  // Logic: THE FIX for Firebase sync
  Future<void> syncScoreToFirebase(String userName, String category) async {
    try {
      await FirebaseFirestore.instance.collection('leaderboard').add({
        'name': userName,
        'score': _score,
        'category': category,
        'timestamp': FieldValue.serverTimestamp(), // Important for rankings
      });
    } catch (e) {
      debugPrint("Sync Error: $e");
    }
  }
}