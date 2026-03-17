import 'package:flutter/material.dart';
import 'homepage.dart'; 
import 'register_screen.dart';
import 'forget_password.dart';
import 'particle_background.dart'; 

class MyHomeScreen extends StatelessWidget {
  const MyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      body:ParticleBackground(
        child: Center(
          child: SingleChildScrollView(
         child: Container(
              color: const Color.fromARGB(0, 0, 0, 0),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // 2. Email Field
                const _FieldLabel(label: 'Email'),
                const _CustomTextField(
                  hintText: 'Enter your email',
                  isPassword: false,
                  icon: Icons.call_end_outlined, 
              
                ), // TextField ends
                const SizedBox(height: 20),

                // 3. Password Field
                const _FieldLabel(label: 'Password'),
                
                const _CustomTextField(
                  hintText: 'Enter your password',
                  isPassword: true,
                  
                  icon: Icons.lock_outline,
                ), // TextField ends
                Align(
    alignment: Alignment.centerRight,
    child: Padding(
      padding: const EdgeInsets.only(right: 25.0, top: 5.0),
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
          );
        },
        child: const Text(
          'Forgot Password?',
          style: TextStyle(color: Color.fromARGB(255, 20, 0, 0), fontWeight: FontWeight.w600),
        ),
      ),
    ),
  ),
                const SizedBox(height: 20),

                // 4. Login Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A0000),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ), // shape ends
                    ), // styleFrom ends
                    
                    onPressed: () {
                      // Professional Navigation to Homepage
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Homepage()),
                      ); // Navigator ends

                    const   Text ('forget password',);
                         const SizedBox(height: 20);

                    },
                    child: const Text('Login', style: TextStyle(fontSize: 18)),
                  ), // ElevatedButton ends
                ), // Padding ends
                const SizedBox(height: 10),
                    Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Become our family. ",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      ), // TextStyle ends
                    ), // Text ends
                   GestureDetector(
                     onTap: () {
                           // This moves the user to the Register Screen
                         Navigator.push(
                        context,
                           MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      ); // Navigator ends  
                          },
                       child: const Text(
                       "Sign up",
                            style: TextStyle(
                              color: Color(0xFF1A0000), // Matching your theme
                   fontWeight: FontWeight.bold,
           decoration: TextDecoration.underline,
        ),
            ),
            ),
                  ], // Row children end
                ), // Row ends
                
                const SizedBox(height: 10), // Bottom padding

              ], // Column children end
            ), // Column ends
          ), // Padding ends
        ), // SingleChildScrollView ends
      ), // Center ends
     )
   ); // Scaffold ends
  } // Build ends
} // Class ends

// --- Professional Reusable Components ---

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0, bottom: 8.0),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ), // Text ends
      ), // Padding ends
    ); // Align ends
  }
}

class _CustomTextField extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final IconData icon; // 1. Define the variable once here

  const _CustomTextField({
    required this.hintText,
    required this.isPassword, 
    required this.icon, // 2. Pass it into the constructor here
  });

@override
  State<_CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<_CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    // Initialize text visibility based on if it's a password field
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        obscureText: _obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(widget.icon, color: const Color(0xFF1A0000)),
          border: const OutlineInputBorder(),
          suffixIcon: widget.isPassword 
            ? IconButton(
                icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              ) 
            : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          hintText: widget.hintText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40.0),
            borderSide: const BorderSide(color: Color.fromARGB(255, 0, 14, 0), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40.0),
            borderSide: const BorderSide(color: Color.fromARGB(255, 223, 226, 223), width: 2),
          ),
        ),
      ),
    );
  }
}
      