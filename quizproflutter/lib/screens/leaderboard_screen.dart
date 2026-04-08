// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; //
import '../view_models/leaderboard_view_model.dart'; //

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  void initState() {
    super.initState();
    // Schedule the heavy work to happen after the UI frame is drawn
    Future.microtask(() => 
       context.read<LeaderboardViewModel>().fetchRankings()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AVAlON - Global Leaderboard"),
        elevation: 0,
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          // Header remains consistent for branding
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
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // REPLACEMENT: Using Consumer for reactive data binding
          Expanded(
            child: Consumer<LeaderboardViewModel>(
              builder: (context, leaderboardVM, child) {
                if (leaderboardVM.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (leaderboardVM.topScores.isEmpty) {
                  return const Center(child: Text("No scores found. Be the first!"));
                }

                return ListView.builder(
                  itemCount: leaderboardVM.topScores.length,
                  itemBuilder: (context, index) {
                    // Extracting Firestore data safely
                    final player = leaderboardVM.topScores[index];

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: index < 3 ? Colors.amber : Colors.grey[300],
                        child: Text("#${index + 1}"),
                      ),
                      title: Text(
                        player['name'] ?? 'Unknown',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Category: ${player['category'] ?? 'General'}"),
                      trailing: Text(
                        "${player['score']} pts",
                        style: const TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}