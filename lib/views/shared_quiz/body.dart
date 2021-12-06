import 'package:flutter/material.dart';
import 'package:quiz_maker_app/services/database.dart';
import 'package:quiz_maker_app/styles/constants.dart';
import 'package:quiz_maker_app/views/shared_quiz/components/shared_quiz_card.dart';

class Body extends StatefulWidget {
  Body({Key? key}) : super(key: key);
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final DatabaseService databaseService = new DatabaseService();
  late String userId;
  late String quizImageUrl;
  late String quizTitle;
  late String quizDescription;
  late String quizId;
  late bool _searched = false;
  late bool _validToken = false;

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    return Container(
      padding: EdgeInsets.all(24.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: kSecondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              controller: searchController,
              onSubmitted: (value) {
                /// Get information about search quiz
                setState(() {
                  _searched = true;
                });
                databaseService
                    .searchQuizDataWithToken(quizToken: value)
                    .then((doc) {
                  if (doc != null) {
                    setState(() {
                      _validToken = true;
                      userId = doc["userID"];
                      quizTitle = doc["quizTitle"];
                      quizImageUrl = doc["quizImageUrl"];
                      quizId = doc["quizId"];
                      quizDescription = doc["quizDescription"];
                    });
                    print(
                        "$quizId, $quizTitle, $quizDescription, $quizImageUrl, $userId");
                  }
                });
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  hintText: "Put quiz token here",
                  prefixIcon: Icon(Icons.search)),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 24.0),

            /// If user entered
            child: _searched

                /// and token is valid
                ? (_validToken
                    ? SharedQuizCard(
                        quizId: quizId,
                        imageUrl: quizImageUrl,
                        userId: userId,
                        title: quizTitle,
                        description: quizDescription,
                      )

                    /// Invalid Token
                    : CircularProgressIndicator())

                /// User have not searched yet
                : null,
          ),
          Container(
            child: _searched
                ? (_validToken
                    ? null
                    : Text("Invalid quiz token, please check again!"))
                : null,
          ),
        ],
      ),
    );
  }
}
