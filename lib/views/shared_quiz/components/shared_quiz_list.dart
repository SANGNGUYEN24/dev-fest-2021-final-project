import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quiz_maker_app/models/quiz.dart';
import 'package:quiz_maker_app/services/database.dart';
import 'package:quiz_maker_app/styles/constants.dart';
import 'package:quiz_maker_app/views/shared_quiz/components/shared_quiz_card.dart';

class SharedQuizList extends StatefulWidget {
  final String appUserId;
  const SharedQuizList({Key? key, required this.appUserId}) : super(key: key);

  @override
  _SharedQuizListState createState() => _SharedQuizListState();
}

class _SharedQuizListState extends State<SharedQuizList> {
  // late String userId;
  // late String quizImageUrl;
  // late String quizTitle;
  // late String quizDescription;
  // late String quizId;
  final DatabaseService databaseService = new DatabaseService();
  List<dynamic> _sharedQuizTokenList = [];
  List<QuizModel> _sharedQuizInfoList = <QuizModel>[];

  @override
  void initState() {
    getSharedQuizTokenList();
    print("appUserId in ShareQuizList:${widget.appUserId}");
  }

  getSharedQuizTokenList() async {
    await databaseService
        .getAppUserDocument(appUserId: widget.appUserId)
        .then((value) {
      if (value!.data().containsKey("sharedQuiz")) {
        setState(() {
          _sharedQuizTokenList = value!["sharedQuiz"];
          print(_sharedQuizTokenList);
        });
        _getSharedQuizInfoList();
      }
    });
  }

  // Loop all quiz tokens and get quiz information to display
  _getSharedQuizInfoList() async {
    _sharedQuizTokenList.forEach((element) async {
      print("element: $element");
      await databaseService
          .searchQuizDataWithToken(quizToken: element)
          .then((doc) {
        print("quizId: ${doc!["quizId"]}");
        _sharedQuizInfoList.add(QuizModel(
            userId: doc!["userID"],
            quizTitle: doc!["quizTitle"],
            quizImageUrl: doc!["quizImageUrl"],
            quizId: doc!["quizId"],
            quizDescription: doc!["quizDescription"]));
      });
      setState(() {});
    });
    print("_sharedQuizInfoList: $_sharedQuizInfoList");
    return _sharedQuizInfoList;
  }

  @override
  Widget build(BuildContext context) {
    return _sharedQuizInfoList.length == 0
        ? Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    kEmptyImageQuizList,
                    height: 100,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Quizzes you saved appear here",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(
              "Your saved quizzes",
              style: TextStyle(color: kSecondaryColor),
            ),
            SizedBox(
              height: 8.0,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _sharedQuizInfoList.length,
                itemBuilder: (context, index) {
                  QuizModel quizModel = _sharedQuizInfoList[index];
                  return SharedQuizCard(
                      appUserId: widget.appUserId,
                      userId: quizModel.userId,
                      imageUrl: quizModel.quizImageUrl,
                      title: quizModel.quizTitle,
                      description: quizModel.quizDescription,
                      quizId: quizModel.quizId);
                },
              ),
            ),
          ]);
  }
}
