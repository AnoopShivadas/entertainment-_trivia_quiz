// lib/screens/quiz_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/question.dart';
import '../helpers/db_helper.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'result_screen.dart';
class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> _questions = [];
  int _currentIndex = 0;
  int _score = 0;

  // Load questions from the JSON asset
  Future<void> loadQuestions() async {
    final String jsonString = await rootBundle.loadString('assets/questions.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    setState(() {
      _questions = jsonData.map((item) => Question.fromJson(item)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  void _answerQuestion(String answer) async {
    // Check the answer and update score
    if (answer == _questions[_currentIndex].answer) {
      _score++;
    }
    // Move to next question or end quiz
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      // Quiz finished: save score to SQLite and go to result screen
      if(!kIsWeb){
        await DBHelper().insertScore(_score);
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(score: _score),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // If questions haven't loaded yet, show a loading indicator
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Quiz')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Display current question and options
    Question current = _questions[_currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentIndex + 1}/${_questions.length}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Question text
            Text(
              current.question,
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20),
            // Options as buttons
            ...current.options.map((option) {
              return Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 5.0),
                child: ElevatedButton(
                  child: Text(option),
                  onPressed: () => _answerQuestion(option),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
