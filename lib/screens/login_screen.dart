import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // CONNECTS TO CLOUD
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
  bool isLoading = true; // NEW: Controls the loading spinner

  @override
  void initState() {
    super.initState();
    _fetchQuestionsFromFirebase(); // Fetch from cloud instead of hardcoded list
  }

  // ---------------------------------------------------------
  // FIREBASE CLOUD FETCH LOGIC
  // ---------------------------------------------------------
  Future<void> _fetchQuestionsFromFirebase() async {
    try {
      // 1. Ask Firebase for documents matching the clicked category
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('question_bank')
          .where('category', isEqualTo: widget.category)
          .get();

      // 2. Convert Firebase documents into our local list format
      List<Map<String, dynamic>> fetchedQuestions = snapshot.docs.map((doc) {
        return {
          "q": doc['q'],
          "a": List<String>.from(
            doc['a'],
          ), // Ensures it parses as a String List
          "c": doc['c'],
        };
      }).toList();

      // 3. Apply the Smart Shuffle Logic
      fetchedQuestions.shuffle(Random());

      for (var q in fetchedQuestions) {
        String correctAnswerText = q['a'][q['c']];
        List<String> shuffledOptions = List<String>.from(q['a']);
        shuffledOptions.shuffle(Random());
        q['a'] = shuffledOptions;
        q['correct_text'] = correctAnswerText;
      }

      // 4. Update the UI
      setState(() {
        questions = fetchedQuestions;
        isLoading = false; // Turn off the loading spinner
      });
    } catch (e) {
      print("Error fetching questions: $e");
      setState(() {
        isLoading = false;
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

  void _showCelebration() async {
    // ---------------------------------------------------------
    // FIREBASE CLOUD WRITE LOGIC
    // ---------------------------------------------------------
    // Push the final score securely to the new Firebase Leaderboard
    await FirebaseFirestore.instance.collection('leaderboard').add({
      "name": globals.currentUserName,
      "score": score,
      "category": widget.category,
      "timestamp": FieldValue.serverTimestamp(), // Helps break ties
    });

    // Also update local globals so it's instantly ready
    globals.sessionLeaderboard.add({
      "name": globals.currentUserName,
      "score": score,
      "category": widget.category,
    });

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
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Back to Dashboard
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

    // Fallback if the category has no questions in Firebase yet
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("${widget.category} Assessment")),
        body: const Center(
          child: Text(
            "No questions found for this module yet.",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    // Normal Quiz UI
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
