///=============================================================================
/// @author sangnd
/// @date 29/08/2021
/// This file helps to create a quiz, uploads quiz info to Firestore
/// The user will upload overall information quiz first, and add questions
/// in [AddQuestion]
///=============================================================================
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quiz_maker_app/services/database.dart';
import 'package:quiz_maker_app/styles/constants.dart';
import 'package:quiz_maker_app/views/add_question.dart';
import 'package:quiz_maker_app/widgets/widgets.dart';
import 'package:random_string/random_string.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class CreateQuiz extends StatefulWidget {
  const CreateQuiz({required Key? key}) : super(key: key);
  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  /// An global key to check input conditions in text fields
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static late String quizId, quizImageUrl, quizTitle, quizDescription;
  final titleController = TextEditingController();
  final descController = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _tappedCreateQuizButton = false;
  var _localeId = '';
// generate a random index based on the list length
// and use it to retrieve the element

  DatabaseService databaseService = new DatabaseService();
  static String userID = DatabaseService().getUserID();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _tappedCreateQuizButton = false;
    });
    quizImageUrl = "";
    quizTitle = "";
    quizDescription = "";
    titleController.addListener(() {
      quizTitle = titleController.text;
      setState(() {});
    });
    descController.addListener(() {
      quizDescription = descController.text;
      setState(() {});
    });
    _speech = stt.SpeechToText();
  }

  /// The function to upload a new quiz info to the database
  createAQuiz() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _tappedCreateQuizButton = true;
      });
      quizId = randomAlphaNumeric(16); // create a random Id
      Map<String, dynamic> quizData = {
        "userID": userID,
        "quizId": quizId,
        "quizImageUrl": quizImageUrl,
        "quizTitle": quizTitle,
        "quizDescription": quizDescription
      };
      showSnackBarLoading(context);
      await databaseService.addQuizData(quizData, quizId).then((value) => {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => AddQuestion(userID, quizId)))
          });

      /// Hide Loading bar
      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      /// Show confirmation
      showGoodMessage(context, "Created quiz space");
    }
  }

  //TODO upload a photo

  /// The UI of the page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        centerTitle: true,
        title: appBarTitle(context),
        backgroundColor: Colors.white,
        elevation: 0.0,
        brightness: Brightness.light,
        actions: <Widget>[
          IconButton(
            tooltip: "Upload a photo",
            onPressed: () {},
            icon: Icon(
              Icons.upload_outlined,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                // Text(kGuideCreateQuiz),
                PreviewQuizCard(
                    quizImageUrl: quizImageUrl,
                    quizTitle: quizTitle,
                    quizDescription: quizDescription),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: titleController,
                  validator: (val) =>
                      val!.isEmpty ? "Quiz title must not empty" : null,
                  decoration: InputDecoration(
                    hintText: "Quiz title",
                    suffixIcon: titleController.text.isEmpty
                        ? IconButton(
                            onPressed: () => _listen("quizTitle"),
                            icon: Icon(_isListening
                                ? Icons.mic
                                : Icons.mic_none_rounded),
                          )
                        : IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => titleController.clear(),
                          ),
                  ),
                  // onChanged: (val) {
                  //   quizTitle = val;
                  //   print(quizTitle);
                  // },
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: descController,
                  validator: (val) =>
                      val!.isEmpty ? "Quiz description must not empty" : null,
                  decoration: InputDecoration(
                    hintText: "Quiz description",
                    suffixIcon: descController.text.isEmpty
                        ? IconButton(
                            onPressed: () => _listen("quizDesc"),
                            icon: Icon(Icons.mic_none_rounded),
                          )
                        : IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => descController.clear(),
                          ),
                  ),
                  // onChanged: (val) {
                  //   quizDescription = val;
                  // },
                ),
                SizedBox(
                  height: 48,
                ),
                ElevatedButton(
                  onPressed: _tappedCreateQuizButton ? null : createAQuiz,
                  child: Text(
                    "Create quiz",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black87,
                      fixedSize:
                          Size(MediaQuery.of(context).size.width - 48, 54),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                ),
                SizedBox(height: 64),
              ],
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
        var systemLocale = await _speech.systemLocale();
        _localeId = systemLocale.localeId;
        _speech.listen(
          onResult: (val) => setState(() {
            if (label == "quizTitle")
              titleController.text = val.recognizedWords;

            if (label == "quizDesc") descController.text = val.recognizedWords;
          }),
          localeId: _localeId,
          cancelOnError: true,
          partialResults: true,
          onSoundLevelChange: null,
          listenFor: Duration(minutes: 1),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}

class PreviewQuizCard extends StatefulWidget {
  const PreviewQuizCard({
    Key? key,
    required this.quizImageUrl,
    required this.quizTitle,
    required this.quizDescription,
  }) : super(key: key);

  final String quizImageUrl;
  final String quizTitle;
  final String quizDescription;

  @override
  _PreviewQuizCardState createState() => _PreviewQuizCardState();
}

class _PreviewQuizCardState extends State<PreviewQuizCard> {
  // random preview thumbnail
  final _random = new Random();

  @override
  void initState() {
    super.initState();
    getRandomImageUrl();
    _CreateQuizState.quizTitle = "Preview Title";
    _CreateQuizState.quizDescription = "Preview Description";
    print("In preview quiz card: ${_CreateQuizState.quizImageUrl}");
  }

  getRandomImageUrl() {
    var length = DatabaseService.thumbnailAddressList.length;
    print("[----length: $length----]");
    _CreateQuizState.quizImageUrl =
        DatabaseService.thumbnailAddressList[_random.nextInt(length)];
    setState(() {});
    print("[----In preview quiz card: ${_CreateQuizState.quizImageUrl}----]");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        getRandomImageUrl();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        height: 150,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(9.0),
              child: FadeInImage.assetNetwork(
                placeholder: kLoadingImage,
                image: _CreateQuizState.quizImageUrl,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9.0),
                color: Colors.black26,
              ),
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(right: 30, left: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _CreateQuizState.quizTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      _CreateQuizState.quizDescription,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
