import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_maker_app/models/user.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  // User object based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    // ignore: unnecessary_null_comparison
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user{
    return _auth.onAuthStateChanged
        //map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser); // 2 lines are the same
  }

  Future signInEmailAndPass(String email, String password) async {
    try {
      AuthResult authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = authResult.user;
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
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = authResult.user;
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
