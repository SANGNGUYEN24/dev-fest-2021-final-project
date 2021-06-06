import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  bool hadQuiz = false; // hadQuiz to check if the user had a quiz in your account (for display home screen),
  // the problem is cannot create a empty collection User quiz data to reference

  final String userID;
  DatabaseService({this.userID});

  //reference to Quiz collection
  final CollectionReference quizCollection = FirebaseFirestore.instance.collection("Quiz");

  Future updateUserData(String name, bool hadQuiz) async {
    return await quizCollection.doc(userID).set({
      "name" : name,
      "hadQuiz": hadQuiz,
    });
  }

  // addQuizData for each user
  // Future<void> addQuizData(Map quizData, String quizId) async {
  //   await FirebaseFirestore.instance
  //       .collection("Quiz")
  //       .doc(quizId)  // documents -> doc
  //       .set(quizData) // setData -> set
  //       .catchError((e) {
  //     print(e.toString());
  //   });
  // }
  Future<void> addQuizData(Map quizData, String userID, String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(userID).collection("User quiz data").doc(quizId) // documents -> doc
        .set(quizData) // setData -> set
        .catchError((e) {
      print(e.toString());
    });
  }
  
  

  // add question and answer for each quiz
  // Future<void> addQuestionData(Map questionData, String quizId) async {
  //   await FirebaseFirestore.instance
  //       .collection("Quiz")
  //       .doc(quizId) // document -> doc
  //       .collection("QNA")
  //       .add(questionData)
  //       .catchError((e) {
  //     print(e.toString());
  //   });
  // }

  Future<void> addQuestionData(Map questionData,String userID, String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(userID).collection("User quiz data").doc(quizId)
        .collection("QNA")
        .add(questionData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getQuizData() async {
    return await FirebaseFirestore.instance.collection("Quiz").snapshots();
  }

  getQuizDataToPlay(String quizId) async {
    return await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId) // document -> doc
        .collection("QNA")
        .get(); // getDocuments -> get
  }
}
