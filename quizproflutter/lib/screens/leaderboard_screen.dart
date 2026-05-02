import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/leaderboard_view_model.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<LeaderboardViewModel>().fetchRankings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AVAlON - Global Leaderboard'),
        elevation: 0,
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            color: Colors.indigo,
            child: const Column(
              children: [
                Icon(Icons.emoji_events, color: Colors.amber, size: 60),
                Text('Top Scorers',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: Consumer<LeaderboardViewModel>(
              builder: (context, vm, _) {
                if (vm.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (vm.error != null) {
                  return Center(
                      child: Text('Error: ${vm.error}',
                          style: const TextStyle(color: Colors.red)));
                }

                if (vm.entries.isEmpty) {
                  return const Center(
                      child: Text('No scores found. Be the first!'));
                }

                return ListView.builder(
                  itemCount: vm.entries.length,
                  itemBuilder: (context, index) {
                    final entry = vm.entries[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            entry.rank <= 3 ? Colors.amber : Colors.grey[300],
                        child: Text('#${entry.rank}'),
                      ),
                      title: Text(entry.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Category: ${entry.category}'),
                      trailing: Text('${entry.bestScore} pts',
                          style: const TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold)),
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
