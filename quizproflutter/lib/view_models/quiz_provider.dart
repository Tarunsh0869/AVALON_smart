import 'package:flutter/material.dart';
import '../data/repositories/quiz_repository.dart';
import '../data/models/question_model.dart';

class QuizProvider with ChangeNotifier {
  final QuizRepository _repo = QuizRepository();

  List<QuestionModel> _questions = [];
  // questionId → selected option string (e.g. "A" or full option text)
  final Map<int, String> _answers = {};
  int _currentIndex = 0;
  bool _isLoading = false;
  String? _error;

  int? _score;
  int? _total;
  String? _resultMessage;

  bool get isLoading => _isLoading;
  String? get error => _error;
  int get currentIndex => _currentIndex;
  int get totalQuestions => _questions.length;
  int? get score => _score;
  int? get total => _total;
  String? get resultMessage => _resultMessage;
  bool get isFinished =>
      _questions.isNotEmpty && _currentIndex >= _questions.length;

  QuestionModel? get currentQuestion =>
      _currentIndex < _questions.length ? _questions[_currentIndex] : null;

  Future<void> loadQuiz(int categoryId) async {
    _isLoading = true;
    _currentIndex = 0;
    _answers.clear();
    _score = null;
    _total = null;
    _resultMessage = null;
    _error = null;
    notifyListeners();

    try {
      _questions = await _repo.getQuestions(categoryId);
      _questions.shuffle();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // option is the full option string — backend matches against CorrectOption
  void selectAnswer(int questionId, String option) {
    _answers[questionId] = option;
    _currentIndex++;
    notifyListeners();
  }

  Future<void> submitQuiz(int categoryId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Send as list of {questionId, selectedOption} objects
      final answers = _answers.entries
          .map((e) => {'questionId': e.key, 'selectedOption': e.value})
          .toList();
      final result = await _repo.submitQuiz(
        categoryId: categoryId,
        answers: answers,
      );
      _score         = result['score']   as int;
      _total         = result['total']   as int;
      _resultMessage = result['message'] as String;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
