import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/circular_stat.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage("assets/video_placeholder.jpg"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Icon(Icons.play_circle, size: 64, color: Colors.white),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  CircularStat(label: "Shots Played", value: "100", color: Colors.blue),
                  CircularStat(label: "Ball Hitting", value: "89%", color: Colors.orange),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: () {}, child: const Text("Show Detail Analytics")),
            ],
          ),
        ),
      ),
    );
  }
}
