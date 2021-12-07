///=============================================================================
/// @author sangnd
/// @date 29/08/2021
/// This file handles the contents of quizzes' questions
///=============================================================================
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_maker_app/models/question.dart';
import 'package:quiz_maker_app/services/database.dart';
import 'package:quiz_maker_app/styles/constants.dart';
import 'package:quiz_maker_app/views/result.dart';
import 'package:quiz_maker_app/widgets/quiz_play_widgets.dart';
import 'package:quiz_maker_app/widgets/widgets.dart';

import 'add_question.dart';
import 'update_question.dart';
import 'home.dart';

class PlayQuiz extends StatefulWidget {
  final String userId;
  final String quizId;
  final String quizTitle;

  PlayQuiz(
      {required this.userId, required this.quizId, required this.quizTitle});

  @override
  _PlayQuizState createState() => _PlayQuizState();
}

int total = 0;
int correct = 0;
int incorrect = 0;
int notAttempted = 0;

class _PlayQuizState extends State<PlayQuiz> {
  DatabaseService databaseService = new DatabaseService();
  QuerySnapshot? questionSnapshot;
  late List<QueryDocumentSnapshot<Object?>> docs;
  late String quizTitle;

  /// Set initial values of [notAttempted], [correct], and [incorrect] to 0
  /// [total] to the # of questions of the quiz
  /// When the user click a quiz card, at the beginning, I will get question data of the quiz to display
  /// based on the [quizId] and assigned it to [questionSnapshot] for getting data process
  /// [questionSnapshot] is an instance of _JsonQuerySnapshot object
  ///
  /// Firstly, shuffle all the documents in the question data collection
  /// Second, shuffle all the options in that documents
  @override
  void initState() {
    setState(() {
      quizTitle = widget.quizTitle;
      print("[----quizTitle: $quizTitle----]");
    });

    databaseService
        .getQuizDataToPlay(userId: widget.userId, quizId: widget.quizId)
        .then((value) {
      questionSnapshot = value;
      correct = 0;
      incorrect = 0;

      /// Get the number of questions
      total = questionSnapshot!.docs.length;
      notAttempted = total;

      /// Shuffle all the questions (documents) in the quiz
      docs = questionSnapshot!.docs..shuffle();

      /// print quizId for checking
      print(
          "[----userId: ${widget.userId} ----> quizId: ${widget.quizId} has $total questions----]");
      setState(() {});
    });
    super.initState();
  }

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
  // TODO edit quiz

