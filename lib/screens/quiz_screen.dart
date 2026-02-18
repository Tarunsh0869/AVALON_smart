import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:math';
import '../globals.dart' as globals;

class QuizScreen extends StatefulWidget {
  final String category;
  const QuizScreen({super.key, required this.category});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  List<Map<String, dynamic>> questions = [];
  bool isLoading = true;
  Timer? _timer;
  int _secondsElapsed = 0;

  @override
  void initState() {
    super.initState();
    _fetchQuestionsFromFirebase();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() => _secondsElapsed++);
    });
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return "${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  Future<void> _fetchQuestionsFromFirebase() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('question_bank')
          .where('category', isEqualTo: widget.category)
          .get();

      List<Map<String, dynamic>> fetchedQuestions = snapshot.docs.map((doc) {
        return {"q": doc['q'], "a": List<String>.from(doc['a']), "c": doc['c']};
      }).toList();

      if (fetchedQuestions.isNotEmpty) fetchedQuestions.shuffle(Random());
      if (mounted) {
        setState(() {
          questions = fetchedQuestions;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _checkAnswer(String selectedAnswer) {
    String correctText =
        questions[currentQuestionIndex]['a'][questions[currentQuestionIndex]['c']];
    if (selectedAnswer == correctText) score++;

    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        _timer?.cancel();
        _showCelebration();
      }
    });
  }

  void _showCelebration() async {
    // Saves completion time and score to Cloud Firestore
    await FirebaseFirestore.instance.collection('leaderboard').add({
      "name": globals.currentUserName,
      "score": score,
      "category": widget.category,
      "timeTaken": _formatTime(_secondsElapsed),
      "timestamp": FieldValue.serverTimestamp(),
    });

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Quiz Complete!", textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.timer_outlined, size: 60, color: Colors.indigo),
            const SizedBox(height: 15),
            Text(
              "Time Taken: ${_formatTime(_secondsElapsed)}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("Score: $score / ${questions.length}"),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("Return to Home"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (questions.isEmpty)
      return const Scaffold(
        body: Center(child: Text("No questions available.")),
      );

    var q = questions[currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(
                _formatTime(_secondsElapsed),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / questions.length,
            ),
            const SizedBox(height: 40),
            Text(
              q['q'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ...List.generate(
              q['a'].length,
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _checkAnswer(q['a'][i]),
                    child: Text(q['a'][i]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
