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
class SharedQuizCard extends StatelessWidget {
  //final QuizModel quizModel;
  final String userId;
  final String imageUrl;
  final String title;
  final String description;
  final String quizId;

  SharedQuizCard({
    required this.userId,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.quizId,
  });

  final DatabaseService databaseService = new DatabaseService();

  // Show a bottom sheet with options
  showBottomSheet(BuildContext context) {
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
              onTap: () {},
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

  @override
  Widget build(BuildContext context) {
    return Container(
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
