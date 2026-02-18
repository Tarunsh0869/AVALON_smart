import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // REQUIRED: For Cloud Database
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

  // Changed from 'late' to an empty list so we can show a loading spinner
  List<Map<String, dynamic>> questions = [];
  bool isLoading = true; // Controls the loading screen

  @override
  void initState() {
    super.initState();
    // 1. Fetch live questions from Firebase instead of the local list
    _fetchQuestionsFromFirebase();
  }

  // ---------------------------------------------------------
  // NEW: Firebase Cloud Fetch Logic
  // ---------------------------------------------------------
  Future<void> _fetchQuestionsFromFirebase() async {
    try {
      // Ask Firebase for documents where 'category' matches the clicked tag
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('question_bank')
          .where('category', isEqualTo: widget.category)
          .get();

      // Convert the cloud documents into your normal list format
      List<Map<String, dynamic>> fetchedQuestions = snapshot.docs.map((doc) {
        return {
          "q": doc['q'],
          "a": List<String>.from(doc['a']), // Converts to a Dart List
          "c": doc['c'],
        };
      }).toList();

      // Apply your exact Smart Shuffle logic
      fetchedQuestions.shuffle(Random());
      for (var q in fetchedQuestions) {
        String correctAnswerText = q['a'][q['c']];
        List<String> shuffledOptions = List<String>.from(q['a']);
        shuffledOptions.shuffle(Random());
        q['a'] = shuffledOptions;
        q['correct_text'] = correctAnswerText;
      }

      // Update the screen with the fetched data
      setState(() {
        questions = fetchedQuestions;
        isLoading = false; // Turn off the spinner
      });
    } catch (e) {
      print("Error fetching from Firebase: $e");
      setState(() {
        isLoading = false; // Stop spinning even if there is an error
      });
    }
  }

  void _checkAnswer(String selectedAnswer) {
    if (selectedAnswer == questions[currentQuestionIndex]['correct_text']) {
      score++;
    }
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        _showCelebration();
      }
    });
  }

  // Made async so it can wait for the cloud upload
  void _showCelebration() async {
    // ---------------------------------------------------------
    // NEW: Firebase Cloud Write Logic
    // ---------------------------------------------------------
    // Push the final score securely to the Firebase Leaderboard
    await FirebaseFirestore.instance.collection('leaderboard').add({
      "name": globals.currentUserName,
      "score": score,
      "category": widget.category,
      "timestamp": FieldValue.serverTimestamp(), // Helps sort exact ties
    });

    // Keep updating the local globals so it's instantly ready
    globals.sessionLeaderboard.add({
      "name": globals.currentUserName,
      "score": score,
      "category": widget.category,
    });

    // Required by Flutter when using 'await' before a Dialog popup
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, color: Colors.amber, size: 80),
            const SizedBox(height: 16),
            Text(
              "Congratulations, ${globals.currentUserName}!",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("Final Score: $score / ${questions.length}"),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Closes the popup
                Navigator.pop(context); // Takes you back to the Dashboard
              },
              child: const Text("Finish"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // NEW: Show a loading spinner while waiting for Firebase
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("${widget.category} Assessment")),
        body: const Center(
          child: CircularProgressIndicator(color: Colors.indigo),
        ),
      );
    }

    // Safety check if Firebase has no questions for this category
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("${widget.category} Assessment")),
        body: const Center(
          child: Text(
            "No questions found in the cloud yet.",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    // Your exact UI for the quiz body
    var q = questions[currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(title: Text("${widget.category} Assessment")),
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
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
