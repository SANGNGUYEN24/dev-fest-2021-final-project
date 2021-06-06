import 'package:flutter/material.dart';
import 'package:quiz_maker_app/services/database.dart';
import 'package:quiz_maker_app/views/add_question.dart';
import 'package:quiz_maker_app/widgets/widgets.dart';
import 'package:random_string/random_string.dart';

class CreateQuiz extends StatefulWidget {
  const CreateQuiz({Key key}) : super(key: key);

  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String quizId, quizImageUrl, quizTitle, quizDescription;
  DatabaseService databaseService = new DatabaseService();

  bool _isLoading = false;

  CreateAQuiz() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      quizId = randomAlphaNumeric(16); // create a random Id
      Map<String, String> quizMap = {
        "quizId": quizId,
        "quizImageUrl": quizImageUrl,
        "quizTitle": quizTitle,
        "quizDescription": quizDescription
      };

      await databaseService.addQuizData(quizMap, quizId).then((value) => {
            setState(() {
              _isLoading = false;
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AddQuestion(quizId)));
            })
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
          : Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    TextFormField(
                      validator: (val) =>
                          val.isEmpty ? "Enter Image URL" : null,
                      decoration: InputDecoration(
                        hintText: "Quiz image URL",
                      ),
                      onChanged: (val) {
                        // TODO: add quiz image URL
                        quizImageUrl = val;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      validator: (val) =>
                          val.isEmpty ? "Quiz title must not empty" : null,
                      decoration: InputDecoration(
                        hintText: "Quiz title",
                      ),
                      onChanged: (val) {
                        // TODO: add quiz image URL
                        quizTitle = val;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      validator: (val) => val.isEmpty
                          ? "Quiz description must not empty"
                          : null,
                      decoration: InputDecoration(
                        hintText: "Quiz description",
                      ),
                      onChanged: (val) {
                        // TODO: add quiz image URL
                        quizDescription = val;
                      },
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                        onTap: () {
                          CreateAQuiz();
                          //AddQuestion(quizId);
                        },
                        child: blueButton(
                            context: context,
                            label: "Create quiz")),
                  ],
                ),
              ),
            ),
    );
  }
}