///=============================================================================
/// @author sangnd
/// @date 14/09/2021
/// Quiz Card
///=============================================================================
import 'package:flutter/material.dart';
import 'package:quiz_maker_app/services/database.dart';
import 'package:quiz_maker_app/styles/constants.dart';
import 'package:quiz_maker_app/views/play_quiz.dart';

/// The information of each quiz is got here and displayed as a clickable card
/// When user click a quiz card, navigate to [PlayQuiz]
class QuizCard extends StatelessWidget {
  final String userId;
  final String imageUrl;
  final String title;
  final String description;
  final String quizId;

  QuizCard(
      {required this.userId,
      required this.imageUrl,
      required this.title,
      required this.description,
      required this.quizId});

  final DatabaseService databaseService = new DatabaseService();

  /// Show a alert dialog to delete a quiz when
  /// the user has a long press on the quiz card
  deleteQuiz(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Delete this quiz?"),
            content: Text("This action cannot be undone."),
            actions: <Widget>[
              TextButton(
                  child: Text("NO"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.black87,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                onPressed: () {
                  databaseService.deleteQuizData(userId, quizId);
                  Navigator.pop(context);
                },
                child: Text("DELETE"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlayQuiz(
                      quizId: quizId,
                      userId: userId,
                      quizTitle: title,
                    )));
      },
      onLongPress: () {
        deleteQuiz(context);
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
                image: imageUrl,
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
                      title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      description,
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
