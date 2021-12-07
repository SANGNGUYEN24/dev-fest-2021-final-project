import 'package:flutter/material.dart';
import 'package:quiz_maker_app/services/database.dart';
import 'package:quiz_maker_app/styles/constants.dart';
import 'package:quiz_maker_app/views/shared_quiz/components/shared_quiz_card.dart';

import 'components/shared_quiz_list.dart';

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
  String _appUserId = ""; // userId of the user using the app

  @override
  void initState() {
    /// Get userId of the user using the app for saving shared quiz
    getAppUserId();
  }

  // getAppUserId() {
  //   HelperFunctions.getUserId().then((value) {
  //     setState(() {
  //       print("_appUserId $value");
  //       _appUserId = value!;
  //     });
  //   });
  // }
  getAppUserId() {
    _appUserId = databaseService.getAppUserId();
    setState(() {
      print("_appUserId in Body: $_appUserId");
    });
  }

  void getQuizInfo(dynamic doc) {
    if (doc != null) {
      setState(() {
        _validToken = true;
        userId = doc["userID"];
        quizTitle = doc["quizTitle"];
        quizImageUrl = doc["quizImageUrl"];
        quizId = doc["quizId"];
        quizDescription = doc["quizDescription"];
      });
      print("$quizId, $quizTitle, $quizDescription, $quizImageUrl, $userId");
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    return Container(
      padding: EdgeInsets.all(24.0),
      child: Column(
        children: [
          /// Search field
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
                  getQuizInfo(doc);
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

          /// Handle errors
          Container(
            padding: EdgeInsets.only(top: 16.0),

            /// If user entered
            child: _searched

                /// and token is valid
                ? (_validToken
                    ? SharedQuizCard(
                        appUserId: _appUserId,
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
          Divider(),
          Expanded(child: SharedQuizList(appUserId: _appUserId)),
        ],
      ),
    );
  }
}
