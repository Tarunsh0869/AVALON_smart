// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// WARNING: This file defines a duplicate 'HomeScreen' class.
// The active HomeScreen used by the app is in home_screen.dart.
// This file (topics_screen.dart) is currently not imported anywhere.
// Do NOT import both files in the same scope — it will cause a compile error.
import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {"id": 1, "title": "Python",      "icon": Icons.code,           "color": Colors.orange},
      {"id": 2, "title": "SQL",          "icon": Icons.storage,        "color": Colors.blue},
      {"id": 3, "title": "UI/UX",        "icon": Icons.design_services, "color": Colors.pink},
      {"id": 4, "title": "Data Science", "icon": Icons.analytics,      "color": Colors.green},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
        title: const Text(
          "AVAlON Assessment",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            // Your name is now displayed in the App Bar
            child: Chip(
              label: Text(
                "Tarun Sharma",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Student Dashboard",
              style: TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Personalized welcome message
            Text(
              "Welcome, Tarun Sharma",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Ready to test your knowledge?",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizScreen(
                              categoryId: categories[index]['id'],
                              categoryName: categories[index]['title'],
                            ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: (categories[index]['color'] as Color).withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              categories[index]['icon'],
                              size: 40,
                              color: categories[index]['color'],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            categories[index]['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
