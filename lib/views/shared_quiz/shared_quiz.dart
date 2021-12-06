import 'package:flutter/material.dart';

import 'body.dart';

class SharedQuiz extends StatelessWidget {
  const SharedQuiz({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Quizzes shared to you"),
      ),
      body: Body(),
    );
  }
}
