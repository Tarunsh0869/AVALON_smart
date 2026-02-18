import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Import your navigation screen so the app knows where to start
import 'package:quizproflutter/screens/main_navigation_screen.dart';

void main() async {
  // CRITICAL: This must be called before Firebase initializes!
  WidgetsFlutterBinding.ensureInitialized();

  // Connects to your new Avalon-Final-DB project
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AVAlON QuizPro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      // Set the initial screen
      home: const MainNavigationScreen(),
    );
  }
}
