import 'package:flutter/material.dart';
import '../pages/project_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  LoginPage({super.key});

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
                const SizedBox(height: 100),
                const Text("Welcome!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email Address")),
                TextField(controller: passCtrl, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(onPressed: () {}, child: const Text("Forgot password?")),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ProjectPage()));
                  },
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48), backgroundColor: Colors.blue),
                  child: const Text("Login", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 12),
                const Center(child: Text("Or continue with")),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.g_mobiledata, size: 40),
                    Icon(Icons.facebook, size: 30),
                    Icon(Icons.apple, size: 30),
                  ],
                ),
                TextButton(onPressed: () {}, child: const Text("Not a member? Register now")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
