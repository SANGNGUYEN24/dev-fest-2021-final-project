import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  // reference to Quiz collection
  // final CollectionReference quizCollection = Firestore.instance.collection("Quiz");
  //
  // Future updateUserData(String name)async{
  //   return await quizCollection.document(uid).setData({
  //     "name" : name
  //   });
  // }

  Future<void> addQuizData(Map quizData, String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)  // documents -> doc
        .set(quizData) // setData -> set
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addQuestionData(Map questionData, String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId) // document -> doc
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
