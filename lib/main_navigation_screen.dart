import 'package:flutter/material.dart';
import 'home_screen.dart'; // Only import the main home_screen
import '../globals.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // Updated list to point to your personalized Home and a Leaderboard
  final List<Widget> _pages = [const HomeScreen(), const LeaderboardScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AVAlON Leaderboard"),
        centerTitle: true,
      ),
      body: sessionLeaderboard.isEmpty
          ? const Center(child: Text("No scores recorded yet!"))
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: sessionLeaderboard.length,
              itemBuilder: (context, index) {
                final entry = sessionLeaderboard[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text("${index + 1}")),
                    title: Text(entry['name']),
                    subtitle: Text(entry['category']),
                    trailing: Text("${entry['score']}/10"),
                  ),
                );
              },
            ),
    );
  }
}
