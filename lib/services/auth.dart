///=============================================================================
/// @author sangnd
/// @date 29/08/2021
/// This file helps get the user Id
///=============================================================================
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  String getUserID() {
    final User? user = _auth.currentUser;
    String uid = user!.uid;
    return uid;
  }
}
