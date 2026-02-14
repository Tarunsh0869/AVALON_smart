import 'package:flutter/material.dart';
import '../globals.dart' as globals; // Connecting to your global state

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Fetch the dynamic list from globals instead of a hardcoded const list
    // We use List.from() to create a copy so we can sort it safely
    List<Map<String, dynamic>> players = List.from(globals.sessionLeaderboard);

    // 2. Sort the list automatically (Highest score at the top)
    players.sort((a, b) => b['score'].compareTo(a['score']));

    return Scaffold(
      appBar: AppBar(title: const Text("AVAlON - Global Leaderboard")),
      body: Column(
        children: [
          // Top Rank Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            color: Colors.indigo,
            child: const Column(
              children: [
                Icon(Icons.emoji_events, color: Colors.amber, size: 60),
                Text(
                  "Top Scorers",
                  style: TextStyle(
                    color: Color.fromARGB(255, 237, 156, 156),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Dynamic List of Players
          Expanded(
            child: players.isEmpty
                ? const Center(
                    child: Text(
                      "No quizzes taken yet. Be the first!",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: players.length,
                    itemBuilder: (context, index) {
                      final player = players[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: index < 3
                              ? Colors.amber
                              : Colors.grey[300],
                          // Dynamically assign rank based on their sorted position
                          child: Text("#${index + 1}"),
                        ),
                        title: Text(
                          player['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Category: ${player['category'] ?? 'General'}",
                        ),
                        trailing: Text(
                          "${player['score']} pts",
                          style: const TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
