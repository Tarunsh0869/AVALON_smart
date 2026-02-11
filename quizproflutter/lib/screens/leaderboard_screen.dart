import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  // Mock data representing top students
  final List<Map<String, dynamic>> players = const [
    {"name": "Tarun Sharma", "score": 250, "rank": 1},
    {"name": "Priyanshu", "score": 235, "rank": 2},
    {"name": "Sachit", "score": 210, "rank": 3},
    {"name": "Rahul Kumar", "score": 190, "rank": 4},
    {"name": "Rishabh Singh", "score": 185, "rank": 5},
  ];

  @override
  Widget build(BuildContext context) {
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
          // List of players
          Expanded(
            child: ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: index < 3
                        ? Colors.amber
                        : Colors.grey[300],
                    child: Text("#${player['rank']}"),
                  ),
                  title: Text(
                    player['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
