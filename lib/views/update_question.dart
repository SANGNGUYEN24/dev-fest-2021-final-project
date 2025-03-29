///=============================================================================
/// @author duc.nv
/// @date 07/12/2021
/// This file helps update question data of each quiz to the database
///=============================================================================
import 'package:flutter/material.dart';
import 'package:quiz_maker_app/models/question.dart';
import 'package:quiz_maker_app/services/database.dart';
import 'package:quiz_maker_app/styles/constants.dart';
import 'package:quiz_maker_app/widgets/widgets.dart';

class UpdateQuestion extends StatefulWidget {
  final String userId;
  final String quizId;
  final String questionId;
  final QuestionModel questionModel;

  UpdateQuestion(this.userId, this.quizId, this.questionId, this.questionModel);
  @override
  _UpdateQuestionState createState() => _UpdateQuestionState();
}

class _UpdateQuestionState extends State<UpdateQuestion> {
  late String question, option1, option2, option3, option4;
  final questionController = TextEditingController();
  final option1Controller = TextEditingController();
  final option2Controller = TextEditingController();
  final option3Controller = TextEditingController();
  final option4Controller = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DatabaseService databaseService = new DatabaseService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    questionController.addListener(() => setState(() {}));
    option1Controller.addListener(() => setState(() {}));
    option2Controller.addListener(() => setState(() {}));
    option3Controller.addListener(() => setState(() {}));
    option4Controller.addListener(() => setState(() {}));
  }

  /// Clear all the inputs
  clearInput() {
    questionController.clear();
    option1Controller.clear();
    option2Controller.clear();
    option3Controller.clear();
    option4Controller.clear();
  }

  /// The function to update the question data
  updateQuestion() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      Map<String, dynamic> questionData = {
        "question": question,
        "option1": option1,
        "option2": option2,
        "option3": option3,
        "option4": option4,
      };
      await databaseService
          .updateQuestionData(questionData, widget.quizId, widget.questionId)
          .then((value) {
        setState(() {
          print('updated');
          _isLoading = false;
        });
      });
      showGoodMessage(context, "Question Updated");
    } else {}
  }

  /// Handle back button
  Future<bool> onBackPressed(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Update before leaving!'),
            content: new Text('Go back to quiz?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                onPressed: () => Navigator.of(context).pop(true),
                child: Text("GO BACK"),
              ),
            ],
          ),
        ) ??
        false;
  }

  /// The UI of the page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      // appBar: buildAppBar(context),
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: questionController,
                        validator: (val) =>
                            val!.isEmpty ? "Enter Question" : null,
                        decoration: InputDecoration(
                          hintText: "Question",
                          suffixIcon: questionController.text.isEmpty
                              ? IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.mic_none_rounded),
                                )
                              : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () => questionController.clear(),
                                ),
                        ),
                        onChanged: (val) {
                          question = val;
                        },
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: option1Controller,
                        validator: (val) =>
                            val!.isEmpty ? "Enter option A" : null,
                        decoration: InputDecoration(
                          hintText: "Option A (the correct answer)",
                          suffixIcon: option1Controller.text.isEmpty
                              ? IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.mic_none_rounded),
                                )
                              : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () => option1Controller.clear(),
                                ),
                        ),
                        onChanged: (val) {
                          option1 = val;
                        },
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: option2Controller,
                        validator: (val) =>
                            val!.isEmpty ? "Enter option B" : null,
                        decoration: InputDecoration(
                          hintText: "Option B",
                          suffixIcon: option2Controller.text.isEmpty
                              ? IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.mic_none_rounded),
                                )
                              : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () => option2Controller.clear(),
                                ),
                        ),
                        onChanged: (val) {
                          option2 = val;
                        },
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: option3Controller,
                        validator: (val) =>
                            val!.isEmpty ? "Enter option C" : null,
                        decoration: InputDecoration(
                          hintText: "Option C",
                          suffixIcon: option3Controller.text.isEmpty
                              ? IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.mic_none_rounded),
                                )
                              : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () => option3Controller.clear(),
                                ),
                        ),
                        onChanged: (val) {
                          option3 = val;
                        },
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: option4Controller,
                        validator: (val) =>
                            val!.isEmpty ? "Enter option D" : null,
                        decoration: InputDecoration(
                          hintText: "Option D",
                          suffixIcon: option4Controller.text.isEmpty
                              ? IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.mic_none_rounded),
                                )
                              : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () => option4Controller.clear(),
                                ),
                        ),
                        onChanged: (val) {
                          option4 = val;
                        },
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          updateQuestion();
                          if (_formKey.currentState!.validate()) clearInput();
                        },
                        child: Text(
                          "Update question",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            fixedSize: Size(
                                MediaQuery.of(context).size.width - 100, 54),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                      ),
                      SizedBox(
                        height: 64,
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
