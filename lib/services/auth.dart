import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quiz_maker_app/models/user.dart';

class AuthService {
  final googleSignIn = GoogleSignIn();
  FirebaseAuth _auth = FirebaseAuth.instance;

  String getUserID() {
    final User? user = _auth.currentUser;
    String uid = user!.uid;
    return uid;
  }

  // User object based on FirebaseUser
  UserObject? _userFromFirebaseUser(User? user) {
    // ignore: unnecessary_null_comparison
    return user != null ? UserObject(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<UserObject?> get user {
    return _auth
        .authStateChanges()
        //map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser); // 2 lines are the same
  }

  // TODO consider where this function is used
  Future signOut() async {
    try {
      googleSignIn.disconnect();
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
