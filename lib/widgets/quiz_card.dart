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
  final String imageUrl;
  final String title;
  final String description;
  final String quizId;

  QuizCard({
    required this.userId,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.quizId,
  });

  //this.quizModel});

  final DatabaseService databaseService = new DatabaseService();
  late String quizToken;

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
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(50))),
              //   onPressed: () {
              //     databaseService.deleteQuizData(userId, quizId);
              //
              //     /// Pop to hide the dialog
              //     Navigator.pop(context);
              //
              //     /// Show confirmation
              //     showGoodMessage(context, "Deleted quiz successfully");
              //   },
              //   child: Text("DELETE"),
              // ),
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
              title: Text(title),
            ),
            Divider(thickness: 1.0),
            ListTile(
              onTap: () async {
                /// Hide the bottom sheet
                Navigator.pop(context);

                /// Share token to global
                /// TODO: write description for sharing token
                await Share.share(quizToken);
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
              image: imageUrl,
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
                              quizTitle: title,
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
              ),
            ),
          )
        ],
      ),
    );
  }
}
