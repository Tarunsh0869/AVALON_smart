import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/user_view.dart';
import 'home_screen.dart';
import '../services/loginapi.dart';
import 'dart:async';
import 'navigation_screen.dart';

void main() {
  runApp(const StreamlineApp());
}

class StreamlineApp extends StatelessWidget {
  const StreamlineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6366F1),
        fontFamily: 'Outfit',
      ),
      home: const AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  void toggleView() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  Future<void> _handleAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = isLogin ? "User" : _nameController.text.trim();

    // Basic Validation
    if (email.isEmpty || password.isEmpty || (!isLogin && name.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    // Show Loading Dialog (UX Best Practice)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF6366F1)),
      ),
    );

    try {
      // Access your ViewModels/Services
      final userVM = context.read<UserViewModel>();

      // Simulate/Perform API logic
      await _apiService.login(name, email);
      await userVM.loginUser(name);

      if (mounted) {
        // Pop the loading dialog
        Navigator.of(context).pop();

        // NAVIGATE TO HOME: Use pushReplacement so user can't "Go Back" to login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Pop loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Authentication failed: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView( // Fixed: Prevents the yellow/black tape overflow
        child: Column(
          children: [
            // Shared Fluid Header
            _buildFluidHeader(isLogin ? "Welcome Back" : "Create Account"),
            
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: isLogin ? _buildLoginFields() : _buildRegisterFields(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFluidHeader(String title) {
    return Stack(
      children: [
        ClipPath(
          clipper: WaveClipper(),
          child: Container(
            height: 220,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E1B4B), Color(0xFF6366F1)],
              ),
            ),
          ),
        ),
        Positioned(
          top: 80,
          left: 30,
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginFields() {
    return Column(
      key: const ValueKey("login"),
      children: [
        _customField("Email", Icons.email_outlined, controller: _emailController),
        const SizedBox(height: 20),
        _customField("Password", Icons.lock_outline, isPassword: true, controller: _passwordController),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(onPressed: () {}, child: const Text("Forgot?")),
        ),
        const SizedBox(height: 20),
        _primaryButton("Sign In", _handleAuth),
        const SizedBox(height: 20),
        _toggleText("Don't have an account? ", "Register", toggleView),
      ],
    );
  }

  Widget _buildRegisterFields() {
    return Column(
      key: const ValueKey("register"),
      children: [
        _customField("Full Name", Icons.person_outline, controller: _nameController),
        const SizedBox(height: 20),
        _customField("Email Address", Icons.email_outlined, controller: _emailController),
        const SizedBox(height: 20),
        _customField("Create Password", Icons.lock_outline, isPassword: true, controller: _passwordController),
        const SizedBox(height: 10),
        // Password Strength Indicator (Visual only)
        Row(
          children: List.generate(4, (index) => Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: index < 2 ? Colors.orange : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          )),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text("Weak password", style: TextStyle(fontSize: 12, color: Colors.orange)),
        ),
        const SizedBox(height: 30),
        _primaryButton("Create Account", _handleAuth),
        const SizedBox(height: 20),
        _toggleText("Already have an account? ", "Login", toggleView),
      ],
    );
  }

  Widget _customField(String hint, IconData icon, {bool isPassword = false, TextEditingController? controller}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF6366F1)),
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
      ),
    );
  }

  Widget _primaryButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E1B4B),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }

  Widget _toggleText(String desc, String action, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: RichText(
        text: TextSpan(
          text: desc,
          style: const TextStyle(color: Colors.grey),
          children: [
            TextSpan(text: action, style: const TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(size.width / 4, size.height, size.width / 2, size.height - 20);
    path.quadraticBezierTo(size.width * 3 / 4, size.height - 40, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> old) => false;
}