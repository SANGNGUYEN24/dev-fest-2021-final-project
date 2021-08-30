///=============================================================================
/// @author sangnd
/// @date 29/08/2021
/// The file to show the result page after competing the quiz
///=============================================================================
import 'package:flutter/material.dart';
import 'package:quiz_maker_app/widgets/widgets.dart';

class Results extends StatefulWidget {
  final int correct, incorrect, total;

  Results(
      {required this.total, required this.correct, required this.incorrect});

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  /// The UI of the result page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                "${widget.correct} correct answers and ${widget.incorrect} incorrect answers",
                style: TextStyle(
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 14,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: blueButton(
                    context: context,
                    label: "Go to Home",
                    buttonWidth: MediaQuery.of(context).size.width - 100),
              )
            ],
          ),
        ),
      ),
    );
  }
}