  Future<bool> _onBackPressed(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('You are doing quiz...'),
            content: new Text('Going back cause progress losing'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Home()));
                },
                child: Text("GO HOME"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.black87,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                onPressed: () => {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Results(
                                correct: correct,
                                incorrect: incorrect,
                                notAttempted: notAttempted,
                                total: total,
                                userId: widget.userId,
                                quizId: widget.quizId,
                                quizTitle: quizTitle,
                              )))
                },
                child: Text("SUMMIT"),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        break;

      /// Add a question
      case 1:
        {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddQuestion(widget.userId, widget.quizId)));
          break;
        }
    }
  }

  /// The UI of the page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
        centerTitle: true,
        title: Text(quizTitle,
            style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontStyle: FontStyle.italic)),
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: <Widget>[
          PopupMenuButton<int>(
              onSelected: (item) => _onSelected(context, item),
              itemBuilder: (context) => [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Row(
                        children: [
                          Icon(Icons.edit_rounded),
                          SizedBox(
                            width: 8,
                          ),
                          Text("Edit this quiz")
                        ],
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: Row(
                        children: [
                          Icon(Icons.add_rounded),
                          SizedBox(
                            width: 8,
                          ),
                          Text("Add a question for this quiz")
                        ],
                      ),
                    ),
                  ]),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: questionSnapshot == null

              /// Display an indicator while loading the data
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )

              /// Display the question data as a list
              /// Check is there at least one question in the quiz
              : docs.length == 0
                  ? Container(
                      height: MediaQuery.of(context).size.height - 200,
                      child: Center(
                        child: Text(
                          "Your quiz needs a question \n Just as much as you need a lover 🙄",
                          textAlign: TextAlign.center,
                        ),
                      ))
                  : ListView.builder(
                      physics: ClampingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      shrinkWrap: true,
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        return QuizPlayTile(
                            questionModel:
                                getQuestionModelFromSnapshot(docs[index]),
                            index: index,
                            questionId: docs[index].id,
                            userId: widget.userId,
                            quizId: widget.quizId);
                      }),
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
                        correct: correct,
                        incorrect: incorrect,
                        notAttempted: notAttempted,
                        total: total,
                        userId: widget.userId,
                        quizId: widget.quizId,
                        quizTitle: quizTitle,
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
  final String userId;
  final String quizId;
  final String questionId;

  QuizPlayTile({
    required this.questionModel,
    required this.index,
    required this.questionId,
    required this.userId,
    required this.quizId,
  });

  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected = "";
  DatabaseService databaseService = new DatabaseService();

  String newQuestion = "";
  String newOption1 = "";
  String newOption2 = "";
  String newOption3 = "";
  String newOption4 = "";

  // void _showModalBottomSheetMenu() {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (builder) {
  //         // return new Container(
  //         //   height: 350.0,
  //         // color: Colors.transparent, //could change this to Color(0xFF737373),
  //         //so you don't have to change MaterialApp canvasColor
  //         return new Container(
  //           height: 300.0,
  //           decoration: new BoxDecoration(
  //               color: Colors.red,
  //               borderRadius: new BorderRadius.only(
  //                   topLeft: const Radius.circular(30.0),
  //                   topRight: const Radius.circular(30.0))),
  //           child: new Center(
  //             child: new Text("This is a modal sheet"),
  //           ),
  //         );
  //         // });
  //       });
  // }

  Future<bool> showUpdateDialog(BuildContext context, String quizId,
      String questionId, QuestionModel questionModel) async {
    return await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Update question'),
            content: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: Form(
                  child: Wrap(
                children: [
                  Text("Question"),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextFormField(
                    initialValue: widget.questionModel.question,
                    onChanged: (value) {
                      newQuestion = value;
                    },
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text("Option 1"),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      newOption1 = value;
                    },
                    initialValue: widget.questionModel.option1,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text("Option 2"),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      newOption2 = value;
                    },
                    initialValue: widget.questionModel.option2,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text("Option 3"),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      newOption3 = value;
                    },
                    initialValue: widget.questionModel.option3,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text("Option 4"),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      newOption4 = value;
                    },
                    initialValue: widget.questionModel.option4,
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                ],
              )),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("CANCEL"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.black87,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                onPressed: () {
                  Navigator.of(context).pop(true);

                  /// Pop to hide the dialog
                  Navigator.pop(context);

                  /// Update title and description
                  Map<String, String> newQuestionData = {
                    "question": newQuestion == ""
                        ? widget.questionModel.question
                        : newQuestion,
                    "option1": newOption1 == ""
                        ? widget.questionModel.option1
                        : newOption1,
                    "option2": newOption2 == ""
                        ? widget.questionModel.option2
                        : newOption2,
                    "option3": newOption3 == ""
                        ? widget.questionModel.option3
                        : newOption3,
                    "option4": newOption4 == ""
                        ? widget.questionModel.option4
                        : newOption4,
                  };
                  print("newQuizName: $newQuestionData");

                  databaseService.updateQuestionData(
                      newQuestionData, widget.quizId, widget.questionId);

                  /// Show confirmation
                  showGoodMessage(context, "Update question successfully");
                },
                child: Text("UPDATE"),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> showDeleteDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure to delete this question?'),
        content: new Text('This action cannot be undone.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.black87,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
            onPressed: () async {
              await databaseService.deleteQuestionData(
                  widget.quizId, widget.questionId);
              Navigator.of(context).pop(true);
              showGoodMessage(context, "Question Deleted!");
            },
            child: Text("DELETE"),
          ),
        ],
      ),
    );
  }

  // Show a bottom sheet with options
  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(
                Icons.auto_stories,
                color: kPrimaryColor,
              ),
              title: Text(
                "Q${widget.index + 1}/$total: ${widget.questionModel.question}",
              ),
            ),
            Divider(
              thickness: 1.0,
            ),
            ListTile(
              onTap: () {
                /// Hide the bottom sheet
                Navigator.pop(context);
                showUpdateDialog(
                  context,
                  widget.quizId,
                  widget.questionId,
                  widget.questionModel,
                );
              },
              leading: Icon(
                Icons.edit,
                color: kPrimaryColor,
              ),
              title: Text('Edit question'),
            ),
            ListTile(
              onTap: () async {
                final bool shouldCloseModal = await showDeleteDialog(context);
                shouldCloseModal ? Navigator.of(context).pop() : null;
              },
              leading: Icon(
                Icons.delete,
                color: kPrimaryColor,
              ),
              title: Text('Delete question'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(9.0),
              highlightColor: Colors.transparent,
              splashColor: Colors.black26,
              radius: 1000.0,
              onLongPress: () {
                showBottomSheet(context);
              },
              child: Text(
                "Q${widget.index + 1}/$total: ${widget.questionModel.question}",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold),
              ),
            ),
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
  Widget buildGestureDetector(String userChoice, String optionOrder) {
    return InkWell(
      borderRadius: BorderRadius.circular(10.0),
      onTap: () {
        if (!widget.questionModel.answered) {
          /// The users can answer many times they want but only count
          /// correct, incorrect at the first time
          if (userChoice == widget.questionModel.correctOption) {
            optionSelected = userChoice;
            if (widget.questionModel.answered != true) {
              widget.questionModel.answered = true;
              correct += 1;
            }
          } else {
            optionSelected = userChoice;
            if (widget.questionModel.answered != true) {
              widget.questionModel.answered = true;
              incorrect += 1;
            }
          }
          notAttempted -= 1;
          setState(() {});
        } else {
          if (userChoice == widget.questionModel.correctOption) {
            optionSelected = userChoice;
          } else {
            optionSelected = userChoice;
          }
          setState(() {});
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
