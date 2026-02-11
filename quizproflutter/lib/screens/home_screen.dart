import 'package:flutter/material.dart';
import 'quiz_screen.dart';
import '../globals.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AVAlON Assessment"),
        backgroundColor: Colors.indigo,
        actions: [IconButton(icon: const Icon(Icons.person), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Profile Header
            Text(
              "Tarun Sharma",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Text(
              "BCA 6th Sem | SVSU Meerut",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),

            // NASSCOM Trainee Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "✓ NASSCOM Data Analytics Trainee",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              "Assessment Modules",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // Grid of working topics
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                _buildTopicCard(context, "Python", Icons.code, Colors.blue),
                _buildTopicCard(context, "SQL", Icons.storage, Colors.orange),
                _buildTopicCard(context, "UI/UX", Icons.brush, Colors.pink),
                _buildTopicCard(
                  context,
                  "Data Science",
                  Icons.analytics,
                  Colors.purple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QuizScreen(category: title)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
