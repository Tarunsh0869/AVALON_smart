import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/user_view.dart';
import 'navigation_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  final _nameCtrl     = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();

  void toggleView() => setState(() => isLogin = !isLogin);

  Future<void> _handleAuth() async {
    final email    = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();
    final name     = _nameCtrl.text.trim();

    if (email.isEmpty || password.isEmpty || (!isLogin && name.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
          child: CircularProgressIndicator(color: Color(0xFF6366F1))),
    );

    try {
      final userVM = context.read<UserViewModel>();
      if (isLogin) {
        await userVM.login(email, password);
      } else {
        await userVM.register(name, email, password);
      }

      if (mounted) {
        Navigator.of(context).pop();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const MainNavigationScreen()));
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildFluidHeader(isLogin ? 'Welcome Back' : 'Create Account'),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                            begin: const Offset(0.1, 0), end: Offset.zero)
                        .animate(animation),
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
                  colors: [Color(0xFF1E1B4B), Color(0xFF6366F1)]),
            ),
          ),
        ),
        Positioned(
          top: 80,
          left: 30,
          child: Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildLoginFields() {
    return Column(
      key: const ValueKey('login'),
      children: [
        _field('Email', Icons.email_outlined, controller: _emailCtrl),
        const SizedBox(height: 20),
        _field('Password', Icons.lock_outline,
            isPassword: true, controller: _passwordCtrl),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(onPressed: () {}, child: const Text('Forgot?')),
        ),
        const SizedBox(height: 20),
        _primaryButton('Sign In', _handleAuth),
        const SizedBox(height: 20),
        _toggleText("Don't have an account? ", 'Register', toggleView),
      ],
    );
  }

  Widget _buildRegisterFields() {
    return Column(
      key: const ValueKey('register'),
      children: [
        _field('Full Name', Icons.person_outline, controller: _nameCtrl),
        const SizedBox(height: 20),
        _field('Email Address', Icons.email_outlined, controller: _emailCtrl),
        const SizedBox(height: 20),
        _field('Create Password', Icons.lock_outline,
            isPassword: true, controller: _passwordCtrl),
        const SizedBox(height: 30),
        _primaryButton('Create Account', _handleAuth),
        const SizedBox(height: 20),
        _toggleText('Already have an account? ', 'Login', toggleView),
      ],
    );
  }

  Widget _field(String hint, IconData icon,
      {bool isPassword = false, TextEditingController? controller}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF6366F1)),
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade200)),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
            TextSpan(
                text: action,
                style: const TextStyle(
                    color: Color(0xFF6366F1), fontWeight: FontWeight.bold)),
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
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height - 20);
    path.quadraticBezierTo(
        size.width * 3 / 4, size.height - 40, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> old) => false;
}
