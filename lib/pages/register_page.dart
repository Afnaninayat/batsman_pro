import 'package:flutter/material.dart';
import 'project_page.dart'; // Navigate to projects after registration

class RegisterPage extends StatelessWidget {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  final TextEditingController confirmCtrl = TextEditingController();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.asset("assets/cricketer.png", fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ListView(
              children: [
                SizedBox(height: 80),
                Text("Create Account", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(labelText: "Full Name"),
                ),
                TextField(
                  controller: emailCtrl,
                  decoration: InputDecoration(labelText: "Email Address"),
                ),
                TextField(
                  controller: passCtrl,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Password"),
                ),
                TextField(
                  controller: confirmCtrl,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Confirm Password"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Simple validation
                    if (passCtrl.text != confirmCtrl.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Passwords do not match")),
                      );
                      return;
                    }
                    // Proceed to next screen or handle registration logic
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ProjectPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                    backgroundColor: Colors.blue,
                  ),
                  child: Text("Register", style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 12),
                Center(child: Text("Or continue with")),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.g_mobiledata, size: 40)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.facebook, size: 30)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.apple, size: 30)),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
