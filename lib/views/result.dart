///=============================================================================
/// @author sangnd
/// @date 29/08/2021
/// The file to show the result page after competing the quiz
///=============================================================================
import 'package:flutter/material.dart';
import 'package:quiz_maker_app/styles/constants.dart';
import 'package:quiz_maker_app/views/play_quiz.dart';

import 'home.dart';

class Results extends StatefulWidget {
  final int correct, incorrect, notAttempted, total;
  final String userId, quizId, quizTitle;

  Results({
    required this.correct,
    required this.incorrect,
    required this.notAttempted,
    required this.total,
    required this.userId,
    required this.quizId,
    required this.quizTitle,
  });

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  /// The UI of the result page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${widget.correct}/${widget.total}",
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "${widget.correct} correct answers \n ${widget.incorrect} incorrect answers \n ${widget.notAttempted} not attempted questions",
                style: TextStyle(
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 14,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                      context, MaterialPageRoute(builder: (context) => Home()));
                },
                child: Text(
                  "Go to Home",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    fixedSize:
                        Size(MediaQuery.of(context).size.width - 100, 54),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
              ),
              SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlayQuiz(
                              quizId: widget.quizId,
                              userId: widget.userId,
                              quizTitle: widget.quizTitle)));
                },
                icon: (Icon(Icons.replay_outlined)),
                label: Text(
                  'Try again',
                  style: TextStyle(fontSize: 16),
                ),
                style: TextButton.styleFrom(
                  minimumSize:
                      Size(MediaQuery.of(context).size.width - 200, 32),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
