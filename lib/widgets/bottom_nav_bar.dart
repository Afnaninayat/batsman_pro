import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/project_page.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  const BottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == 0) Navigator.push(context, MaterialPageRoute(builder: (_) => const HomePage()));
        if (index == 1) Navigator.push(context, MaterialPageRoute(builder: (_) => const ProjectPage()));
        if (index == 2) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile coming soon!")));
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
        BottomNavigationBarItem(icon: Icon(Icons.folder), label: "Projects"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
