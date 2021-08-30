///=============================================================================
/// @author sangnd
/// @date 29/08/2021
/// This files contains functions to communicate with the database service
///=============================================================================
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  FirebaseAuth _auth = FirebaseAuth.instance;

  String getUserID() {
    final User? user = _auth.currentUser;
    String uid = user!.uid;
    return uid;
  }

  Future<void> addUserInfo(String userName) async {
    Map<String, String> userInfo = {"name": userName};
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(getUserID())
        .set(userInfo);
  }

  Future<void> addQuizData(Map<String, dynamic> quizData, String quizId) async {
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

  Future<void> addQuestionData(
      Map<String, dynamic> questionData, String quizId) async {
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
