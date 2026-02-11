import 'package:flutter/material.dart';
import 'main_navigation_screen.dart';
import '../globals.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "AVAlON",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 10),
            const Text("Assessment & Quiz Platform"),
            const SizedBox(height: 40),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Enter Your Name",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                onPressed: () {
                  if (_nameController.text.isNotEmpty) {
                    setState(() {
                      currentUserName =
                          _nameController.text; // Updates global name
                    });
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainNavigationScreen(),
                      ),
                    );
                  }
                },
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
