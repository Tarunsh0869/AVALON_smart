import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      // --- UPDATED APPBAR ---
     
     
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 120, // Increased height to fit both lines of text comfortably
        automaticallyImplyLeading: false, // Removes the default unaligned button
        title: Padding(
          padding: const EdgeInsets.only(left: 15, top: 10), 
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center, // Aligns arrow with the top line
            children: [
              // 1. Perfectly Aligned Back Button
              IconButton(
                padding: EdgeInsets.zero, // Removes default padding
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.arrow_back, color: Colors.black, size: 25),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 20),

              // 2. The Text Column (Title + Subtitle)
              const Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Join Clubera",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Let's get you joined into our app.",
                      style: TextStyle(
                        fontSize: 15, 
                        color: Colors.grey, 
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15), // Small gap after AppBar
            
            const SizedBox(height: 30),

            // Text Fields
            const _CustomTextField(hintText: "Enter your full name", icon: Icons.person_outline),
            const SizedBox(height: 15),
            const _CustomTextField(hintText: "Enter your mobile number", icon: Icons.phone_outlined),
            const SizedBox(height: 15),
            const _CustomTextField(hintText: "Enter your email address", icon: Icons.email_outlined),
            const SizedBox(height: 15),
            const _CustomTextField(hintText: "Enter your full address", icon: Icons.home_outlined),
            const SizedBox(height: 15),
            
            // Password Fields
            const _CustomTextField(hintText: "Create a password", icon: Icons.lock_outline, isPassword: true),
            const SizedBox(height: 15),
            const _CustomTextField(hintText: "Confirm password", icon: Icons.lock_outline, isPassword: true),
            const SizedBox(height: 15),
            const _CustomTextField(hintText: "Designation  ", icon: Icons.badge_outlined),
            
            
             const SizedBox(height: 15),
            _CustomDropdown(hintText: "Select center ",  
            icon: Icons.location_on_outlined,
              options: const[  "Meerut",
                  "Dehradun Subharti",
                  "Lokpriya",]
                  ,
            onChanged: (value) {

        print("User picked: $value");
             }    
  ),
                
            const SizedBox(height: 15),
            _CustomDropdown(hintText: "Select center first",  
            icon: Icons.school_outlined,
            options: const ["Student", "Faculty", "Staff", "Other"],
            onChanged: (value) {
  
        print("User picked: $value");
             }    
  ),
                
                
                const SizedBox(height: 15),
            
            
         _CustomDropdown(hintText: "Select college first", icon: Icons.apartment,
            options: const [
           "Meerut",
            "Dehradun Subharti",
            "Lokpriya",
          ],
          onChanged: (value) {
      // value will be "Meerut", etc.
        print("User picked: $value");
      },
     ),

            const SizedBox(height: 30),

        SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  // Add registration logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text("Register", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),

            // Footer
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? ", style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text("Login Now", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
class _CustomTextField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final bool isPassword;

  const _CustomTextField({required this.hintText, required this.icon, this.isPassword = false});

  @override
  State<_CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<_CustomTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: widget.isPassword ? _obscure : false,
      decoration: InputDecoration(
        prefixIcon: Icon(widget.icon, color: Colors.grey),
        suffixIcon: widget.isPassword 
          ? IconButton(
              icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
              onPressed: () => setState(() => _obscure = !_obscure))
          : null,
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 5, 8), width: 1.5),
        ),
      ),
    );
  }
}

class _CustomDropdown extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final List<String> options; // New: List of items to scroll through
  final Function(String?)? onChanged; // New: Callback for selection

  const _CustomDropdown({
    required this.hintText, 
    required this.icon, 
    this.options = const [], 
    this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      menuMaxHeight: 300,
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(20),

      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 6, 10), width: 1.5),
        ),
      ),
      hint: Text(
        hintText, 
        style: const TextStyle(color: Colors.grey, fontSize: 16),
        overflow: TextOverflow.ellipsis, // Adds ... if text is too long
      ),
      items: options.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value, 
            style: const TextStyle(color: Colors.black87, fontSize: 16),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}