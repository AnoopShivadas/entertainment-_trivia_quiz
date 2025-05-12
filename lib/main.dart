// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/quiz_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures binding for async operations
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Entertainment Trivia Quiz',
      theme: ThemeData(primarySwatch: Colors.red),
      home: QuizScreen(),
    );
  }
}
