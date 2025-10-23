import 'package:flutter/material.dart';
import '../pages/dashboard_page.dart';
// import '../pages/home_page.dart';
import '../pages/profile_page.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  const BottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        // if (index == 0) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
        if (index == 1) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardPage()));
        if (index == 2) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
      },
      items: const [
        // BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
        BottomNavigationBarItem(icon: Icon(Icons.folder), label: "Projects"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
