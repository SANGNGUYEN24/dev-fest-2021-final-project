///=============================================================================
/// @author sangnd
/// @date 29/08/2021
/// This file handles the contents of quizzes' questions
///=============================================================================
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_maker_app/models/quetion_model.dart';
import 'package:quiz_maker_app/services/database.dart';
import 'package:quiz_maker_app/styles/constants.dart';
import 'package:quiz_maker_app/views/result.dart';
import 'package:quiz_maker_app/widgets/quiz_play_widgets.dart';
import 'package:quiz_maker_app/widgets/widgets.dart';

class PlayQuiz extends StatefulWidget {
  final String quizId;
  final String userID;

  PlayQuiz({required this.quizId, required this.userID});

  @override
  _PlayQuizState createState() => _PlayQuizState();
}

int total = 0;
int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;

class _PlayQuizState extends State<PlayQuiz> {
  DatabaseService databaseService = new DatabaseService();
  QuerySnapshot? questionSnapshot;

  /// The function to get the content of questions in the selected quiz
  QuestionModel getQuestionModelFromSnapshot(
      DocumentSnapshot questionSnapshot) {
    QuestionModel questionModel = new QuestionModel();

    questionModel.question = questionSnapshot["question"];
    List<String> options = [
      questionSnapshot["option1"],
      questionSnapshot["option2"],
      questionSnapshot["option3"],
      questionSnapshot["option4"],
    ];

    /// Shuffling all each question's options in a try
    options.shuffle();
    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];
    questionModel.correctOption = questionSnapshot["option1"];
    questionModel.answered = false; // only allows user choose the answer once

    return questionModel;
  }

  /// Set initial values of [_notAttempted], [_correct], and [_incorrect] to 0
  /// [total] to the # of questions of the quiz
  /// When the user click a quiz card, at the beginning, I will get question data of the quiz to display
  /// based on the [quizId] and assigned it to [questionSnapshot] for getting data process
  /// [questionSnapshot] is an instance of _JsonQuerySnapshot object
  @override
  void initState() {
    databaseService.getQuizDataToPlay(widget.quizId).then((value) {
      questionSnapshot = value;
      print('questionSnapshot ---------- $questionSnapshot -----------');
      _correct = 0;
      _incorrect = 0;
      // Get the number of questions
      total = questionSnapshot!.docs.length;
      _notAttempted = total;

      /// print quizId for checking
      print("---------$total questions in quiz Id: ${widget.quizId} --------");
      setState(() {});
    });
    super.initState();
  }

  /// The UI of the page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              questionSnapshot == null

                  /// Display an indicator while loading the data
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )

                  /// Display the question data as a list
                  : ListView.builder(
                      physics: ClampingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      shrinkWrap: true,
                      itemCount: questionSnapshot!.docs.length,
                      itemBuilder: (context, index) {
                        return QuizPlayTile(
                          questionModel: getQuestionModelFromSnapshot(
                              questionSnapshot!.docs[index]),
                          index: index,
                        );
                      }),
            ],
          ),
        ),
      ),

      /// The user will press this button when complete the quiz
      floatingActionButton: FloatingActionButton(
        tooltip: "Submit your answers",
        child: Icon(Icons.check),
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Results(
                        correct: _correct,
                        incorrect: _incorrect,
                        notAttempted: _notAttempted,
                        total: total,
                      )));
        },
      ),
    );
  }
}

/// The class helps display the question content (4 options in a question) and
/// handle the conditions when user choose an option in the question
/// If the user choose a wrong answer, it turn into red, and green if it is correct
/// The user can only choose the answer once
class QuizPlayTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;

  QuizPlayTile({required this.questionModel, required this.index});

  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Q${widget.index + 1}: ${widget.questionModel.question}",
            style: TextStyle(fontSize: 18, color: Colors.black87),
          ),
          SizedBox(
            height: 14,
          ),
          buildGestureDetector(widget.questionModel.option1, "A"),
          SizedBox(
            height: 4,
          ),
          buildGestureDetector(widget.questionModel.option2, "B"),
          SizedBox(
            height: 4,
          ),
          buildGestureDetector(widget.questionModel.option3, "C"),
          SizedBox(
            height: 4,
          ),
          buildGestureDetector(widget.questionModel.option4, "D"),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  /// GestureDetector for each option in each question
  GestureDetector buildGestureDetector(String userChoice, String optionOrder) {
    return GestureDetector(
      onTap: () {
        if (!widget.questionModel.answered) {
          ///correct
          if (userChoice == widget.questionModel.correctOption) {
            optionSelected = userChoice;
            widget.questionModel.answered = true;
            _correct += 1;
            _notAttempted -= 1;
            setState(() {});
          } else {
            optionSelected = userChoice;
            widget.questionModel.answered = true;
            _incorrect += 1;
            _notAttempted -= 1;
            setState(() {});
          }
        }
      },
      child: OptionTile(
        correctAnswer: widget.questionModel.correctOption,
        description: userChoice,
        option: optionOrder,
        optionSelected: optionSelected,
      ),
    );
  }
}
