import 'package:flutter/material.dart';

void main() {
  runApp(BatsmanProApp());
}

class BatsmanProApp extends StatelessWidget {
  const BatsmanProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Batsman Pro',
      debugShowCheckedModeBanner: false,
      home: OnboardingPage(),
    );
  }
}

// ------------------- 1. Onboarding -------------------
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAF3FF),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Icon(Icons.image, size: 150, color: Colors.grey[400]), // Placeholder
          Spacer(),
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DotIndicator(true),
                    DotIndicator(false),
                    DotIndicator(false),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  "Your Smart Cricket Coach,\nOn the Go.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 12),
                Text(
                  "Train smarter with powerful AI that analyzes every shot, tracks your footwork, and gives you actionable feedback.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
                  },
                  child: Text("Next",
                  style: TextStyle(color: Colors.white),)
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  final bool active;
  const DotIndicator(this.active, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? Colors.blue : Colors.grey[300],
        shape: BoxShape.circle,
      ),
    );
  }
}

// ------------------- 2. Login Page -------------------
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
              child: Image.asset("assets/cricketer.png", fit: BoxFit.cover), // You can replace with placeholder
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ListView(
              children: [
                SizedBox(height: 100),
                Text("Welcome!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                TextField(
                  controller: emailCtrl,
                  decoration: InputDecoration(labelText: "Email Address"),
                ),
                TextField(
                  controller: passCtrl,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Password"),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(onPressed: () {}, child: Text("Forgot password?")),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ProjectPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                    backgroundColor: Colors.blue,
                  ),
                  child: Text("Login",
                  style: TextStyle(color: Colors.white))
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
                TextButton(onPressed: () {}, child: Text("Not a member? Register now")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------- 3. Project Page -------------------
class ProjectPage extends StatelessWidget {
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
      appBar: AppBar(title: Text("Projects"), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ["To do", "In progress", "Finished"].map((tab) {
                return TextButton(
                  onPressed: () {},
                  child: Text(tab, style: TextStyle(color: Colors.black)),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.insert_drive_file, size: 100, color: Colors.grey[300]),
                  SizedBox(height: 16),
                  Text("Nothing here. For now.", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("Start a project"),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------- 4. Home Analytics Page -------------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/video_placeholder.jpg"), // Replace with video
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Icon(Icons.play_circle, size: 64, color: Colors.white),
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircularStat(label: "Shots Played", value: "100", color: Colors.blue),
                  CircularStat(label: "Ball Hitting", value: "89%", color: Colors.orange),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: Text("Show Detail Analytics"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CircularStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const CircularStat({super.key, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                value: 0.75,
                strokeWidth: 8,
                color: color,
              ),
            ),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}

// ------------------- Bottom Navigation -------------------
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  const BottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == 0) Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
        if (index == 1) Navigator.push(context, MaterialPageRoute(builder: (_) => ProjectPage()));
        if (index == 2) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile coming soon!")));
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
        BottomNavigationBarItem(icon: Icon(Icons.folder), label: "Projects"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
