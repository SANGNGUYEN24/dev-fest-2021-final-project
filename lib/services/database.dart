///=============================================================================
/// @author sangnd
/// @date 29/08/2021
/// This files contains functions to communicate with the database service
///=============================================================================
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  // Quiz -> userId -> User quiz data -> quizId -> QNA -> questionId
  static const String USER_QUIZ_DATA_NAME = "User quiz data";
  static const String QUIZ_COLLECTION_NAME = "Quiz";
  static const String QNA_SUB_COLLECTION_NAME = "QNA";
  static const String THUMBNAILS_COLLECTION_NAME = "Thumbnails";
  static const String THUMBNAILS_DOC_NAME = "thumbnailList";

  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference quizCollectionRef =
      FirebaseFirestore.instance.collection(QUIZ_COLLECTION_NAME);
  DocumentReference thumbnailDocumentRef = FirebaseFirestore.instance
      .collection(THUMBNAILS_COLLECTION_NAME)
      .doc(THUMBNAILS_DOC_NAME);

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
        .collection(USER_QUIZ_DATA_NAME)
        .doc(quizId)
        .set(quizData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> deleteQuizData(String userID, String quizId) async {
    await quizCollectionRef
        .doc(getUserID())
        .collection(USER_QUIZ_DATA_NAME)
        .doc(quizId)
        .delete();
  }

  Future<void> addQuestionData(
      Map<String, dynamic> questionData, String quizId) async {
    await quizCollectionRef
        .doc(getUserID())
        .collection(USER_QUIZ_DATA_NAME)
        .doc(quizId)
        .collection(QNA_SUB_COLLECTION_NAME)
        .add(questionData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> getThumbnail() async {
    try {
      var thumbnailDocumentSnapshot = await thumbnailDocumentRef.get();
      thumbnailAddressList = thumbnailDocumentSnapshot["addressList"];
    } catch (e) {
      print(e.toString());
    }
  }
  //
  // String getDocumentPath({required String userId, required String quizId}) {
  //   // String path = quizCollectionRef
  //   //     .doc(getUserID())
  //   //     .collection(USER_QUIZ_DATA_NAME)
  //   //     .doc(quizId)
  //   //     .path
  //   //     .toString();
  //   String path = userId + "." + quizId;
  //   print(path);
  //   return path;
  // }

  // Get share quiz data, user input a string in text field
  getSharedQuizData({required path}) async {
    // Split path into 2 parts: userId and quizId
    List<String> userIdAndquizId = path.split(".");
    print(userIdAndquizId);
    print(userIdAndquizId[0]);
    print(userIdAndquizId[1]);
  }

  getQuizDataToPlay(String quizId) async {
    print("[----userId: ${getUserID()}----]");
    return await quizCollectionRef
        .doc(getUserID())
        .collection(USER_QUIZ_DATA_NAME)
        .doc(quizId)
        .collection(QNA_SUB_COLLECTION_NAME)
        .get();
  }
}
