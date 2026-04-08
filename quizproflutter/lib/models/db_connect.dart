import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/question.dart';

class QuizViewModel with ChangeNotifier {
  List<Question> _questions = [];
  int _currentIndex = 0;
  bool _isLoading = false;

  List<Question> get questions => _questions;
  int get currentIndex => _currentIndex;
  bool get isLoading => _isLoading;

  // Optimized: Fetches the specific category from your Firestore
  Future<void> fetchQuestions(String category) async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('question_bank')
          .doc(category)
          .collection('questions')
          .get();

      // Mapping Firestore documents to your local Question objects
      _questions = snapshot.docs.map((doc) => Question.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint("Error loading questions: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      notifyListeners(); // UI updates instantly
    }
  }
}