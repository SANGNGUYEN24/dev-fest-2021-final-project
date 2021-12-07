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

  String getAppUserId() {
    final User? user = _auth.currentUser;
    String userId = user!.uid;
    return userId;
  }

  Future<void> getThumbnail() async {
    try {
      var thumbnailDocumentSnapshot = await thumbnailDocumentRef.get();
      thumbnailAddressList = thumbnailDocumentSnapshot["addressList"];
    } catch (e) {
      print(e.toString());
    }
  }

  // Get quiz data to play
  getQuizDataToPlay({required String userId, required String quizId}) async {
    return await quizCollectionRef
        .doc(userId)
        .collection(USER_QUIZ_DATA_NAME)
        .doc(quizId)
        .collection(QNA_SUB_COLLECTION_NAME)
        .get();
  }

  // Get shared quiz array
  getAppUserDocument({required String appUserId}) async {
    return await quizCollectionRef.doc(appUserId).get();
  }

  Future<void> addUserInfo(String? userName) async {
    Map<String, String?> userInfo = {"name": userName};
    await quizCollectionRef.doc(getAppUserId()).update(userInfo);
  }

  Future<void> addQuizData(Map<String, dynamic> quizData, String quizId) async {
    await quizCollectionRef
        .doc(getAppUserId())
        .collection(USER_QUIZ_DATA_NAME)
        .doc(quizId)
        .set(quizData)
        .catchError((e) {
      print(e.toString());
    });
  }

  // Add question data to quiz
  Future<void> addQuestionData(
      Map<String, dynamic> questionData, String quizId) async {
    await quizCollectionRef
        .doc(getAppUserId())
        .collection(USER_QUIZ_DATA_NAME)
        .doc(quizId)
        .collection(QNA_SUB_COLLECTION_NAME)
        .add(questionData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> deleteQuizData(String userID, String quizId) async {
    await quizCollectionRef
        .doc(getAppUserId())
        .collection(USER_QUIZ_DATA_NAME)
        .doc(quizId)
        .delete();
  }

  // Add quiz token to the db
  Future<void> saveSharedQuiz(
      {required String appUserId, required String quizToken}) async {
    await quizCollectionRef.doc(appUserId).update({
      "sharedQuiz": FieldValue.arrayUnion([quizToken])
    });
  }

  // Search quiz data with quizToken
  searchQuizDataWithToken({required String quizToken}) async {
    // Split path into 2 parts separate by a dot ".": userId and quizId
    if (!quizToken.contains(".")) return null;
    List<String> userIdAndQuizId = quizToken.split(".");
    final String userId = userIdAndQuizId[0];
    final String quizId = userIdAndQuizId[1];
    return await quizCollectionRef
        .doc(userId)
        .collection(USER_QUIZ_DATA_NAME)
        .doc(quizId)
        .get();
  }

  // Update quiz title and description
  Future<void> updateQuizName(
      {required Map<String, String> newQuizName,
      required String quizId}) async {
    await quizCollectionRef
        .doc(getAppUserId())
        .collection(USER_QUIZ_DATA_NAME)
        .doc(quizId)
        .update(newQuizName);
  }
}
