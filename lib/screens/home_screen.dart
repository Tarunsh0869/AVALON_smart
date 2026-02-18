import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Map<String, dynamic>> topics = [
    {"title": "Python", "icon": Icons.terminal, "color": Colors.blue},
    {"title": "SQL", "icon": Icons.storage, "color": Colors.orange},
    {"title": "UI/UX", "icon": Icons.design_services, "color": Colors.pink},
    {"title": "Java", "icon": Icons.code, "color": Colors.red},
    {"title": "Trigonometry", "icon": Icons.functions, "color": Colors.purple},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome back, Tarun Sharma!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Pick a topic to start your assessment.",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.1,
                ),
                itemCount: topics.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuizScreen(category: topics[index]['title']),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: topics[index]['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: topics[index]['color'],
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            topics[index]['icon'],
                            size: 50,
                            color: topics[index]['color'],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            topics[index]['title'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: topics[index]['color'],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
