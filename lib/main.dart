import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/splash_screen.dart';
import 'firebase_options.dart';
import 'theme.dart'; // ✅ Add this import

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
      theme: AppTheme.theme, // ✅ Use your new golden theme here
      home: const SplashScreen(),
    );
  }
}
