import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
=======
>>>>>>> d1d1a070e2ca1890e42158e85364406b7e9a1c98
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
<<<<<<< HEAD
  List<Map<String, dynamic>> questions = [];
  bool isLoading = true;
  Timer? _timer;
  int _secondsElapsed = 0;
=======
  late List<Map<String, dynamic>> questions;
>>>>>>> d1d1a070e2ca1890e42158e85364406b7e9a1c98

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
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

=======
    questions = _getQuestionBank(widget.category);

    // 1. Shuffle the order of the questions
    questions.shuffle(Random());

    // 2. Shuffle the options for EVERY question
    for (var q in questions) {
      // Save the actual text of the correct answer before we mix them up
      String correctAnswerText = q['a'][q['c']];

      // Create a copy of the options and shuffle them
      List<String> shuffledOptions = List<String>.from(q['a']);
      shuffledOptions.shuffle(Random());

      // Update the question map with the newly shuffled options
      q['a'] = shuffledOptions;

      // Store the correct text so we can check it later
      q['correct_text'] = correctAnswerText;
    }
  }

  List<Map<String, dynamic>> _getQuestionBank(String category) {
    if (category == "Python") {
      return [
        {
          "q": "Which keyword is used to create a function?",
          "a": ["fun", "def", "function", "lambda"],
          "c": 1,
        },
        {
          "q": "What is the output of print(2**3)?",
          "a": ["5", "6", "8", "9"],
          "c": 2,
        },
        {
          "q": "Which data type is immutable?",
          "a": ["List", "Dictionary", "Set", "Tuple"],
          "c": 3,
        },
        {
          "q": "How do you start a comment in Python?",
          "a": ["//", "/*", "#", "--"],
          "c": 2,
        },
        {
          "q": "Which function is used to get user input?",
          "a": ["get()", "input()", "read()", "scan()"],
          "c": 1,
        },
        {
          "q": "Correct extension for Python files?",
          "a": [".pyt", ".pt", ".py", ".python"],
          "c": 2,
        },
        {
          "q": "Which operator is used for floor division?",
          "a": ["/", "//", "%", "**"],
          "c": 1,
        },
        {
          "q": "How do you check list length?",
          "a": ["size()", "count()", "len()", "length()"],
          "c": 2,
        },
        {
          "q": "Which keyword is used for loops?",
          "a": ["while", "loop", "repeat", "until"],
          "c": 0,
        },
        {
          "q": "Which of these is used to import a module?",
          "a": ["get", "require", "import", "include"],
          "c": 2,
        },
      ];
    } else if (category == "SQL") {
      return [
        {
          "q": "Which command fetches data from a database?",
          "a": ["GET", "SELECT", "OPEN", "FETCH"],
          "c": 1,
        },
        {
          "q": "Which constraint ensures unique values?",
          "a": ["NOT NULL", "UNIQUE", "CHECK", "DEFAULT"],
          "c": 1,
        },
        {
          "q": "Which clause is used to filter results?",
          "a": ["WHERE", "FILTER", "HAVING", "GROUP BY"],
          "c": 0,
        },
        {
          "q": "Which SQL statement is used to update data?",
          "a": ["SAVE", "MODIFY", "UPDATE", "CHANGE"],
          "c": 2,
        },
        {
          "q": "What does SQL stand for?",
          "a": [
            "Simple Query Language",
            "Structured Query Language",
            "Strong Query Language",
            "Styled Query Language",
          ],
          "c": 1,
        },
        {
          "q": "Which keyword sorts the result-set?",
          "a": ["SORT BY", "ORDER BY", "ARRANGE", "ALIGN"],
          "c": 1,
        },
        {
          "q": "How do you delete all records from a table?",
          "a": ["REMOVE", "DROP", "DELETE", "TRUNCATE"],
          "c": 2,
        },
        {
          "q": "Which join returns all matching records?",
          "a": ["INNER JOIN", "LEFT JOIN", "RIGHT JOIN", "FULL JOIN"],
          "c": 0,
        },
        {
          "q": "Which function counts the number of rows?",
          "a": ["SUM()", "COUNT()", "NUMBER()", "TOTAL()"],
          "c": 1,
        },
        {
          "q": "Which keyword removes duplicate rows?",
          "a": ["UNIQUE", "DISTINCT", "DIFFERENT", "SINGLE"],
          "c": 1,
        },
      ];
    } else if (category == "UI/UX") {
      return [
        {
          "q": "What does UX stand for?",
          "a": [
            "User X-factor",
            "User Experience",
            "User Extreme",
            "User Example",
          ],
          "c": 1,
        },
        {
          "q": "A visual representation of an app flow is?",
          "a": ["Prototype", "Wireframe", "Mockup", "Sitemap"],
          "c": 1,
        },
        {
          "q": "Which color is often associated with 'Success'?",
          "a": ["Red", "Blue", "Green", "Yellow"],
          "c": 2,
        },
        {
          "q": "What is the primary goal of UI design?",
          "a": ["Visual Appeal", "Coding Ease", "Server Speed", "Marketing"],
          "c": 0,
        },
        {
          "q": "Which tool is commonly used for UI design?",
          "a": ["Figma", "VS Code", "Excel", "Postman"],
          "c": 0,
        },
        {
          "q": "What is 'White Space' in design?",
          "a": [
            "Empty space",
            "White background",
            "Eraser tool",
            "Color palette",
          ],
          "c": 0,
        },
        {
          "q": "What is the first stage of the Design Thinking process?",
          "a": ["Ideate", "Prototype", "Empathize", "Define"],
          "c": 2,
        },
        {
          "q": "A clickable version of your design is a?",
          "a": ["Mockup", "Wireframe", "Prototype", "Sketch"],
          "c": 2,
        },
        {
          "q": "Which font type has small lines at the ends of letters?",
          "a": ["Sans Serif", "Serif", "Monospace", "Cursive"],
          "c": 1,
        },
        {
          "q": "What does 'Accessibility' refer to?",
          "a": [
            "App speed",
            "Offline mode",
            "Inclusivity for all users",
            "File size",
          ],
          "c": 2,
        },
      ];
    } else if (category == "Data Sci") {
      return [
        {
          "q": "Primary library for data manipulation?",
          "a": ["Pandas", "Matplotlib", "NumPy", "Scikit-learn"],
          "c": 0,
        },
        {
          "q": "Which algorithm is used for classification?",
          "a": ["K-Means", "Random Forest", "Mean Shift", "PCA"],
          "c": 1,
        },
        {
          "q": "What does EDA stand for?",
          "a": [
            "Exploratory Data Analysis",
            "Early Data Analysis",
            "External Data",
            "Easy Data",
          ],
          "c": 0,
        },
        {
          "q": "Which plot is best for detecting outliers?",
          "a": ["Pie Chart", "Box Plot", "Line Chart", "Area Chart"],
          "c": 1,
        },
        {
          "q": "Which library is used for visualization?",
          "a": ["Requests", "NLTK", "Matplotlib", "Flask"],
          "c": 2,
        },
        {
          "q": "What is the standard format for datasets?",
          "a": ["PDF", "DOCX", "CSV", "TXT"],
          "c": 2,
        },
        {
          "q": "Goal of Data Cleaning?",
          "a": [
            "Shrink data",
            "Improve data quality",
            "Add noise",
            "Change UI",
          ],
          "c": 1,
        },
        {
          "q": "Interactive coding tool for Data Science?",
          "a": ["Notepad", "Jupyter Notebook", "Paint", "Excel"],
          "c": 1,
        },
        {
          "q": "Which is a supervised learning algorithm?",
          "a": ["Linear Regression", "K-Means", "DBSCAN", "Apriori"],
          "c": 0,
        },
        {
          "q": "The measure of central tendency is?",
          "a": ["Variance", "Mean", "Range", "Standard Deviation"],
          "c": 1,
        },
      ];
    }
    return [];
  }

  void _checkAnswer(String selectedAnswer) {
    if (selectedAnswer == questions[currentQuestionIndex]['correct_text']) {
      score++;
    }
>>>>>>> d1d1a070e2ca1890e42158e85364406b7e9a1c98
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
<<<<<<< HEAD
        _timer?.cancel();
=======
>>>>>>> d1d1a070e2ca1890e42158e85364406b7e9a1c98
        _showCelebration();
      }
    });
  }

<<<<<<< HEAD
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

=======
  void _showCelebration() {
    // THIS SAVES YOUR SCORE TO THE LEADERBOARD
    globals.sessionLeaderboard.add({
      "name": globals.currentUserName,
      "score": score,
      "category": widget.category,
    });

>>>>>>> d1d1a070e2ca1890e42158e85364406b7e9a1c98
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
<<<<<<< HEAD
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
=======
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
>>>>>>> d1d1a070e2ca1890e42158e85364406b7e9a1c98
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
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
=======
    var q = questions[currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(title: Text("${widget.category} Assessment")),
>>>>>>> d1d1a070e2ca1890e42158e85364406b7e9a1c98
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
<<<<<<< HEAD
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
=======
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
>>>>>>> d1d1a070e2ca1890e42158e85364406b7e9a1c98
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
