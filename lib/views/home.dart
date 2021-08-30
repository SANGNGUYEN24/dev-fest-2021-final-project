///=============================================================================
/// @author sangnd
/// @date 29/08/2021
/// Home page of the app, it helps display quiz card list of each user
///=============================================================================
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quiz_maker_app/helper/functions.dart';
import 'package:quiz_maker_app/services/auth.dart';
import 'package:quiz_maker_app/styles/constants.dart';
import 'package:quiz_maker_app/views/create_quiz.dart';
import 'package:quiz_maker_app/views/play_quiz.dart';
import 'package:quiz_maker_app/views/signin.dart';
import 'package:quiz_maker_app/widgets/widgets.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth _user = FirebaseAuth.instance;
  String userID = AuthService().getUserID();
  Stream<QuerySnapshot<Object?>>? _stream;

  /// At the beginning, create a stream for query user's quiz data
  /// This stream will be used in the ListBuilder to display a quiz card list
  @override
  void initState() {
    _stream = FirebaseFirestore.instance
        .collection("Quiz")
        .doc(userID)
        .collection("User quiz data")
        .snapshots();
    super.initState();
  }

  /// The function to show a snackBar for confirming sign out action for the user
  confirmSignOut() {
    final snackBar = SnackBar(
      elevation: 2.0,
      behavior: SnackBarBehavior.fixed,
      content: Text("Do you want to sign out?"),
      action: SnackBarAction(
        label: "SIGN OUT",
        onPressed: () {
          _user.signOut();
          HelperFunctions.saveUserLoggedInDetail(isLoggedIn: false);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SignIn()));
        },
      ),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  /// The UI of the page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              confirmSignOut();
            },
            icon: Icon(
              Icons.logout,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: quizList(),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add a new quiz",
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateQuiz(
                      key: null,
                    )),
          );
        },
      ),
    );
  }

  /// List of the quiz cards will be got here
  Widget quizList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return (snapshot.data == null)
              ? Center(child: CircularProgressIndicator())
              : ((snapshot.data!.docs.length <= 0)
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
                              "Quizzes you add appear here",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return QuizCard(
                          uid: userID,
                          imageUrl: snapshot.data!.docs[index]["quizImageUrl"],
                          title: snapshot.data!.docs[index]["quizTitle"],
                          description: snapshot.data!.docs[index]
                              ["quizDescription"],
                          quizId: snapshot.data!.docs[index]["quizId"],
                        );
                      },
                    ));
        },
      ),
    );
  }
}

/// The information of each quiz is got here and displayed as a clickable card
/// When user click a quiz card, navigate to [PlayQuiz]
class QuizCard extends StatelessWidget {
  final String uid;
  final String imageUrl;
  final String title;
  final String description;
  final String quizId;

  QuizCard(
      {required this.uid,
      required this.imageUrl,
      required this.title,
      required this.description,
      required this.quizId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlayQuiz(
                      quizId: quizId,
                      userID: uid,
                    )));
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
                          fontWeight: FontWeight.w500),
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
