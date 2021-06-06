import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_maker_app/services/auth.dart';
import 'package:quiz_maker_app/services/database.dart';
import 'package:quiz_maker_app/views/create_quiz.dart';
import 'package:quiz_maker_app/views/play_quiz.dart';
import 'package:quiz_maker_app/widgets/widgets.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream quizStream;
  DatabaseService databaseService = new DatabaseService();
  // get uid from Firebase
  String userID = AuthService().getUserID();

  Widget quizList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder(
        stream: quizStream,
        builder: (context, snapshot) {
          return snapshot.data.docs(userID)["hadQuiz"] == false
              ? Container()
              : ListView.builder(
                  itemCount: snapshot.data.docs(userID).collection("User quiz data").docs.length,
                  itemBuilder: (context, index) {
                    return QuizCard(
                      //uid: ,
                        //imageUrl:
                            // snapshot.data.documents[index].data["quizImageUrl"]
                    ///        snapshot.data.docs[index]["quizImageUrl"],
                    ///    title: snapshot.data.docs[index]["quizTitle"],
                    ///     description: snapshot
                    ///         .data.docs[index]["quizDescription"],
                    /// quizId: snapshot.data.docs[index]["quizId"],
                      imageUrl: snapshot.data.docs[index].collection("User quiz data").docs[index]["quizImageUrl"],
                      title: snapshot.data.docs[index].collection("User quiz data").docs[index]["quizTitle"],
                      description: snapshot.data.docs[index].collection("User quiz data").docs[index]["quizDescription"],
                      quizId: snapshot.data.docs[index].collection("User quiz data").docs[index]["quizId"],

                        );
                  },
                );
        },
      ),
    );
  }

  @override
  void initState() {
    databaseService.getQuizData().then((val) {
      setState(() {
        quizStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      body: quizList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateQuiz()),
          );
        },
      ),
    );
  }
}

class QuizCard extends StatelessWidget {
  //add uid for each quiz
  //final String uid;
  final String imageUrl;
  final String title;
  final String description;
  final String quizId;

  QuizCard(
      {//@required this.uid,
        @required this.imageUrl,
      @required this.title,
      @required this.description,
      @required this.quizId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PlayQuiz(quizId: quizId,)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        height: 150,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: Image.network(
                imageUrl,
                width: MediaQuery.of(context).size.width - 48,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: Colors.black38,
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    description,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
