import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/onboarding_page.dart';
import 'firebase_options.dart'; // Auto-generated via `flutterfire configure`

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const BatsmanProApp());
}

class BatsmanProApp extends StatelessWidget {
  const BatsmanProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Batsman Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const OnboardingPage(),
    );
  }
}