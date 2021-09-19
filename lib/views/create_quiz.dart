///=============================================================================
/// @author sangnd
/// @date 29/08/2021
/// This file helps to create a quiz, uploads quiz info to Firestore
/// The user will upload overall information quiz first, and add questions
/// in [AddQuestion]
///=============================================================================
import 'package:flutter/material.dart';
import 'package:quiz_maker_app/services/database.dart';
import 'package:quiz_maker_app/styles/constants.dart';
import 'package:quiz_maker_app/views/add_question.dart';
import 'package:quiz_maker_app/widgets/widgets.dart';
import 'package:random_string/random_string.dart';

/// TODO handle the case user multiple click the button 'create quiz

class CreateQuiz extends StatefulWidget {
  const CreateQuiz({required Key? key}) : super(key: key);
  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  /// An global key to check input conditions in text fields
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String quizId, quizImageUrl, quizTitle, quizDescription;
  final imageController = TextEditingController();
  final titleController = TextEditingController();
  final descController = TextEditingController();
  DatabaseService databaseService = new DatabaseService();
  String userID = DatabaseService().getUserID();

  @override
  void initState() {
    super.initState();
    imageController.addListener(() => setState(() {}));
    titleController.addListener(() => setState(() {}));
    descController.addListener(() => setState(() {}));
  }

  /// The function to upload a new quiz info to the database
  createAQuiz() async {
    if (_formKey.currentState!.validate()) {
      setState(() {});
      quizId = randomAlphaNumeric(16); // create a random Id
      Map<String, dynamic> quizData = {
        "userID": userID,
        "quizId": quizId,
        "quizImageUrl": quizImageUrl,
        "quizTitle": quizTitle,
        "quizDescription": quizDescription
      };

      await databaseService.addQuizData(quizData, quizId).then((value) => {
            setState(() {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddQuestion(userID, quizId)));
            })
          });
    }
  }

  /// The UI of the page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: imageController,
                  validator: (val) => val!.isEmpty ? "Enter Image URL" : null,
                  decoration: InputDecoration(
                    hintText: "Quiz image URL",
                    suffixIcon: imageController.text.isEmpty
                        ? Container(width: 0)
                        : IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => imageController.clear(),
                          ),
                  ),
                  onChanged: (val) {
                    quizImageUrl = val;
                  },
                ),
                SizedBox(
                  height: 6,
                ),
                TextFormField(
                  controller: titleController,
                  validator: (val) =>
                      val!.isEmpty ? "Quiz title must not empty" : null,
                  decoration: InputDecoration(
                    hintText: "Quiz title",
                    suffixIcon: titleController.text.isEmpty
                        ? Container(width: 0)
                        : IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => titleController.clear(),
                          ),
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
                  controller: descController,
                  validator: (val) =>
                      val!.isEmpty ? "Quiz description must not empty" : null,
                  decoration: InputDecoration(
                    hintText: "Quiz description",
                    suffixIcon: descController.text.isEmpty
                        ? Container(width: 0)
                        : IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => descController.clear(),
                          ),
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
                      createAQuiz();
                    },
                    child: blackButton(context: context, label: "Create quiz")),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
