///=============================================================================
/// @author sangnd
/// @date 14/09/2021
/// Quiz Card
///=============================================================================
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:quiz_maker_app/services/database.dart';
import 'package:quiz_maker_app/styles/constants.dart';
import 'package:quiz_maker_app/views/play_quiz.dart';
import 'package:quiz_maker_app/widgets/widgets.dart';
import 'package:share/share.dart';

/// The information of each quiz is got here and displayed as a clickable card
/// When user click a quiz card, navigate to [PlayQuiz]
class QuizCard extends StatelessWidget {
  //final QuizModel quizModel;
  final String userId;
  final String quizImageUrl;
  final String quizTitle;
  final String quizDescription;
  final String quizId;

  QuizCard({
    required this.userId,
    required this.quizImageUrl,
    required this.quizTitle,
    required this.quizDescription,
    required this.quizId,
  });

  final DatabaseService databaseService = new DatabaseService();
  late String quizToken;
  String newTitle = "";
  String newDescription = "";

  /// Show a alert dialog to delete a quiz when
  /// the user has a long press on the quiz card
  showDeleteQuizAlert(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Are you sure?"),
            content: Text(
                "Your quiz is going to be deleted permanently and this action cannot be undone"),
            actions: <Widget>[
              TextButton(
                  child: Text(
                    "CANCEL",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              TextButton(
                  child: Text(
                    "DELETE",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    databaseService.deleteQuizData(userId, quizId);

                    /// Pop to hide the dialog
                    Navigator.pop(context);

                    /// Show confirmation
                    showGoodMessage(context, "Deleted quiz successfully");
                  }),
            ],
          );
        });
  }

  showEditQuizNameAlert(
      {required BuildContext context,
      required String quizId,
      required String quizTitle,
      required String quizDescription}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Rename quiz"),
            content: Form(
              child: Wrap(
                children: [
                  Text("Title"),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextFormField(
                    initialValue: quizTitle,
                    onChanged: (value) {
                      newTitle = value;
                    },
                  ),
                  SizedBox(
                    width: 200.0,
                    height: 24.0,
                  ),
                  Text("Description"),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      newDescription = value;
                    },
                    initialValue: quizDescription,
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  child: Text(
                    "CANCEL",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              TextButton(
                  child: Text(
                    "UPDATE",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    /// Pop to hide the dialog
                    Navigator.pop(context);

                    /// Update title and description
                    Map<String, String> newQuizName = {
                      "quizTitle": newTitle,
                      "quizDescription": newDescription
                    };
                    print("newQuizName: $newQuizName");

                    databaseService.updateQuizName(
                        newQuizName: newQuizName, quizId: quizId);

                    /// Show confirmation
                    showGoodMessage(context, "Renamed quiz successfully");
                  }),
            ],
          );
        });
  }

  // Show a bottom sheet with options
  showBottomSheet(BuildContext context) {
    quizToken = userId + "." + quizId;
    print(quizToken);
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
              title: Text(quizTitle),
            ),
            Divider(thickness: 1.0),
            ListTile(
              onTap: () async {
                /// Hide the bottom sheet
                Navigator.pop(context);

                /// Share token to global
                final String messageToShare =
                    "Copy and paste this token into your app, you will have access to the quiz's contents:\n $quizToken";
                await Share.share(messageToShare);
              },
              leading: Icon(
                Icons.share,
                color: kPrimaryColor,
              ),
              title: Text('Share'),
            ),
            ListTile(
              onTap: () async {
                await FlutterClipboard.copy(quizToken).then((value) {
                  /// Hide the bottom sheet
                  Navigator.pop(context);

                  /// Show confirmation
                  showGoodMessage(context, "Token copied to clipboard");
                });
              },
              leading: Icon(
                Icons.copy,
                color: kPrimaryColor,
              ),
              title: Text('Copy token'),
            ),
            ListTile(
              onTap: () {
                /// Hide the bottom sheet
                Navigator.pop(context);
                showEditQuizNameAlert(
                    context: context,
                    quizId: quizId,
                    quizTitle: quizTitle,
                    quizDescription: quizDescription);
              },
              leading: Icon(
                Icons.edit,
                color: kPrimaryColor,
              ),
              title: Text('Rename'),
            ),
            Divider(
              thickness: 1.0,
              indent: 72.0,
            ),
            ListTile(
              onTap: () {
                // Hide bottom sheet
                Navigator.pop(context);
                showDeleteQuizAlert(context);
              },
              leading: Icon(
                Icons.delete_outlined,
                color: kPrimaryColor,
              ),
              title: Text('Delete this quiz'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      height: 150,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(9.0),
            child: FadeInImage.assetNetwork(
              placeholder: kLoadingImage,
              image: quizImageUrl,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(9.0),
              highlightColor: Colors.transparent,
              splashColor: Colors.black26,
              radius: 1000.0,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlayQuiz(
                              quizId: quizId,
                              userId: userId,
                              quizTitle: quizTitle,
                            )));
              },
              onLongPress: () {
                showBottomSheet(context);
                // showOptionsAboutQuiz(context);
              },
              child: Container(
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
                        quizTitle,
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
                        quizDescription,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
