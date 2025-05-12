// lib/screens/result_screen.dart
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  ResultScreen({required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz Completed')),
      body: Center(
        child: Text(
          'Your score is $score',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
