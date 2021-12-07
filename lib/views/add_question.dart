///=============================================================================
/// @author sangnd
/// @date 29/08/2021
/// This file helps add question data of each quiz to the database
///=============================================================================
import 'package:flutter/material.dart';
import 'package:quiz_maker_app/services/database.dart';
import 'package:quiz_maker_app/styles/constants.dart';
import 'package:quiz_maker_app/widgets/widgets.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AddQuestion extends StatefulWidget {
  final String userId;
  final String quizId;

  AddQuestion(this.userId, this.quizId);
  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  late String question, option1, option2, option3, option4;
  final questionController = TextEditingController();
  final option1Controller = TextEditingController();
  final option2Controller = TextEditingController();
  final option3Controller = TextEditingController();
  final option4Controller = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DatabaseService databaseService = new DatabaseService();
  bool _isLoading = false;
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    questionController.dispose();
    option1Controller.dispose();
    option2Controller.dispose();
    option3Controller.dispose();
    option4Controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    questionController.addListener(() {
      question = questionController.text;
      setState(() {});
    });
    option1Controller.addListener(() {
      option1 = option1Controller.text;
      setState(() {});
    });
    option2Controller.addListener(() {
      option2 = option2Controller.text;
      setState(() {});
    });
    option3Controller.addListener(() {
      option3 = option3Controller.text;
      setState(() {});
    });
    option4Controller.addListener(() {
      option4 = option4Controller.text;
      setState(() {});
    });
    _speech = stt.SpeechToText();
  }

  confirmQuizSubmit() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Submit the quiz?"),
            content: Text("You can edit it later."),
            actions: <Widget>[
              TextButton(
                  child: Text("CANCEL"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.black87,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                onPressed: () {
                  /// Pop first time to hide the AlertDialog
                  Navigator.pop(context);

                  /// upload the question
                  uploadQuestion();

                  /// Pop the second time to go to home page
                  Navigator.pop(context);

                  showGoodMessage(context, "Enjoy your quiz!");

                  /// If the user submit the last question
                  /// but it is not filled full fields, show a message to user
                  if (!(_formKey.currentState!.validate()))
                    showNotGoodMessage(context,
                        "The last question was not uploaded because it was incomplete");
                },
                child: Text("SUBMIT"),
              ),
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
      showGoodMessage(context, "Uploaded question");
    } else {}
  }

  /// Handle back button
  Future<bool> onBackPressed(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Submit before leaving!'),
            content: new Text('Go to home page?'),
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
    return WillPopScope(
      onWillPop: () {
        final popUp = onBackPressed(context);
        return popUp;
      },
      child: Scaffold(
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
                          autofocus: true,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: questionController,
                          validator: (val) =>
                              val!.isEmpty ? "Enter Question" : null,
                          decoration: InputDecoration(
                            hintText: "Question",
                            suffixIcon: questionController.text.isEmpty
                                ? IconButton(
                                    onPressed: () => _listen('question'),
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
                                    onPressed: () => _listen('option 1'),
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
                                    onPressed: () => _listen('option 2'),
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
                                    onPressed: () => _listen('option 3'),
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
                                    onPressed: () => _listen('option 4'),
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
                        OutlinedButton(
                          onPressed: () {
                            uploadQuestion();
                            if (_formKey.currentState!.validate()) clearInput();
                          },
                          child: Text(
                            'Add question',
                            style: TextStyle(fontSize: 16),
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(
                                MediaQuery.of(context).size.width - 100, 54),
                            shape: StadiumBorder(),
                            side: BorderSide(color: kPrimaryColor),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: confirmQuizSubmit,
                          child: Text(
                            "Submit quiz",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.black87,
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
      ),
    );
  }

  void _listen(String label) async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            if (label == "question")
              questionController.text = val.recognizedWords;
            else if (label == "option1")
              option1Controller.text = val.recognizedWords;
            else if (label == "option2")
              option2Controller.text = val.recognizedWords;
            else if (label == "option3")
              option3Controller.text = val.recognizedWords;
            else if (label == "option4")
              option4Controller.text = val.recognizedWords;
          }),
          localeId: 'en_US',
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}
