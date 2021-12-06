import 'package:flutter/material.dart';

class SharedQuiz extends StatelessWidget {
  const SharedQuiz({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quizzes shared to you"),
      ),
    );
  }
}
