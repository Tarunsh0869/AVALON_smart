import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'leaderboard_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // REMOVED 'const' to allow dynamic Firebase loading
  final List<Widget> _pages = [HomeScreen(), const LeaderboardScreen()];

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
        // FIXED LOGOUT BUTTON
        leading: IconButton(
          icon: const Icon(Icons.logout),
          tooltip: "Logout",
          onPressed: () {
            // Returns the user to the Login/Splash screen
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Cloud Admin Active: seed_db.js")),
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
