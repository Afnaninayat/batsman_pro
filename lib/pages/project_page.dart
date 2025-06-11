import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
      appBar: AppBar(title: const Text("Projects"), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ["To do", "In progress", "Finished"].map((tab) {
                return TextButton(
                  onPressed: () {},
                  child: Text(tab, style: const TextStyle(color: Colors.black)),
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
                  const SizedBox(height: 16),
                  const Text("Nothing here. For now.", style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  ElevatedButton(onPressed: () {}, child: const Text("Upload a Video"))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
