///=============================================================================
/// @author sangnd
/// @date 29/08/2021
/// Home page of the app, it helps display quiz card list of each user
///=============================================================================
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quiz_maker_app/helper/functions.dart';
import 'package:quiz_maker_app/services/database.dart';
import 'package:quiz_maker_app/styles/constants.dart';
import 'package:quiz_maker_app/views/create_quiz.dart';
import 'package:quiz_maker_app/views/signin.dart';
import 'package:quiz_maker_app/widgets/quiz_card.dart';
import 'package:quiz_maker_app/widgets/widgets.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth _user = FirebaseAuth.instance;
  DatabaseService databaseService = DatabaseService();
  String userId = DatabaseService().getUserID();
  Stream<QuerySnapshot<Object?>>? _stream;

  /// At the beginning, create a stream for query user's quiz data
  /// This stream will be used in the ListBuilder to display a quiz card list
  @override
  void initState() {
    super.initState();

    databaseService.getThumbnail();

    /// Get the thumbnail list
    //databaseService.getThumbnail();
    _stream = databaseService.quizCollectionRef
        .doc(userId)
        .collection("User quiz data")
        .snapshots();
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

  Future<bool> _onBackPressed(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Exit BKQuiz?'),
            content: new Text('Goodbye, see you later'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.black87,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                onPressed: () => SystemNavigator.pop(),
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;
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
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return QuizCard(
                          userId: userId,
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

  /// The UI of the page
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        final popUp = _onBackPressed(context);
        return popUp;
      },
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: appBarTitle(context),
          backgroundColor: Colors.white,
          elevation: 0.0,
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
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.edit_outlined),
          label:
              Text("Add a quiz", style: TextStyle(fontWeight: FontWeight.bold)),
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
      ),
    );
  }
}
