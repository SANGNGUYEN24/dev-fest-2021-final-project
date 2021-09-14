///=============================================================================
/// @author sangnd
/// @date 29/08/2021
/// This file helps add question data of each quiz to the database
///=============================================================================
import 'package:flutter/material.dart';
import 'package:quiz_maker_app/services/database.dart';
import 'package:quiz_maker_app/styles/constants.dart';
import 'package:quiz_maker_app/widgets/widgets.dart';

class AddQuestion extends StatefulWidget {
  final String userID;
  final String quizId;

  AddQuestion(this.userID, this.quizId);
  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  late String question, option1, option2, option3, option4;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DatabaseService databaseService = new DatabaseService();
  bool _isLoading = false;
  final questionController = TextEditingController();
  final option1Controller = TextEditingController();
  final option2Controller = TextEditingController();
  final option3Controller = TextEditingController();
  final option4Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    questionController.addListener(() => setState(() {}));
    option1Controller.addListener(() => setState(() {}));
    option2Controller.addListener(() => setState(() {}));
    option3Controller.addListener(() => setState(() {}));
    option4Controller.addListener(() => setState(() {}));
  }

  confirmQuizSubmit() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title:
                Text("Do you want to submit the quiz? You can edit it later."),
            actions: <Widget>[
              TextButton(
                  child: Text("CANCEL"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              ElevatedButton(
                  child: Text("SUBMIT"),
                  onPressed: () {
                    uploadQuestion();

                    /// Pop first time to hide the AlertDialog
                    Navigator.pop(context);

                    /// Check if the fields has inputs or not
                    if (_formKey.currentState!.validate())

                      /// Pop the second time to go to home page
                      Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  /// Clear all the inputs
  clearInput() {
    questionController.clear();
    option1Controller.clear();
    option2Controller.clear();
    option3Controller.clear();
    option4Controller.clear();
  }

  /// The function to upload the question data
  uploadQuestion() async {
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
          .addQuestionData(questionData, widget.quizId)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  /// The UI of the page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: buildAppBar(context),
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
                              ? Container(width: 0)
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
                            val!.isEmpty ? "Enter option 1" : null,
                        decoration: InputDecoration(
                          hintText: "Option 1 (the correct answer)",
                          suffixIcon: option1Controller.text.isEmpty
                              ? Container(width: 0)
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
                            val!.isEmpty ? "Enter option 2" : null,
                        decoration: InputDecoration(
                          hintText: "Option 2",
                          suffixIcon: option2Controller.text.isEmpty
                              ? Container(width: 0)
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
                            val!.isEmpty ? "Enter option 3" : null,
                        decoration: InputDecoration(
                          hintText: "Option 3",
                          suffixIcon: option3Controller.text.isEmpty
                              ? Container(width: 0)
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
                            val!.isEmpty ? "Enter option 4" : null,
                        decoration: InputDecoration(
                          hintText: "Option 4",
                          suffixIcon: option4Controller.text.isEmpty
                              ? Container(width: 0)
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
                      GestureDetector(
                        onTap: () {
                          uploadQuestion();
                          clearInput();
                        },
                        child: outlinedButton(
                            context: context,
                            label: "Add question",
                            buttonWidth:
                                MediaQuery.of(context).size.width - 100),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          confirmQuizSubmit();
                          //Navigator.pop(context);
                        },
                        child: blackButton(
                          context: context,
                          label: "Submit",
                          buttonWidth: MediaQuery.of(context).size.width - 100,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
