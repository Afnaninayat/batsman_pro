import 'package:flutter/material.dart';
import 'pages/onboarding_page.dart';

void main() {
  runApp(const BatsmanProApp());
}

class BatsmanProApp extends StatelessWidget {
  const BatsmanProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Batsman Pro',
      debugShowCheckedModeBanner: false,
      home: const OnboardingPage(),
    );
  }
}