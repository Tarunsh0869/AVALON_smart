import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const QuizProApp());
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
