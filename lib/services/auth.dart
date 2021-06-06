import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_maker_app/models/user.dart';

import 'database.dart';

class AuthService {

  FirebaseAuth _auth = FirebaseAuth.instance;

  String getUserID() {
    final User user =  _auth.currentUser;
    String uid = user.uid;
    return uid;
  }

  // User object based on FirebaseUser
  Userne _userFromFirebaseUser(User user) {
    // ignore: unnecessary_null_comparison
    return user != null ? Userne(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<Userne> get user{
    return _auth.authStateChanges()
        //map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser); // 2 lines are the same
  }

  Future signInEmailAndPass(String email, String password) async {
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = authResult.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future signUpEmailAndPassword(String email, String password) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = authResult.user;

      // create a new document for user with uid and the name of the user
      await DatabaseService(userID: firebaseUser.uid).updateUserData("Sang", false);

      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
