///=============================================================================
/// @author sangnd
/// @date 29/08/2021
/// This files contains functions to communicate with the database service
///=============================================================================
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference quizCollectionRef =
      FirebaseFirestore.instance.collection("Quiz");
  DocumentReference thumbnailDocumentRef =
      FirebaseFirestore.instance.collection("Thumbnails").doc("thumbnailList");

  /// A list of thumbnail will be get at [Home] screen
  /// through initState function and mark as static
  static late List<dynamic> thumbnailAddressList = [];

  //TODO timestamp for quiz

  String getUserID() {
    final User? user = _auth.currentUser;
    String userId = user!.uid;
    return userId;
  }

  Future<void> addUserInfo(String? userName) async {
    Map<String, String?> userInfo = {"name": userName};
    await quizCollectionRef.doc(getUserID()).set(userInfo);
  }

  Future<void> addQuizData(Map<String, dynamic> quizData, String quizId) async {
    await quizCollectionRef
        .doc(getUserID())
        .collection("User quiz data")
        .doc(quizId)
        .set(quizData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future deleteQuizData(String userID, String quizId) async {
    await quizCollectionRef
        .doc(getUserID())
        .collection("User quiz data")
        .doc(quizId)
        .delete();
  }

  Future<void> addQuestionData(
      Map<String, dynamic> questionData, String quizId) async {
    await quizCollectionRef
        .doc(getUserID())
        .collection("User quiz data")
        .doc(quizId)
        .collection("QNA")
        .add(questionData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> updateQuestionData(Map<String, dynamic> questionData,
      String quizId, String questionId) async {
    await quizCollectionRef
        .doc(getUserID())
        .collection("User quiz data")
        .doc(quizId)
        .collection("QNA")
        .doc(questionId)
        .update(questionData)
        .catchError((err) => print(err.toString()));
  }

  Future<void> deleteQuestionData(String quizId, String questionId) async {
    await quizCollectionRef
        .doc(getUserID())
        .collection("User quiz data")
        .doc(quizId)
        .collection("QNA")
        .doc(questionId)
        .delete()
        .catchError((err) => print(err.toString()));
  }

  getQuizDataToPlay(String quizId) async {
    print("[----userId: ${getUserID()}----]");
    return await quizCollectionRef
        .doc(getUserID())
        .collection("User quiz data")
        .doc(quizId)
        .collection("QNA")
        .get();
  }

  Future<void> getThumbnail() async {
    try {
      var thumbnailDocumentSnapshot = await thumbnailDocumentRef.get();
      thumbnailAddressList = thumbnailDocumentSnapshot["addressList"];
    } catch (e) {
      print(e.toString());
    }
  }
}
