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
class SharedQuizCard extends StatelessWidget {
  //final QuizModel quizModel;
  final String appUserId;
  final String userId;
  final String imageUrl;
  final String title;
  final String description;
  final String quizId;

  SharedQuizCard({
    required this.appUserId,
    required this.userId,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.quizId,
  });

  final DatabaseService databaseService = new DatabaseService();
  late String quizToken;

  // Show a bottom sheet with options
  void showBottomSheet(BuildContext context) {
    quizToken = userId + "." + quizId;
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
            Divider(
              thickness: 1.0,
            ),
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
            Divider(
              thickness: 1.0,
              indent: 72.0,
            ),
            ListTile(
              onTap: () {
                /// Except the situation host user save his own quiz
                // Hide the bottom sheet
                Navigator.pop(context);
                if (appUserId != userId) {
                  saveSharedQuiz(
                      context: context,
                      appUserId: appUserId,
                      quizToken: quizToken);

                  // Show confirmation
                  showGoodMessage(
                      context, "This quiz is saved, refresh the screen");
                } else {
                  showNotGoodMessage(context, "Opps... This is your own quiz");
                }
              },
              leading: Icon(
                Icons.star_border,
                color: kPrimaryColor,
              ),
              title: Text('Save this quiz'),
            ),
          ],
        );
      },
    );
  }

  // Save shared quiz to db
  void saveSharedQuiz(
      {required BuildContext context,
      required String appUserId,
      required String quizToken}) {
    databaseService.saveSharedQuiz(appUserId: appUserId, quizToken: quizToken);
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
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9.0),
                  color: Colors.black26,
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 30,
                    left: 30,
                  ),
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
