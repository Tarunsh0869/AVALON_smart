import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import '../globals.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [const HomeScreen(), const LeaderboardScreen()];

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
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Change Name",
            onPressed: () {
              // Returns to login to change the name
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.leaderboard_outlined),
            label: 'Rankings',
          ),
        ],
      ),
    );
  }
}

// Fixed Leaderboard Screen (No more "Coming Soon")
class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    title: Text(entry['name'] ?? "User"),
                    subtitle: Text(entry['category']),
                    trailing: Text(
                      "${entry['score']}/10",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
