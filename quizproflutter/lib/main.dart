import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'view_models/quiz_provider.dart';
import 'view_models/user_view.dart';
import 'view_models/leaderboard_view_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => LeaderboardViewModel()),
      ],
      child: const QuizProApp(),
    ),
  );
}

class QuizProApp extends StatelessWidget {
  const QuizProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AVAlON',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const SplashScreen(),
    );
  }
}
