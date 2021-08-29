import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  FirebaseAuth _auth = FirebaseAuth.instance;

  String getUserID() {
    final User user = _auth.currentUser;
    String uid = user.uid;
    return uid;
  }

  Future<void> addUserInfo(String userName) async {
    Map<String, String> userInfo = {"name": userName};
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(getUserID())
        .set(userInfo);
  }

  Future<void> addQuizData(Map quizData, String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(getUserID())
        .collection("User quiz data")
        .doc(quizId)
        .set(quizData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addQuestionData(Map questionData, String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(getUserID())
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
