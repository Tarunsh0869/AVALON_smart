import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:cloud_firestore/cloud_firestore.dart';
=======
import '../globals.dart' as globals; // Connecting to your global state
>>>>>>> d1d1a070e2ca1890e42158e85364406b7e9a1c98

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
      body: StreamBuilder<QuerySnapshot>(
        // Fetch rankings from Cloud Firestore sorted by highest score
        stream: FirebaseFirestore.instance
            .collection('leaderboard')
            .orderBy('score', descending: true)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No rankings available yet. Complete a quiz!"),
            );
          }

          var docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data() as Map<String, dynamic>;

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
<<<<<<< HEAD
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigo,
                    child: Text(
                      "${index + 1}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
=======
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
>>>>>>> d1d1a070e2ca1890e42158e85364406b7e9a1c98
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
<<<<<<< HEAD
                  title: Text(
                    data['name'] ?? "Tarun Sharma",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Topic: ${data['category']}"),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Score: ${data['score']}",
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Time: ${data['timeTaken'] ?? '--:--'}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
=======
          ),
        ],
>>>>>>> d1d1a070e2ca1890e42158e85364406b7e9a1c98
      ),
    );
  }
}
