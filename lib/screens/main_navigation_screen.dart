import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizproflutter/screens/home_screen.dart';
import 'package:quizproflutter/screens/leaderboard_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [HomeScreen(), LeaderboardScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "AVAlON",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          // ---------------------------------------------------------
          // TEMPORARY MASS UPLOADER BUTTON
          // ---------------------------------------------------------
          IconButton(
            icon: const Icon(Icons.cloud_upload),
            tooltip: "Upload Python Questions",
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Uploading to Avalon-Final-DB..."),
                ),
              );

              final firestore = FirebaseFirestore.instance;
              final batch = firestore.batch();

              List<Map<String, dynamic>> pythonQuestions = [
                {
                  "category": "Python",
                  "q": "What is the correct file extension for Python files?",
                  "a": [".pyth", ".pt", ".py", ".pyt"],
                  "c": 2,
                },
                {
                  "category": "Python",
                  "q": "How do you output 'Hello World' in Python?",
                  "a": [
                    "echo('Hello World')",
                    "print('Hello World')",
                    "p('Hello World')",
                    "console.log('Hello World')",
                  ],
                  "c": 1,
                },
                {
                  "category": "Python",
                  "q":
                      "Which of these is a popular Python data analysis library?",
                  "a": ["Pandas", "Django", "Flask", "Keras"],
                  "c": 0,
                },
                {
                  "category": "Python",
                  "q": "How do you create a variable with the numeric value 5?",
                  "a": ["x = int(5)", "x = 5", "Both are correct", "int x = 5"],
                  "c": 2,
                },
                {
                  "category": "Python",
                  "q":
                      "What is the correct way to create a function in Python?",
                  "a": [
                    "create myFunction():",
                    "def myFunction():",
                    "function myFunction():",
                    "void myFunction():",
                  ],
                  "c": 1,
                },
              ];

              for (var q in pythonQuestions) {
                var docRef = firestore.collection('question_bank').doc();
                batch.set(docRef, q);
              }

              await batch.commit();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("SUCCESS! Questions pushed to the Cloud!"),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
          // ---------------------------------------------------------
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Topics',
          ),
          NavigationDestination(
            icon: Icon(Icons.leaderboard_outlined),
            label: 'Rankings',
          ),
        ],
      ),
    );
  }
}
