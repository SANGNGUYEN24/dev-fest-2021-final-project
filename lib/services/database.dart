import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  bool hadQuiz =
      false; // hadQuiz to check if the user had a quiz in your account (for display home screen),
  // the problem is cannot create a empty collection User quiz data to reference

  final String userID;

  DatabaseService({this.userID});

  //reference to Quiz collection

  final CollectionReference quizCollection =
      FirebaseFirestore.instance.collection("Quiz");

  FirebaseAuth _auth = FirebaseAuth.instance;

  String getUserID() {
    final User user = _auth.currentUser;
    String uid = user.uid;
    return uid;
  }

  Future updateUserData(String name, bool hadQuiz) async {
    return await quizCollection.doc(userID).set({
      "name": name,
      "hadQuiz": hadQuiz,
    });
  }

  Future<void> addQuizData(
      Map quizData, Map userIdMap, String userID, String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(userID)
        .set(userIdMap);
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(userID)
        .collection("User quiz data")
        .doc(quizId) // documents -> doc
        .set(quizData) // setData -> set
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addQuestionData(
      Map questionData, String userID, String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(userID)
        .collection("User quiz data")
        .doc(quizId)
        .collection("QNA")
        .add(questionData)
        .catchError((e) {
      print(e.toString());
    });
  }


  getQuizDataToPlay(String quizId) async {
    print('user ID------------${getUserID()}--------------');
      return await FirebaseFirestore.instance
          .collection("Quiz")
          .doc(getUserID())
          .collection("User quiz data")
          .doc(quizId)
          .collection("QNA")
          .get();
  }


}
