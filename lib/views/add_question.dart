import 'package:flutter/material.dart';
import 'package:quiz_maker_app/services/database.dart';
import 'package:quiz_maker_app/widgets/widgets.dart';

class AddQuestion extends StatefulWidget {
  final String userID;
  final String quizId;

  AddQuestion(this.userID, this.quizId);

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  String question, option1, option2, option3, option4;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DatabaseService databaseService = new DatabaseService();
  bool _isLoading = false;

  uploadQuestion() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      Map<String, String> questionData = {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black87),
        brightness: Brightness.light,
      ),
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val) =>
                            val.isEmpty ? "Enter Question" : null,
                        decoration: InputDecoration(
                          hintText: "Question",
                        ),
                        onChanged: (val) {
                          question = val;
                        },
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      TextFormField(
                        validator: (val) =>
                            val.isEmpty ? "Enter option 1" : null,
                        decoration: InputDecoration(
                          hintText: "Option 1",
                        ),
                        onChanged: (val) {
                          option1 = val;
                        },
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      TextFormField(
                        validator: (val) =>
                            val.isEmpty ? "Enter option 2" : null,
                        decoration: InputDecoration(
                          hintText: "Option 2",
                        ),
                        onChanged: (val) {
                          option2 = val;
                        },
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      TextFormField(
                        validator: (val) =>
                            val.isEmpty ? "Enter option 3" : null,
                        decoration: InputDecoration(
                          hintText: "Option 3",
                        ),
                        onChanged: (val) {
                          option3 = val;
                        },
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      TextFormField(
                        validator: (val) =>
                            val.isEmpty ? "Enter option 4" : null,
                        decoration: InputDecoration(
                          hintText: "Option 4",
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
                          uploadQuestion();
                          Navigator.pop(context);
                        },
                        child: blueButton(
                          context: context,
                          label: "Submit",
                          buttonWidth: MediaQuery.of(context).size.width - 100,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
